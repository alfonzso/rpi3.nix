{
  description = "NixOS Raspberry Pi configuration flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

  outputs = { self, nixpkgs }:
    # let
    #   # system = "x86_64-linux";
    #   # pkgs = import nixpkgs {
    #   #   inherit system;
    #   #   # crossSystem = {
    #   #   #   config = "aarch64-unknown-linux-gnu";
    #   #   #   system = "aarch64-linux";
    #   #   # };
    #   # };
    #   rpiLib = import ./nx/lib.nix {} ;
    #   inherit (rpiLib) getenv getEnvOrFail;
    # in
    {
      nixosConfigurations.rpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./cfg.nix
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./nx/configuration.nix
          ./nx/rpi3-config.nix
        ];
      };
    };
}
