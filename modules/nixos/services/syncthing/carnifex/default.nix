{
  lib,
  config,
  options,
  namespace,
  pkgs,
  ...
}: let
  cfg = config.${namespace}.services.syncthing.carnifex;

  inherit (lib) types mkEnableOption mkIf;
in {
  options.${namespace}.services.syncthing.carnifex = with types; {
    enable = mkEnableOption "carnifex";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      syncthing
    ];
    sops.secrets.carnifex-keyfile= {
      sopsFile = ../secrets.yaml;
      path = "/home/jaduff/.local/state/syncthing/key.pem";
      owner = "jaduff";
    };
    sops.secrets.carnifex-certfile = {
      sopsFile = ../secrets.yaml;
      path = "/home/jaduff/.local/state/syncthing/cert.pem";
      owner = "jaduff";
    };
    services.syncthing = {
        enable = true;
	user = "jaduff";
	dataDir = "/home/jaduff/Documents";
	configDir = "/home/jaduff/Documents/.config/syncthing";
        settings = {
          devices = {
            raspberry_pi = {id = "CYHA55W-C3LV2ZA-A2IXLFT-KC2A3MC-BEIRJGM-GYVS3QD-LN765BZ-OOZKDA2";};
          };
          folders ={
           silverbullet-home = {
             path = "/home/jaduff/Nextcloud/Documents/silverbullet-home/";
             devices = [ "raspberry_pi" ];
           };
           silverbullet-school = {
             path = "/home/jaduff/Nextcloud/Documents/silverbullet-school/";
             devices = [ "raspberry_pi" ];
           };
          };
        };
      };

    };
}
