{lib, ...}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  users.mutableUsers = false;

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
