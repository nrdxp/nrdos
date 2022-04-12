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
        modules = [
          ./configuration.nix

          # home-manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nrd = {
              imports = [ ./home/alacritty ./home/git ./home/direnv ];

              programs.git = {
                extraConfig = {
                  user = {
                    name = "Timothy DeHerrera";
                    signingKey = "19B7285E0F84A536";
                    email = "tim@nrdxp.dev";
                  };

                  commit.gpgSign = true;
                };

                includes = [
                  {
                    condition = "gitdir:~/work/**";
                    contents = {
                      user.email = "tim.deherrera@iohk.io";
                    };
                  }
                ];
              };
            };
          }

          # nixos-hardware
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc-laptop-ssd

          # flake registry
          {
            nix.registry = builtins.mapAttrs (_: flake: { inherit flake; }) inputs;
          }
        ];
      };
    };
}
