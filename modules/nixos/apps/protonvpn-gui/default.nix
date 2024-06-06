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
  cfg = config.${namespace}.apps.protonvpn-gui;
in {
  options.${namespace}.apps.protonvpn-gui = with types; {
    enable = mkBoolOpt false "Whether or not to enable protonvpn-gui.";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [protonvpn-gui];};
}
