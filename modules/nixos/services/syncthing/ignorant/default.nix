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
    #environment.systemPackages = with pkgs; [
    #];
    sops.secrets.ignorant-keyfile= {
      sopsFile = ../secrets.yaml;
      owner = "jaduff";
      mode = "0440";
    };
    sops.secrets.ignorant-certfile = {
      sopsFile = ../secrets.yaml;
      owner = "jaduff";
      mode = "0440";
    };
    networking.firewall.allowedTCPPorts = [ 8384 22000 ];
    networking.firewall.allowedUDPPorts = [ 22000 21027 ];
    services.syncthing = {
        enable = true;
	user = "jaduff";
	dataDir = "/home/jaduff/Documents";
	configDir = "/home/jaduff/.local/state/syncthing";
        key = config.sops.secrets.ignorant-keyfile.path;
        cert = config.sops.secrets.ignorant-certfile.path;
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
