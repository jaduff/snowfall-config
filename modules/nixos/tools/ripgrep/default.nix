{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cli-apps.ripgrep;
in
{
  options.${namespace}.cli-apps.ripgrep = {
    enable = mkEnableOption "ripgrep";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ plusultra.ripgrep ]; };
}
