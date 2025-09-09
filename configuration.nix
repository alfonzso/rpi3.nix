{ config, pkgs, lib, ... }:

let
  getenv = name:
    builtins.getEnv "RPINX_${name}";

  getEnvOrFail = name:
    let
      v = builtins.getEnv "RPINX_${name}";
    in if v == "" then
      builtins.throw ( "ERROR: environment variable RPINX_${name} must be set (${v}) (e.g. export RPINX_${name}=...)" )
    else v;

  rpi = {
    user = getEnvOrFail "USER";
    user_password = getEnvOrFail "USER_PASS";
    ssid = getenv "WIFI";
    ssid_password = getEnvOrFail "WIFI_PASS";
    interface = getEnvOrFail "INTERFACE";
    hostname = getEnvOrFail "HOSTNAME";
  };
in {

  imports = [
    ./printer.nix
  ];

  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

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
    hostName = rpi.hostname;
    wireless = {
      enable = rpi.ssid != "" ;
      networks."${rpi.ssid}".psk = rpi.ssid_password;
      interfaces = [ rpi.interface ];
    };
  };

  environment.systemPackages = with pkgs; [ neofetch tmux vim htop iotop nmon libraspberrypi ];

  services.openssh.enable = true;

  users = {
    mutableUsers = true;
    users."${rpi.user}" = {
      isNormalUser = true;
      password = rpi.user_password;
      extraGroups = [
        "wheel"
      ];
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

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.05";
}

