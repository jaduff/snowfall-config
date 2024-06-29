{
  lib,
  config,
  options,
  namespace,
  pkgs,
  ...
}: let
  cfg = config.${namespace}.services.syncthing;

  inherit (lib) types mkEnableOption mkIf;
in {
  options.${namespace}.services.syncthing = with types; {
    enable = mkEnableOption "Syncthing";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      syncthing
    ];
    services.syncthing = {
        enable = true;
	user = "jaduff";
	dataDir = "/home/jaduff/Documents";
	configDir = "/home/jaduff/Documents/.config/syncthing";
        settings = {
          devices = {
            raspberry_pi = {id = "CYHA55W-C3LV2ZA-A2IXLFT-KC2A3MC-BEIRJGM-GYVS3QD-LN765BZ-OOZKDA2";};
          };
        };
      };

    };
}
