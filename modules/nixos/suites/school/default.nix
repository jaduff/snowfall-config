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
  cfg = config.${namespace}.suites.school;
in {
  options.${namespace}.suites.school = with types; {
    enable = mkBoolOpt false "Whether or not to enable school configuration.";
  };

  config =
    mkIf cfg.enable {plusultra = {apps = {
      work-printers = enabled;
    };};};
}
