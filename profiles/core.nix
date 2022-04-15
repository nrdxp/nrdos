{ config, lib, pkgs, inputs, ... }:
let inherit (lib) fileContents;
in
{
  # flake registry
  nix.registry = builtins.mapAttrs (_: flake: { inherit flake; }) inputs;

  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = flakes nix-command
  '';

  nix = {
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;
    useSandbox = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
    nixPath = [
      "nixpkgs=${inputs.nixos}"
      "home-manager=${inputs.home-manager}"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
  };

  services.earlyoom.enable = true;
}
