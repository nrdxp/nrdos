{
  description = "A very basic flake";

  inputs.nixos.url = "nixpkgs/nixos-unstable";
  inputs.release.url = "nixpkgs/nixos-22.05";

  inputs.nix.url = "nix/2.9-maintenance";
  inputs.flake-registry.url = "github:NixOS/flake-registry";
  inputs.flake-registry.flake = false;

  # user inputs
  inputs.vivarium.url = "github:nrdxp/vivarium";
  inputs.helix.url = "github:Philipp-M/helix/path-completion";

  outputs = inputs @ {
    self,
    nixos,
    home-manager,
    nixos-hardware,
    release,
    ...
  }: let
    inherit (nixos) lib;
  in {
    lib.brew = modules: args @ {pkgs, ...}: {
      imports =
        [self.nixosProfiles.hmInit]
        ++ map (profile:
          import "${./profiles}/${profile}" ({
              inherit inputs;
            }
            // args))
        modules;
    };

    lib.nrdos = {
      flake ? self,
      modules ? [],
      system ? "x86_64-linux",
    }: let
      inputs = flake.inputs // lib.optionalAttrs (!flake.inputs ? nixos) {nixos = release;};
    in
      inputs.nixos.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
        };

        modules =
          [
            ./profiles/nix.nix
            self.nixosProfiles.hmInit
          ]
          ++ modules;
      };

    nixosConfigurations.triton = self.lib.nrdos {
      modules = [
        ./hosts/triton
        ./profiles/users/nrd.nix
        nixos-hardware.nixosModules.common-cpu-intel
      ];
    };

    nixosProfiles = let
      inherit (self.lib) brew;
    in {
      vivarium = brew ["graphical/wayland/vivarium"];
      nix = brew ["nix.nix"];
      hmInit = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        imports = [
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
