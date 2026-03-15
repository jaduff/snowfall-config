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
  cfg = config.${namespace}.tools.piper;
in
{
  options.${namespace}.tools.piper = with types; {
    enable = mkBoolOpt false "Whether or not to enable Piper.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [ piper libratbag ];
  services.ratbagd = {
    enable = true;
    };
    };
}
