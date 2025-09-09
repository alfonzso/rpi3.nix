{ config, pkgs, lib, ... }:

let
  user = "nxadmin";
  password = "system";
  SSID = "house";
  SSIDpassword = "zsolt3131";
  interface = "wlan0";
  hostname = "pi3Nix";
in {

  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  ## boot = {
  ##   # kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
  ##   initrd.availableKernelModules = [
  ##	"xhci_pci"
  ##	"usbhid"
  ##	"usb_storage"
  ##	"vc4"
  ##	"pcie_brcmstb" # required for the pcie bus to work
  ##	"reset-raspberrypi" # required for vl805 firmware to load
  ##   ];
  ##   loader = {
  ##	 grub.enable = false;
  ##	 generic-extlinux-compatible.enable = true;
  ##   };
  ## };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    enableIPv6	= false;
    hostName = hostname;
    wireless = {
      enable = true;
      networks."${SSID}".psk = SSIDpassword;
      interfaces = [ interface ];
    };
  };

  environment.systemPackages = with pkgs; [ neofetch tmux vim htop iotop nmon libraspberrypi ];

  services.openssh.enable = true;

  users = {
    mutableUsers = true;
    users."${user}" = {
      isNormalUser = true;
      password = password;
      extraGroups = [ 
        "wheel" 
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgcJfi0dZotMWa8zQvxXduM76GmQfoPvMU5FjIFZCAa alfonzso@gmail.com"
      ];
      # password = "redacted";
    };
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.05";
}

