# How to build/install arm on home-manager + ubuntu

#### Install qemu binarys ...

add etc_nix_nix.conf context to your /etc/nix/nix.conf
add userhome_.config_nix_nix.conf context to your ~/.config/nix/nix.conf

```bash
sudo apt install qemu-user-static binfmt-support
# source .env
# build with nix build
nix build .#nixosConfigurations.rpi.config.system.build.toplevel --impure
# OR
# nixos-rebuild, but this has to be installed before
nixos-rebuild switch --flake .#rpi --target-host root@rpi3Nix --use-remote-sudo --impure
```
