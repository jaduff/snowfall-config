{
  pkgs,
  config,
  lib,
  channel,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; {
  imports = [];

  # Resolve an issue with Bismuth's wired connections failing sometimes due to weird
  # DHCP issues. I'm not quite sure why this is the case, but I have found that the
  # problem can be resolved by stopping dhcpcd, restarting Network Manager, and then
  # unplugging and replugging the ethernet cable. Perhaps there's some weird race
  # condition when the system is coming up that causes this.
  # networking.dhcpcd.enable = false;

services.ntp.enable = true;
  wsl.enable = true;
  wsl.defaultUser = "nixos";

home-manager.backupFileExtension = "backup";


  plusultra = {
    apps = {
      #rpcs3 = enabled;
      #ubports-installer = enabled;
      #steamtinkerlaunch = enabled;
      #r2modman = enabled;
    };


    archetypes = {
    };

    };

  };

  # WiFi is typically unused on the desktop. Enable this service
  # if it's no longer only using a wired connection.
  #systemd.services.network-addresses-wlp41s0.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
