{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.steam;
in
{
  options.${namespace}.apps.steam = with types; {
    enable = mkBoolOpt false "Whether or not to enable support for Steam.";
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;
    programs.steam.remotePlay.openFirewall = true;
    networking.firewall.allowedTCPPorts = [27040 6073];
    networking.firewall.allowedTCPPortRanges = [{from=2300;to=2400;}];
    networking.firewall.allowedUDPPorts = [47630 6073];
    networking.firewall.allowedUDPPortRanges = [{ from=27031; to=27036; } {from=2300; to=2400;}];
    hardware.steam-hardware.enable = true;

    # Enable GameCube controller support.
    services.udev.packages = [ pkgs.dolphinEmu ];

    environment.systemPackages = with pkgs.plusultra; [ steam ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    };
  };
}
