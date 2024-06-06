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
  cfg = config.${namespace}.apps.kdeconnect;
in {
  options.${namespace}.apps.kdeconnect = with types; {
    enable = mkBoolOpt false "Whether or not to enable kdeconnect.";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [kdeconnect];};
}
