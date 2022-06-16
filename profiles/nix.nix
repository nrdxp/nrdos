{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) fileContents;
in {
  nix = {
    package = inputs.nix.packages.${pkgs.system}.nix or pkgs.nix;
    registry = builtins.mapAttrs (_: flake: {inherit flake;}) inputs;

    nixPath =
      [
        "nixpkgs=${pkgs.path}"
        "nixos-config=/etc/nixos/configuration.nix"
      ]
      ++ lib.optional (inputs ? home-manager) "home-manager=${inputs.home-manager}";

    settings = {
      allowed-users = ["@wheel"];
      trusted-users = ["root" "@wheel"];
      flake-registry = lib.mkIf (inputs ? flake-registry) "${inputs.flake-registry}/flake-registry.json";
      experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
  };
}
