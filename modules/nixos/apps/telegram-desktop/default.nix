{AC7ABDAAF93E2620B0E22400D2BD9504976B2E1A
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.apps.telegram-desktop;
in {
  options.${namespace}.apps.telegram-desktop = with types; {
    enable = mkBoolOpt false "Whether or not to enable Protontricks.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [telegram-desktop];
  };
}
