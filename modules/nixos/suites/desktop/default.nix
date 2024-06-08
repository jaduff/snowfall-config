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
  cfg = config.${namespace}.suites.desktop;
in {
  options.${namespace}.suites.desktop = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable common desktop configuration.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      desktop = {
        kde = enabled;

        addons = {wallpapers = enabled;};
      };

      apps = {
        firefox = enabled;
        vlc = enabled;
        yt-music = enabled;
        gparted = enabled;
        telegram-desktop = enabled;
        nextcloud-client = enabled;
        kdeconnect = enabled;
      };

      tools = {
        noto-fonts-emoji-blob-bin = enabled;
      };
    };
  };
}
