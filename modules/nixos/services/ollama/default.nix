{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.services.ollama;
in {
  options.${namespace}.services.ollama = with types; {
    enable = mkBoolOpt false "Whether or not to enable ollama.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ oterm ];
	services.ollama = {
	  enable = true;
	  acceleration = "cuda";
          listenAddress = "0.0.0.0:11434";
    };
};
}
