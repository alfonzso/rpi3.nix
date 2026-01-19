how to debug values after build, or just use builtins.trace
```bash
nix-repl .
:lf .
outputs.nixosConfigurations.rpi.config.networking.wireless
:q
```

# How to install nixos on rpi3 to external storage (ssd/pendrive)

1) boot nixos via sd card or flash drive

2) connect external storage

3) Run these commands:

    ```bash
    LETTER=X

    if ! command -v git >/dev/null 2>&1; then
      echo "git not found" >&2
      exit 1
    fi

    printf "o\nn\np\n1\n2048\n+1G\nt\nb\nw\n" | sudo fdisk /dev/sd$LETTER
    # ^ This will do the follows:
    ### Create a new partition table
    # o  # create new DOS partition table
    ### Create FAT32 boot partition (~1G)
    # n     # new partition
    # p     # primary
    # 1     # partition number 1
    # 2048  # default start sector
    # +1G # size
    # t     # change type
    # b     # W95 FAT32
    sync

    printf "n\np\n2\n\n\nt\n2\n83\nw\n" | sudo fdisk /dev/sd$LETTER
    # ^ This will do the follows:
    ### Create ext4 root partition (rest of disk)
    # n     # new partition
    # p     # primary
    # 2     # partition number 2
    # <default start>  # hit enter
    # <default end>    # hit enter to use full disk
    # t     # change type if needed
    # 83    # Linux

    sync
    sudo mkfs.vfat -F32 /dev/sd${LETTER}1 -n BOOT
    sync
    sudo mkfs.ext4 /dev/sd${LETTER}2 -L NIXOS
    sync

    sudo mkdir -p /mnt
    sudo mount /dev/sd${LETTER}2 /mnt
    sudo mkdir -p /mnt/boot
    sudo mount /dev/sd${LETTER}1 /mnt/boot

    # i am not sure about this, i used another rpi_nixos image/system, and firmware already
    # there in /boot partition so i copied over for the new system
    git clone --depth 1 https://github.com/alfonzso/rpi3.nix.git
    sudotar xvf rpi3.nix/configs/firmwares/rpi3_fw.tar -C /mnt/boot

    # NOTE: if you need config.txt you can find at project-root/configs/config.txt
    ```
4) sudo nixos-generate-config --root /mnt

5) after step 4, edit /mnt/etc/nixos/configuration.nix file accordingly
    == you will need user, with openssh public file, enable wlan or connect via ethernet ==
6) nixos-install --root /mnt

7) reboot system

8) if boot is successfull and you can connect to the rpi3 over ssh, then you can use this repo ./run.sh command

