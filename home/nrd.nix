{ lib, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.nrd = {
    imports = [ ./alacritty ./git ./direnv ];

    programs.git = lib.importTOML ./gitconfig.toml;
    services.dunst.enable = true;
    services.dunst.configFile = ./dunstrc;
    services.dunst.waylandDisplay = "wayland-0";
  };
}
