{
  lib,
  config,
  options,
  namespace,
  pkgs,
  ...
}: let
  cfg = config.${namespace}.services.syncthing.ignorant;

  inherit (lib) types mkEnableOption mkIf;
in {
  options.${namespace}.services.syncthing.ignorant = with types; {
    enable = mkEnableOption "ignorant";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      syncthing
    ];
    sops.secrets.ignorant-keyfile= {
      sopsFile = ../secrets.yaml;
      path = "/home/jaduff/.local/state/syncthing/key.pem";
      owner = "jaduff";
    };
    sops.secrets.ignorant-certfile = {
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
            raspberry_pi = {id = "XRZRSGF-57PTWT4-EY2D3WV-RMS5COL-TN6ZRCH-B5PLF5X-OIVULXP-J2GONQL";};
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
