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
  cfg = config.${namespace}.tools.nvtop;
in {
  options.${namespace}.tools.nvtop = with types; {
    enable = mkBoolOpt false "Whether or not to enable nvtop.";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [nvtopPackages.full];};
}
