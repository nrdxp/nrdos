{ pkgs, ... }: {
  imports = [ ./zsh ./tmux ./core.nix ./kakoune ./graphical ./laptop ];

  environment.shellAliases = {
    v = "$EDITOR";
    vi = "k";
    vim = "k";
  };

  environment.sessionVariables = {
    PAGER = "less";
    LESS = "-iFJMRWX -z-4 -x4";
    LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
    EDITOR = "k";
    VISUAL = "k";
  };

  environment.systemPackages = with pkgs; [ file less ncdu tig wget neovim ];

  fonts =
    let nerdfonts = pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" ]; };
    in
    {
      fonts = [ nerdfonts ];
      fontconfig.defaultFonts.monospace =
        [ "DejaVu Sans Mono Nerd Font Complete Mono" ];
    };
}
