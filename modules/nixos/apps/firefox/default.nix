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
  cfg = config.${namespace}.apps.firefox;
  defaultSettings = {
    "browser.aboutwelcome.enabled" = false;
    "browser.meta_refresh_when_inactive.disabled" = true;
    "browser.startup.homepage" = "https://kagi.com";
    "browser.bookmarks.showMobileBookmarks" = true;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.aboutConfig.showWarning" = false;
    "browser.ssb.enabled" = true;
  };
in
{
  options.${namespace}.apps.firefox = with types; {
    enable = mkBoolOpt false "Whether or not to enable Firefox.";
    extraConfig = mkOpt str "" "Extra configuration for the user profile JS file.";
    userChrome = mkOpt str "" "Extra configuration for the user chrome CSS file.";
    settings = mkOpt attrs defaultSettings "Settings to apply to the profile.";
  };

  config = mkIf cfg.enable {
    plusultra.desktop.addons.firefox-nordic-theme = enabled;

    services.gnome.gnome-browser-connector.enable = config.${namespace}.desktop.gnome.enable;

    plusultra.home = {
      file = mkMerge [
        {
          ".mozilla/native-messaging-hosts/com.dannyvankooten.browserpass.json".source = "${pkgs.browserpass}/lib/mozilla/native-messaging-hosts/com.dannyvankooten.browserpass.json";
        }
        (mkIf config.${namespace}.desktop.gnome.enable {
          ".mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source = "${pkgs.chrome-gnome-shell}/lib/mozilla/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
        })
      ];

      extraOptions = {
        programs.firefox = {
          enable = true;
          # package = pkgs.firefox;

          nativeMessagingHosts = [
            pkgs.browserpass
          ] ++ optional config.${namespace}.desktop.gnome.enable pkgs.gnomeExtensions.gsconnect;

          profiles = {
            home= {
                id = 0;               # 0 is the default profile; see also option "isDefault"
                name = "Home";   # name as listed in about:profiles
                isDefault = true;     # can be omitted; true if profile ID is 0
            };
            Work= {
                id = 1;               # 0 is the default profile; see also option "isDefault"
                name = "Work";   # name as listed in about:profiles
                isDefault = false;     # can be omitted; true if profile ID is 0
            };
            Uni = {
                id = 2;               # 0 is the default profile; see also option "isDefault"
                name = "Uni";   # name as listed in about:profiles
                isDefault = false;     # can be omitted; true if profile ID is 0
            };
          };


          # Enforce Policies
          policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            EnableTrackingProtection = {
              Value= true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
          };
            DisablePocket = true;
            DisableFirefoxAccounts = true;
            DisableAccounts = true;
            DisableFirefoxScreenshots = true;
            OverrideFirstRunPage = "";
            OverridePostUpdatePage = "";
            DontCheckDefaultBrowser = true;
            DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
            DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
            PasswordManagerEnabled= false;
            OfferToSaveLogins = false;
            SearchBar = "unified"; # alternative: "separate"
            FirefoxHome = {
                SponsoredTopSites = false;
            };
            SearchEngines = {
              Default = "Kagi";
            };

            /* ---- EXTENSIONS ---- */
            # Check about:support for extension/add-on ID strings.
            # Valid strings for installation_mode are "allowed", "blocked",
            # "force_installed" and "normal_installed".
            ExtensionSettings = {
              "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
              # Privacy Badger:
              "jid1-MnnxcxisBPnSXQ@jetpack" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
                installation_mode = "force_installed";
              };
              # lastpass
              "support@lastpass.com" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/file/4246455/lastpass_password_manager-4.127.0.1.xpi";
                installation_mode = "force_installed";
              };
              # Kagi
              "search@kagi.com" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/file/4173642/kagi_search_for_firefox-0.3.8.xpi";
                installation_mode = "force_installed";
              };
              # Kagi
              "enhancerforyoutube@maximerf.addons.mozilla.org" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/file/4269135/enhancer_for_youtube-2.0.124.2.xpi";
                installation_mode = "force_installed";
              };
              # Australian Dictionary
              "en-AU@dictionaries.addons.mozilla.org" = {
                install_url = "https://addons.mozilla.org/en-US/firefox/addon/english-australian-dictionary/";
                installation_mode = "force_installed";
              };
        };
  
      };

        };
      };
    };
  };
}
