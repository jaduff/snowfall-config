{ config, lib, pkgs, modulesPath, nixos-hardware, ... }:

{
  imports = with nixos-hardware.nixosModules; [
    (modulesPath + "/installer/scan/not-detected.nix")
    common-cpu-amd
    common-gpu-amd
    common-pc
    common-pc-ssd
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      kernelModules = [ "amdgpu" ];
      availableKernelModules =
        [ "nvme" "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
    };
    extraModulePackages = [ ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  fileSystems."/mnt/data" = {
    device = "/dev/sda1";
    fsType = "auto";
    options = [ "rw" ];
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  networking.interfaces.enp39s0.useDHCP = true;
  networking.interfaces.wlp41s0.useDHCP = true;

  hardware.opengl.driSupport = true;
  # 32 bit support?
  # hardware.opengl.driSupport32Bit = true;

  hardware.enableRedistributableFirmware = true;

  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.bluetooth.enable = true;
}
