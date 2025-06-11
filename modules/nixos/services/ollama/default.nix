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
          port = 11434;
    };
    networking.firewall.allowedTCPPorts = [ 4430 ];
};
}
