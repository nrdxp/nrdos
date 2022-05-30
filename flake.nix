{
  description = "A very basic flake";

  inputs.nixos.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixos";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";
  inputs.vivarium.url = "github:nrdxp/vivarium";
  inputs.nix.url = "github:nixos/nix/2.8-maintenance";
  inputs.helix.url = "github:helix-editor/helix";
  inputs.registry.url = "github:NixOS/flake-registry";
  inputs.registry.flake = false;

  outputs = inputs @ {
    self,
    nixos,
    home-manager,
    nixos-hardware,
    ...
  }: let
    inherit (nixos) lib;
  in {
    nixosConfigurations.triton = lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};

      modules = [
        ./hosts/triton
        ./profiles/users/nrd.nix

        # home-manager
        home-manager.nixosModules.home-manager

        # nixos-hardware
        nixos-hardware.nixosModules.common-cpu-intel
      ];
    };
  };
}
