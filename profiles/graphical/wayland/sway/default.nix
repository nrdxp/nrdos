{
  lib,
  config,
  options,
  pkgs,
  ...
}: let
  inherit (builtins) readFile;

  inherit (config.hardware) pulseaudio;
in {
  imports = [../.];

  programs.sway = {
    enable = true;

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      # needs qt5.qtwayland in systemPackages
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';

    extraPackages = with pkgs;
      options.programs.sway.extraPackages.default
      ++ [
        dmenu
        networkmanager_dmenu
        volnoti
      ];
  };

  environment.etc = {
    "sway/config".text = let
      volnoti = import ../../volnoti.nix {inherit pkgs;};
    in ''
      set $volume ${volnoti}
      set $mixer "${pkgs.alsaUtils}/bin/amixer -q set Master"

      # set background
      output * bg ${pkgs.adapta-backgrounds}/share/backgrounds/adapta/tri-fadeno.jpg fill

      ${readFile ./config}
    '';
  };

  services.redshift =
    lib.mkIf
    (
      (builtins.tryEval config.location.latitude).success
      && (builtins.tryEval config.location.longitude).success
    )
    {
      enable = true;
      temperature.night = 3200;
    };

  systemd.user.targets.sway-session = {
    enable = true;
    description = "sway compositor session";
    documentation = ["man:systemd.special(7)"];

    bindsTo = ["graphical-session.target"];
    wants = ["graphical-session-pre.target"];
    after = ["graphical-session-pre.target"];
    requiredBy = ["graphical-session.target" "graphical-session-pre.target"];
  };

  systemd.user.services.volnoti = {
    enable = true;
    description = "volnoti volume notification";
    documentation = ["volnoti --help"];
    wantedBy = ["sway-session.target"];

    script = "${pkgs.volnoti}/bin/volnoti -n";

    serviceConfig = {
      Restart = "always";
      RestartSec = 3;
    };
  };
}
