{ lib, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  users.users.nrd = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "media" ];
    hashedPassword = "$6$wvQOaBh8ZDb6sChU$JEGVARG31.mwbIwzzsLyFGTaKBmtE5Xlgq2UE3HhKjT2C6Bf5vy/mSgvFf52iGP0aNWUIA31JzcihEAImlM5I1";
  };

  home-manager.users.nrd = {
    programs.git = lib.importTOML ./gitconfig.toml;
  };
}