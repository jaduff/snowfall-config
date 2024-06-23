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
  cfg = config.${namespace}.services.work-printers;
in {
  options.${namespace}.services.work-printers = with types; {
    enable = mkBoolOpt false "Whether or not to enable Protontricks.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [gutenprint fflinuxprint fxlinuxprint cups-kyodialog gutenprintBin hplip];
    services.printing.drivers = with pkgs; [ foomatic-db-ppds-withNonfreeDb fflinuxprint gutenprint hplip cups-pdf-to-pdf gutenprint fflinuxprint fxlinuxprint cups-kyodialog gutenprintBin];
  };
}
