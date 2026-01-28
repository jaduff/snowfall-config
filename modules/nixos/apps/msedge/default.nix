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
  cfg = config.${namespace}.apps.microsoft-edge;
in {
  options.${namespace}.apps.microsoft-edge = with types; {
    enable = mkBoolOpt false "Whether or not to enable microsoft-edge.";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [microsoft-edge];};
}
