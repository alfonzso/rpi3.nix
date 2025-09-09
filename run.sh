# nixos-rebuild --flake .#rpi --target-host root@nxrpi3 build --impure
# nixos-rebuild --flake .#rpi --target-host root@nxrpi3 switch --impure

nixos-rebuild --flake .#rpi --use-remote-sudo --target-host nxadmin@nxrpi3 switch
