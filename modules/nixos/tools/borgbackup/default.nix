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
  cfg = config.${namespace}.tools.borgbackup;
in {
  options.${namespace}.tools.borgbackup = with types; {
    enable = mkBoolOpt false "Whether or not to enable borgbackup.";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [borgbackup];};
}
