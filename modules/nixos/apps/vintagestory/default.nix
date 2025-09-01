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
  cfg = config.${namespace}.apps.vintagestory;
in {
  options.${namespace}.apps.vintagestory = with types; {
    enable = mkBoolOpt false "Whether or not to enable vintagestory.";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [unstable.vintagestory];};
}
