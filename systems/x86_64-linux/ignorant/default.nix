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
  imports = [./hardware.nix];

  # Resolve an issue with Bismuth's wired connections failing sometimes due to weird
  # DHCP issues. I'm not quite sure why this is the case, but I have found that the
  # problem can be resolved by stopping dhcpcd, restarting Network Manager, and then
  # unplugging and replugging the ethernet cable. Perhaps there's some weird race
  # condition when the system is coming up that causes this.
  # networking.dhcpcd.enable = false;

nix.settings.trusted-substituters = ["https://ai.cachix.org"];
nix.settings.trusted-public-keys = ["ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="];
services.ntp.enable = true;

home-manager.backupFileExtension = "backup";

  boot.initrd.systemd.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";
  environment.systemPackages = with pkgs; [
    plymouth
    breeze-plymouth
    intel-gpu-tools
    dive
    podman-tui
    podman-compose
    #plusultra.kalidoface
  ];
virtualisation.libvirtd.enable = true;
#  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # NOTE: This _may_ be required for openvpn to work. However, I have
  # not confirmed that...
#  boot.kernelModules = ["tun"];


#  services.minecraft-server = {
#    enable = false;
#    eula = true;
#    declarative = true;
#    serverProperties = {
#      server-port = 43000;
#    };
#  };

  plusultra = {
    services = {
      #local-ai = enabled;
    };
    apps = {
      #rpcs3 = enabled;
      #ubports-installer = enabled;
      #steamtinkerlaunch = enabled;
      #r2modman = enabled;
    };
    services = {
      syncthing = {
        ignorant = enabled;
      };
    };


    archetypes = {
      gaming = enabled;
      workstation = enabled;
    };
    system = {
      fonts = enabled;
      locale = enabled;
      time = enabled;
      xkb = enabled;
    };

    desktop.gnome = {
      wallpaper = {
        light = pkgs.plusultra.wallpapers.nord-rainbow-light-nix-ultrawide;
        dark = pkgs.plusultra.wallpapers.nord-rainbow-dark-nix-ultrawide;
      };
      #monitors = ./monitors.xml;
    };

#    virtualisation.kvm = {
#      enable = true;
#      platform = "amd";
#      # RX480 when in the bottom slot:
#      # IOMMU Group 23 23:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere [Radeon RX 470/480/570/570X/580/580X/590] [1002:67df] (rev c7)
#      # IOMMU Group 23 23:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere HDMI Audio [Radeon RX 470/480 / 570/580/590] [1002:aaf0]
#      vfioIds = ["1002:67df" "1002:aaf0"];
#      machineUnits = ["machine-qemu\\x2d1\\x2dwin10.scope"];
#    };
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
