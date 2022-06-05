{
  lib,
  pkgs,
  ...
}: {
  programs.git = lib.importTOML ./git.toml;
  home.packages = [pkgs.ghq];
}
