{ pkgs, lib, ... }:
let inherit (builtins) readFile;
in
{
  imports = [ ./sway ./xmonad ../network ./im ./vivarium ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.pulseaudio.enable = true;

  boot = {
    kernel.sysctl."kernel.sysrq" = 1;

  };

  environment = {

    etc = {
      "xdg/gtk-3.0/settings.ini" = {
        text = ''
          [Settings]
          gtk-icon-theme-name=Papirus
          gtk-theme-name=Adapta
          gtk-cursor-theme-name=Adwaita
        '';
        mode = "444";
      };
    };

    sessionVariables = {
      # Theme settings
      QT_QPA_PLATFORMTHEME = lib.mkForce "gtk2";

      GTK2_RC_FILES =
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
    };

    systemPackages = with pkgs; [
      adapta-gtk-theme
      dzen2
      feh
      ffmpeg-full
      gnome.adwaita-icon-theme
      networkmanagerapplet
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
      (
        # set default cursor theme when installed
        writeTextDir "share/icons/default/index.theme" ''
          [icon theme]
          Inherits=Adwaita
        ''
      )
    ];
  };


  services.xbanish.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services.xserver = {
    enable = true;

    libinput.enable = true;
  };
}
