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
  cfg = config.${namespace}.archetypes.school;
in {
  options.${namespace}.archetypes.school = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable the school archetype.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      suites = {
        common = enabled;
        desktop = enabled;
        development = enabled;
        art = enabled;
        video = enabled;
        social = enabled;
        media = enabled;
        office = enabled;
        school = enabled;
      };

      tools = {
        appimage-run = enabled;
      };
    };
  };
}
