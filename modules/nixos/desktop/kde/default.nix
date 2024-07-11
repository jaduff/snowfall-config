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
  cfg = config.${namespace}.desktop.kde;


  default-attrs = mapAttrs (key: mkDefault);
  nested-default-attrs = mapAttrs (key: default-attrs);
in {
  options.${namespace}.desktop.kde= with types; {
    enable =
      mkBoolOpt false "Whether or not to use KDE as the desktop environment.";
    wallpaper = {
      light = mkOpt (oneOf [str package]) pkgs.plusultra.wallpapers.nord-rainbow-light-nix "The light wallpaper to use.";
      dark = mkOpt (oneOf [str package]) pkgs.plusultra.wallpapers.nord-rainbow-dark-nix "The dark wallpaper to use.";
    };
    color-scheme = mkOpt (enum ["light" "dark"]) "dark" "The color scheme to use.";
    wayland = mkBoolOpt true "Whether or not to use Wayland.";
    suspend =
      mkBoolOpt true "Whether or not to suspend the machine after inactivity.";
    monitors = mkOpt (nullOr path) null "The monitors.xml file to create.";
    extensions = mkOpt (listOf package) [] "Extra Gnome extensions to install.";
  };

  config = mkIf cfg.enable {
    plusultra.system.xkb.enable = true;
    plusultra.desktop.addons = {
      wallpapers = enabled;
    };
    services.desktopManager.plasma6.enable = true;

    services.xserver = {
      enable = true;
    };
    services.displayManager.sddm.wayland.enable = true;


    programs.kdeconnect = {
      enable = true;
    };

    # Open firewall for samba connections to work.
    networking.firewall.extraCommands = "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";
  };
}
