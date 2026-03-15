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
  cfg = config.${namespace}.apps.anki;
in {
  options.${namespace}.apps.anki = with types; {
    enable = mkBoolOpt false "Whether or not to enable anki.";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [anki];};
}
