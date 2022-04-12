{
  description = "A very basic flake";

  inputs.nixos.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixos }:
    let inherit (nixos) lib; in
    {
      nixosConfigurations.latitude = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ];
      };
    };
}
