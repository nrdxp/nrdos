{
  config,
  pkgs,
  ...
}: {
  home.file.".zshrc".text = ''
    if test -n "$KITTY_INSTALLATION_DIR"; then
        export KITTY_SHELL_INTEGRATION="enabled"
        autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
        kitty-integration
        unfunction kitty-integration
    fi
  '';
  programs.kitty = {
    enable = true;
    theme = "Snazzy";
    font = {
      package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
      name = "Fira Code Regular Nerd Font Complete Mono";
      size = 9;
    };
    settings = {
      disable_ligatures = "cursor";
      shell_integration = "disabled";
    };
  };
}
