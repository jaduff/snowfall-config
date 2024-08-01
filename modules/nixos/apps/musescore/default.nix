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
  cfg = config.${namespace}.apps.musescore;
in {
  options.${namespace}.apps.musescore = with types; {
    enable = mkBoolOpt false "Whether or not to enable musescore.";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [musescore];};
}
