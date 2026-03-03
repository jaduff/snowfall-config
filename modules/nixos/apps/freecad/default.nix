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
  cfg = config.${namespace}.apps.freecad;
in
{
  options.${namespace}.apps.freecad = with types; {
    enable = mkBoolOpt false "Whether or not to enable freecad.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs;
   [ (freecad.overrideAttrs (oldAttrs: {
      preHook = (oldAttrs.preHook or "") + "\nexport QT_QPA_PLATFORM=xcb\n";
    }))
  ];
  };
}
