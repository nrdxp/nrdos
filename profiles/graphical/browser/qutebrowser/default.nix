{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) readFile;
  configFile = let
    mpv = "${pkgs.mpv}/bin/mpv";
  in
    pkgs.writeText "config.py" (''
        ${readFile ./config.py}
        ${
          lib.optionalString
          (config.networking.extraHosts != "")
          "c.content.blocking.enabled = False"
        }

        # c.qt.args.append('widevine-path=''${pkgs.widevine-cdm}/lib/libwidevinecdm.so')

        config.bind(',m', 'hint links spawn -d ${mpv} {hint-url}')
        config.bind(',v', 'spawn -d ${mpv} {url}')
      ''
      + lib.optionalString (config.services ? qbittorrent && config.services.qbittorrent.enable) ''
        config.bind(',t', """hint all spawn curl -X POST\
          -F "urls={hint-url}"\
          -F "sequentialDownload=true"\
          http://localhost:${toString config.services.qbittorrent.port}/api/v2/torrents/add"""
        )
      '');
in {
  imports = [../.];

  environment = {
    sessionVariables.BROWSER = "qutebrowser";

    systemPackages = with pkgs; [
      qutebrowser
      mpv
      (yt-dlp.overrideAttrs (_: {
        postInstall = ''
          ln -s "$out/bin/yt-dlp" "$out/bin/youtube-dl"
          ln -s "$out/share/zsh/site-functions/_yt-dlp" "$out/share/zsh/site-functions/_youtube-dl"
        '';
      }))
      rofi
    ];
  };

  nixpkgs.overlays = [
    (final: prev: let
      qbQt6Pkgs =
        import (pkgs.fetchFromGitHub {
          owner = "nrdxp";
          repo = "nixpkgs";
          rev = "pyqt6-new";
          hash = "sha256-9/aidV7Q3jM55L7FdOl8A2Zt072gpTWnw6s80cbeqGY=";
        }) {
          inherit (pkgs) system;
          inherit (config.nixpkgs) config;
        };
    in {
      qutebrowser = qbQt6Pkgs.qutebrowser.overrideAttrs (self: {
        preFixup =
          self.preFixup
          + ''

            makeWrapperArgs+=(
              --add-flags '-C ${configFile}'
              --unset "QT_QPA_PLATFORMTHEME"
            )
          '';
      });
    })
  ];
}
