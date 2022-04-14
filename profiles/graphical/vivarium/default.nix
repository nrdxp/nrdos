{ inputs, pkgs, ... }:
{
  imports = [ ../qutebrowser ];

  environment.systemPackages = with pkgs; [
    vivarium
    wofi
    alacritty
    swaybg
  ];

  nixpkgs.overlays = [ inputs.vivarium.overlay ];

  services.xserver.displayManager.sessionPackages = [ pkgs.vivarium ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    gtkUsePortal = true;
  };
}
