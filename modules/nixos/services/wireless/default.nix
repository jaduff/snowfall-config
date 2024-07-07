{
  lib,
  config,
  options,
  namespace,
  pkgs,
  ...
}: let
  cfg = config.${namespace}.services.wireless;

  inherit (lib) types mkEnableOption mkIf;
in {
  options.${namespace}.services.wireless = with types; {
    enable = mkEnableOption "wireless";
  };
  config = mkIf cfg.enable {
    sops.secrets.wireless = {
      sopsFile = ./secrets.yaml;
      mode ="0440";
      owner = "jaduff";
    };
    networking.networkmanager.enable = lib.mkForce false;
    networking.wireless = {
      enable = true;
      fallbackToWPA2 = true;
      # Declarative
      environmentFile = config.sops.secrets.wireless.path;
      networks = {
        "TelstraE18CC3" = {
          psk = "@JTelstraE18CC@";
        };

      };
      # Imperative
      allowAuxiliaryImperativeNetworks = true;
      userControlled = {
        enable = true;
        group = "network";
      };
      extraConfig = ''
        update_config=1
      '';
      };

  # Ensure group exists
  users.groups.network = {};

  systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";

  };
}
