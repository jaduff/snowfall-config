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
  cfg = config.${namespace}.apps.btop;
in {
  options.${namespace}.apps.btop = with types; {
    enable = mkBoolOpt false "Whether or not to enable btop.";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [btop];};
}
