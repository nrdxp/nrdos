{ pkgs, lib, config, ... }:
let inherit (builtins) readFile;
in
{
  imports = [ ../network ./im ./qutebrowser ];

  home-manager.sharedModules = lib.mkIf (config ? home-manager) [{
    imports = [ ./hm-alacritty ];
  }];

  services.xserver.displayManager.gdm.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.accounts-daemon.enable = true;

  programs.dconf.enable = true;

  # Hardware
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;
  security.rtkit.enable = true;

  systemd.user.services.pipewire-pulse.path = [ pkgs.pulseaudio ];

  services.xserver.libinput.enable = true;

  boot = {
    kernel.sysctl."kernel.sysrq" = 1;
  };

  # Theme
  gtk.iconCache.enable = true;
  qt5.enable = true;
  qt5.platformTheme = "gtk2";
  qt5.style = "gtk2";

  environment.etc."xdg/gtk-3.0/settings.ini" = {
    text = ''
      [Settings]
      gtk-icon-theme-name=Papirus
      gtk-theme-name=Adapta
      gtk-cursor-theme-name=Adwaita
    '';
    mode = "444";
  };

  environment.sessionVariables.GTK2_RC_FILES =
    let
      gtk = ''
        gtk-icon-theme-name="Papirus"
        gtk-cursor-theme-name="Adwaita"
      '';
    in
    [
      ("${pkgs.writeText "iconrc" "${gtk}"}")
      "${pkgs.adapta-gtk-theme}/share/themes/Adapta/gtk-2.0/gtkrc"
      "${pkgs.gnome3.gnome-themes-extra}/share/themes/Adwaita/gtk-2.0/gtkrc"
    ];

  # Packages
  environment.systemPackages = with pkgs; [
    pavucontrol
    pulseaudio
    alacritty
    adapta-gtk-theme
    dzen2
    feh
    ffmpeg-full
    gnome.adwaita-icon-theme
    gnome-themes-extra
    imagemagick
    imlib2
    librsvg
    libsForQt5.qtstyleplugins
    man-pages
    papirus-icon-theme
    pulsemixer
    qt5.qtgraphicaleffects
    stdmanpages
    xsel
    zathura
    mpv
    (
      # set default cursor theme
      writeTextDir "share/icons/default/index.theme" ''
        [icon theme]
        Inherits=Adwaita
      ''
    )
  ];

}
