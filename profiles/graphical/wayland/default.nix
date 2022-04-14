{ pkgs, lib, config, ... }: {
  imports = [ ../. ];

  environment.systemPackages = with pkgs; [
    alacritty
    grim
    qt5.qtwayland
    slurp
    swaybg
    (waybar.override { pulseSupport = config.hardware.pulseaudio.enable; })
    wl-clipboard
    wofi
    wofi-emoji
  ];

  programs.tmux.extraConfig = lib.mkBefore ''
    set -g @override_copy_command 'wl-copy'
  '';

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.etc."xdg/waybar".source = ./waybar;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    gtkUsePortal = true;
  };

  home-manager.sharedModules = lib.mkIf (config ? home-manager) [{
    services.dunst.enable = true;
    services.dunst.configFile = ./dunstrc;
    services.dunst.waylandDisplay = "wayland-0";
  }];
}
