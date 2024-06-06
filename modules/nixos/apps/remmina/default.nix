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
  cfg = config.${namespace}.apps.remmina;
in {
  options.${namespace}.apps.remmina = with types; {
    enable = mkBoolOpt false "Whether or not to enable remmina.";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [remmina];};
}
