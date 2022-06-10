{
  lib,
  config,
  ...
}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  users.mutableUsers = false;

  systemd.tmpfiles.rules =
    [
      "L+ /etc/nixos - - - - /srv/git/github.com/nrdxp/nrdos"
      "L+ /home/nrd/git - - - - /srv/git"
      "L+ /home/nrd/work - - - - git/github.com/input-output-hk"
    ]
    ++ lib.optional (config.services ? qbittorrent && config.services.qbittorrent.enable)
    "L+ /home/nrd/torrents - - - - ${config.services.qbittorrent.dataDir}/.config/qBittorrent/downloads";

  users.users.nrd = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "libvirtd" "media" "keys"];
    hashedPassword = "$6$wvQOaBh8ZDb6sChU$JEGVARG31.mwbIwzzsLyFGTaKBmtE5Xlgq2UE3HhKjT2C6Bf5vy/mSgvFf52iGP0aNWUIA31JzcihEAImlM5I1";
  };

  home-manager.users.nrd = {
    programs.git.extraConfig = {
      user.name = "Timothy DeHerrera";
      user.signingKey = "19B7285E0F84A536";
      user.email = "tim@nrdxp.dev";

      commit.gpgSign = true;
    };
  };
}
