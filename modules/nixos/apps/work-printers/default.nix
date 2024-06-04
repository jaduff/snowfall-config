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
  cfg = config.${namespace}.apps.work-printers;
in {
  options.${namespace}.apps.work-printers = with types; {
    enable = mkBoolOpt false "Whether or not to enable Protontricks.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [gutenprint fflinuxprint fxlinuxprint cups-kyodialog ];
  };
}
