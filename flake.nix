{
  description = "A very basic flake";

  inputs.nixos.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";

  outputs = inputs@{ self, nixos, home-manager, nixos-hardware }:
    let inherit (nixos) lib; in
    {
      nixosConfigurations.latitude = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/latitude
          ./home/nrd.nix

          # home-manager
          home-manager.nixosModules.home-manager

          # nixos-hardware
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc-laptop-ssd
        ];
      };
    };
}
