# nixos-rebuild --flake .#rpi --target-host root@nxrpi3 build --impure
# nixos-rebuild --flake .#rpi --target-host root@nxrpi3 switch --impure
# nixos-rebuild --flake .#rpi --use-remote-sudo --target-host nxadmin@rpi3Nix switch

export $(cat .env|xargs)

# NOTE:
# --impure: needed cuz getEnv/getEnvOrFail
# --target-host: root needed cuz it will 'lacks as signature by trusted key'
# --use-remote-sudo: may not needed but anyway, nixos-rebuild run successfully
nixos-rebuild \
    --flake .#rpi \
    --target-host root@rpi3Nix \
    --use-remote-sudo \
    --impure $@
