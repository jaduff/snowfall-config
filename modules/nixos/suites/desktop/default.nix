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
  cfg = config.${namespace}.suites.desktop;
in
{
  options.${namespace}.suites.desktop = with types; {
    enable = mkBoolOpt false "Whether or not to enable common desktop configuration.";
  };

  config = mkIf cfg.enable {
    plusultra = {
      desktop = {
        kde = enabled;

        addons = {
          wallpapers = enabled;
        };
      };

      apps = {
	xournalpp = enabled;
	winetricks = enabled;
	musescore = enabled;
        firefox = enabled;
        vlc = enabled;
        gparted = enabled;
        telegram-desktop = enabled;
        nextcloud-client = enabled;
        kdeconnect = enabled;
	whatsapp-for-linux = enabled;
      };

      cli-apps = {
	wine = enabled;
      };

      tools = {
        noto-fonts-emoji-blob-bin = enabled;
      };
    };
  };
}
