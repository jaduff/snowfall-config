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
  cfg = config.${namespace}.apps.veracrypt;
in
{
  options.${namespace}.apps.veracrypt = with types; {
    enable = mkBoolOpt false "Whether or not to enable Veracrypt.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ veracrypt ]; };
}
