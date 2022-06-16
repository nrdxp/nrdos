{
  description = "A very basic flake";

  inputs.nixos.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";
  inputs.vivarium.url = "github:nrdxp/vivarium";
  inputs.nix.url = "github:nixos/nix/2.9-maintenance";
  inputs.helix.url = "github:helix-editor/helix";
  inputs.flake-registry.url = "github:NixOS/flake-registry";
  inputs.flake-registry.flake = false;

  outputs = inputs @ {
    self,
    nixos,
    home-manager,
    nixos-hardware,
    ...
  }: let
    inherit (nixos) lib;
  in {
    lib.nrdosSystem = {
      flake ? self,
      modules ? [],
      system ? "x86_64-linux",
    }:
      flake.inputs.nixos.lib.nixosSystem {
        inherit system;

        specialArgs = {inherit (flake) inputs;};

        modules =
          [
            ./profiles/nix.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ]
          ++ modules;
      };

    nixosConfigurations.triton = self.lib.nrdosSystem {
      modules = [
        ./hosts/triton
        ./profiles/users/nrd.nix
        nixos-hardware.nixosModules.common-cpu-intel
      ];
    };

    nixosProfiles = lib.mapAttrs (_: v:
      (modules: args @ {pkgs, ...}: {
        imports = map (profile:
          import "${./profiles}/${profile}" ({
              inherit inputs;
            }
            // args))
        modules;
      })
      v) {
      vivarium = ["graphical/wayland/vivarium"];
      nix = ["nix.nix"];
    };
  };
}
