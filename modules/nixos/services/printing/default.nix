{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.services.printing;
in
{
  options.${namespace}.services.printing = with types; {
    enable = mkBoolOpt false "Whether or not to configure printing support.";
  };

  config = mkIf cfg.enable {
    services.printing.enable = true;
    environment.systemPackages = with pkgs; [
	gutenprint
	fflinuxprint
	fxlinuxprint
	cups-kyodialog
	gutenprintBin
	hplip
    ];
    services.printing.drivers = with pkgs; [
	foomatic-db-ppds-withNonfreeDb
	fflinuxprint
	gutenprint
	hplip
	cups-pdf-to-pdf
	gutenprint
	fflinuxprint
	fxlinuxprint
	cups-kyodialog
	gutenprintBin
    ];
  };
}
