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
  cfg = config.${namespace}.apps.borgbackup;
in {
  options.${namespace}.apps.borgbackup = with types; {
    enable = mkBoolOpt false "Whether or not to enable borgbackup.";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [borgbackup];};
}
