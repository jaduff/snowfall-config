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
  cfg = config.${namespace}.tools.dig;
in {
  options.${namespace}.tools.dig = with types; {
    enable = mkBoolOpt false "Whether or not to enable dig.";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [dig];};
}
