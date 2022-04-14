{ lib, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.nrd = {
    imports = [ ./git ./direnv ];

    programs.git = lib.importTOML ./gitconfig.toml;
  };
}
