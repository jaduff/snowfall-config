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
  cfg = config.${namespace}.suites.office;
in {
  options.${namespace}.suites.office = with types; {
    enable = mkBoolOpt false "Whether or not to enable office configuration.";
  };

  config =
    mkIf cfg.enable {plusultra = {apps = {
      libreoffice-qt-fresh = enabled;
      masterpdfeditor = enabled;
      kcalc = enabled;
      protonvpn-gui = enabled;
      remmina = enabled;
      borgbackup = enabled;
    };};};
}
