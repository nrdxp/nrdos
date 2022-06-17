{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./zsh ./tmux ./kakoune];

  home-manager.sharedModules = [
    ./hm-git
    ./hm-direnv
  ];

  programs.git.enable = true;
  programs.git.config.init.defaultBranch = "master";

  environment.sessionVariables = {
    PAGER = "less";
    LESS = "-iFJMRWX -z-4 -x4";
    LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
    EDITOR = "hx";
    VISUAL = "hx";
  };

  environment.systemPackages = with pkgs; [
    clang
    file
    gnupg
    less
    ncdu
    gopass
    tig
    tokei
    wget
    binutils
    coreutils
    curl
    direnv
    dnsutils
    dosfstools
    fd
    git
    bottom
    gptfdisk
    iputils
    jq
    manix
    moreutils
    nix-index
    nmap
    ripgrep
    skim
    tealdeer
    usbutils
    utillinux
    whois
  ];

  environment.shellAliases = let
    ifSudo = lib.mkIf config.security.sudo.enable;
  in {
    v = "$EDITOR";
    pass = "gopass";

    # quick cd
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    # git
    g = "git";

    # grep
    grep = "rg";
    gi = "grep -i";

    # nix
    n = "nix";
    np = "n profile";
    ni = "np install";
    nr = "np remove";
    ns = "n search --no-update-lock-file";
    nf = "n flake";
    nepl = "n repl '<nixpkgs>'";
    srch = "ns nixos";
    orch = "ns override";
    nrb = ifSudo "sudo nixos-rebuild";

    # sudo
    s = ifSudo "sudo -E ";
    si = ifSudo "sudo -i";
    se = ifSudo "sudoedit";

    # top
    top = "btm";

    # systemd
    ctl = "systemctl";
    stl = ifSudo "s systemctl";
    utl = "systemctl --user";
    ut = "systemctl --user start";
    un = "systemctl --user stop";
    up = ifSudo "s systemctl start";
    dn = ifSudo "s systemctl stop";
    jtl = "journalctl";
  };

  fonts = let
    nerdfonts = pkgs.nerdfonts.override {
      fonts = ["DejaVuSansMono"];
    };
  in {
    fonts = [nerdfonts pkgs.powerline-fonts pkgs.dejavu_fonts];
    fontconfig.defaultFonts = {
      monospace = [
        "DejaVu Sans Mono Nerd Font Complete Mono"
        "DejaVu Sans Mono for Powerline"
      ];

      sansSerif = ["DejaVu Sans"];
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  documentation.dev.enable = true;

  programs.thefuck.enable = true;
  programs.firejail.enable = true;
  programs.mtr.enable = true;
}
