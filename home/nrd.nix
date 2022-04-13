{ config, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.nrd = {
    imports = [ ./alacritty ./git ./direnv ];

    programs.git = config.lib.toml.import ./gitconfig.toml;
  };
}
