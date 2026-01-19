{ pkgs, config, lib, ... }:
let rpi = config.rpi;

in {
  imports = [ ./zram.nix ./printer.nix ];

  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # nixpkgs.overlays = [
  #   (self: super: {
  #     python3 = super.python312;
  #     python3Packages = super.python312Packages;
  #   })
  # ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  time.timeZone = "Europe/Budapest";

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

  fileSystems = lib.mkForce {
    "/" = {
      device = "/dev/disk/by-uuid/a887fb09-947b-433a-a2a0-788006fec642";
      fsType = "ext4";
      # options = [ "noatime" ];
    };
    "/boot" = {
    device = lib.mkDefault "/dev/disk/by-uuid/0772-96FE";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
    };

  };

  # fileSystems."/" = {
  #   device =
  #     lib.mkDefault "/dev/disk/by-uuid/a887fb09-947b-433a-a2a0-788006fec642";
  #   fsType = "ext4";
  # };

  # fileSystems."/boot" = {
  #   device = lib.mkDefault "/dev/disk/by-uuid/0772-96FE";
  #   fsType = "vfat";
  #   options = [ "fmask=0022" "dmask=0022" ];
  # };

  # # NOTE: force fileSystems to have one section, so /boot will be ignored/removed
  # fileSystems = lib.mkForce {
  #   "/" = {
  #     device = "/dev/disk/by-uuid/6d2671ee-6e68-4386-8ffc-965b73b79d7e";
  #     fsType = "ext4";
  #     options = [ "noatime" ];
  #   };
  # };

  # NOTE: nixos needs lot of space in /boots
  # which usually has only 256Mb/1Gb space
  # NOTE: in the future, create 1Gb space for /boot ...
  # fileSystems."/boot" = {
  #   device = lib.mkDefault "/dev/disk/by-uuid/BEDB-C34F";
  #   fsType = "vfat";
  #   options = [ "fmask=0022" "dmask=0022" ];
  # };

  # boot.kernelParams =
  #   [ "usbcore.autosuspend=-1" "dwc_otg.lpm_enable=0" "rootwait" ];

  documentation.nixos.enable = false;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";

  networking = {
    enableIPv6 = false;
    hostName = rpi.hostname;
    wireless = {
      enable = rpi.wifi.ssid != "";
      networks."${rpi.wifi.ssid}".psk = rpi.wifi.ssid_password;
      interfaces = [ rpi.wifi.interface ];
    };
  };

  environment.systemPackages = with pkgs; [
    neofetch
    tmux
    vim
    libraspberrypi
    python312
    python312Packages.pip
    gcc
    pigpio

    dig
    htop
    iotop
    ncdu
    nmon
    pciutils # lspci
    ps # ps aux
    socat
    # unixtools.net-tools
    nettools
    usbutils # lsusb
  ];

  services.openssh.enable = true;

  boot.initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];
  boot.kernelParams = ["cma=320M"];

  users = {
    mutableUsers = true;
    users."${rpi.user}" = {
      isNormalUser = true;
      password = rpi.user_password;
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

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.05";
}
