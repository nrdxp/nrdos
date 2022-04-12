{
  description = "A very basic flake";

  inputs.nixos.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";

  outputs = { self, nixos, home-manager, nixos-hardware }:
    let inherit (nixos) lib; in
    {
      nixosConfigurations.latitude = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nrd = {
              imports = [ ./home/alacritty ./home/git ./home/direnv ];
            };
          }
          nixos-hardware.nixosModules.dell-latitude-7490
        ];
      };
    };
}
