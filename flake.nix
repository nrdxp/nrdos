{
  description = "A very basic flake";

  inputs.nixos.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.qutebrowser-nixpkgs.url = "github:nrdxp/nixpkgs/pyqt6-new";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixos";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";
  inputs.vivarium.url = "github:nrdxp/vivarium";
  inputs.nix.url = "github:nixos/nix/2.9-maintenance";
  inputs.helix.url = "github:helix-editor/helix";
  inputs.registry.url = "github:NixOS/flake-registry";
  inputs.registry.flake = false;
  inputs.secrets.url = "github:nrdxp/nrdos-secrets";
  inputs.secrets.flake = false;

  outputs = inputs @ {
    self,
    nixos,
    home-manager,
    nixos-hardware,
    ...
  }: let
    inherit (nixos) lib;
    system = "x86_64-linux";
  in {
    nixosConfigurations.triton = lib.nixosSystem {
      inherit system;
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
