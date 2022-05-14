{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) fileContents;
in {
  # flake registry
  nix.registry = builtins.mapAttrs (_: flake: {inherit flake;}) inputs;

  nix.package = inputs.nix.packages.${pkgs.system}.nix;
  nix.extraOptions = ''
    experimental-features = flakes nix-command impure-derivations ca-derivations'';

  nix = {
    autoOptimiseStore = true;
    gc.automatic = true;
    gc.dates = "weekly";
    gc.persistent = true;
    optimise.automatic = true;
    useSandbox = true;
    allowedUsers = ["@wheel"];
    trustedUsers = ["root" "@wheel"];
    nixPath = [
      "nixpkgs=${inputs.nixos}"
      "home-manager=${inputs.home-manager}"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
  };

  services.earlyoom.enable = true;
}
