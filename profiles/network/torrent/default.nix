{
  config,
  lib,
  ...
}: let
  inherit (config.services.qbittorrent) port;
  inherit (lib) mkAfter;
in {
  imports = [./qbittorrent.nix];

  services.qbittorrent = {
    enable = true;
    group = "media";
    openFirewall = true;
  };

  users.groups.media.members = ["qbittorrent"];
}
