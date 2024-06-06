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
  cfg = config.${namespace}.apps.kcalc;
in {
  options.${namespace}.apps.kcalc = with types; {
    enable = mkBoolOpt false "Whether or not to enable kcalc.";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [kcalc];};
}
