# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ lib, ... }:

{
  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.initrd.availableKernelModules = [ "usb_storage" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # NOTE: get it from hhardware file
  # fileSystems."/" =
  #   { device = "/dev/disk/by-uuid/a887fb09-947b-433a-a2a0-788006fec642";
  #     fsType = "ext4";
  #   };
  #
  # fileSystems."/boot" =
  #   { device = "/dev/disk/by-uuid/0772-96FE";
  #     fsType = "vfat";
  #     options = [ "fmask=0022" "dmask=0022" ];
  #   };

  boot.kernelParams = [
    "usbcore.autosuspend=-1"
    "dwc_otg.lpm_enable=0"
    "rootwait"
  ];

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  documentation.nixos.enable = false;
  services.openssh.enable = true;
  hardware.enableRedistributableFirmware = true;

  users = {
    mutableUsers = true;
    users.nxadmin = {
      isNormalUser = true;
      password = "foobar";
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgcJfi0dZotMWa8zQvxXduM76GmQfoPvMU5FjIFZCAa alfonzso@gmail.com"
      ];
    };
    users.root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgcJfi0dZotMWa8zQvxXduM76GmQfoPvMU5FjIFZCAa alfonzso@gmail.com"
      ];
    };
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  networking = {
    enableIPv6 = false;
    hostName = "HOSTNAME" ;
    wireless = {
      enable = true;
      networks."WIFI_SSID".psk = "WIFI_PASS";
      interfaces = [ "wlan0" ];
    };
  };

  system.stateVersion = "25.05"; # Did you read the comment?

}

