{
  description = "NixOS Raspberry Pi configuration flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }:
    let
      # system = "x86_64-linux";
      # pkgs = import nixpkgs {
      #   inherit system;
      #   # crossSystem = {
      #   #   config = "aarch64-unknown-linux-gnu";
      #   #   system = "aarch64-linux";
      #   # };
      # };
    in
  {
    nixosConfigurations.rpi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      # inherit system pkgs;
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ./configuration.nix
      ];
    };
  };
}
