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
    sops.secrets.carnifex-keyfile= {
      sopsFile = ../secrets.yaml;
      mode ="0440";
      owner = "jaduff";
    };
    sops.secrets.carnifex-certfile = {
      sopsFile = ../secrets.yaml;
      mode ="0440";
      owner = "jaduff";
    };
    networking.firewall.allowedTCPPorts = [ 8384 22000 ];
    networking.firewall.allowedUDPPorts = [ 22000 21027 ];
    services.syncthing = {
        enable = true;
	user = "jaduff";
	dataDir = "/home/jaduff/Documents";
	configDir = "/home/jaduff/Documents/.config/syncthing";
        key = config.sops.secrets.carnifex-keyfile.path;
        cert = config.sops.secrets.carnifex-certfile.path;
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
