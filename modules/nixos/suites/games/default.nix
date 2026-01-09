{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.suites.games;
  apps = {
    steam = enabled;
    lutris = enabled;
    winetricks = enabled;
    protontricks = enabled;
  };
  cli-apps = {
    wine = enabled;
  };
in
{
  options.${namespace}.suites.games = with types; {
    enable = mkBoolOpt false "Whether or not to enable common games configuration.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      inherit apps cli-apps;
    };
  };
}
