{
  lib,
  config,
  options,
  namespace,
  ...
}: let
  cfg = config.${namespace}.services.syncthing;

  inherit (lib) types mkEnableOption mkIf;
in {
  options.${namespace}.services.syncthing = with types; {
    enable = mkEnableOption "Syncthing";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
        enable = true;
	user = "jaduff";
	dataDir = "/home/jaduff/Documents";
	configDir = "/home/jaduff/Documents/.config/syncthing";
      };

    };
}
