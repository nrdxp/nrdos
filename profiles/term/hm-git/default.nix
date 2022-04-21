{lib, ...}: {
  programs.git = lib.importTOML ./git.toml;
}
