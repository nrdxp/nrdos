{ inputs, pkgs, ... }:
{
  imports = [ ../. ];

  environment.systemPackages = with pkgs; [
    vivarium
  ];

  nixpkgs.overlays = [ inputs.vivarium.overlay ];

  services.xserver.displayManager.sessionPackages = [ pkgs.vivarium ];
}
