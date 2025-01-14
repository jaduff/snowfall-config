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
  cfg = config.${namespace}.services.flatpak;
in {
  options.${namespace}.services.flatpak = with types; {
    enable = mkBoolOpt false "Whether or not to enable flatpak.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ flatpak];
	services.flatpak = {
	  enable = true;
    };
};
}
