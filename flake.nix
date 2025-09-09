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
      rpiLib = import ./lib.nix {} ;
      inherit (rpiLib) getenv getEnvOrFail;
    in
  {
    nixosConfigurations.rpi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      # inherit system pkgs;
      modules = [
        # ./lib.nix

        ({ ... }: {
          # very hacky way, need to change this in the future
          # it should wrap with options and it can use in configuration.nix ...
          _module.args.rpi = {
            user = getEnvOrFail "USER";
            user_password = getEnvOrFail "USER_PASS";
            ssid = getenv "WIFI";
            ssid_password = getEnvOrFail "WIFI_PASS";
            interface = getEnvOrFail "INTERFACE";
            hostname = getEnvOrFail "HOSTNAME";
          };
        })

        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ./configuration.nix
      ];
    };
  };
}
