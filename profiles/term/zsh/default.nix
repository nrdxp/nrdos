{
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) concatStringsSep;

  inherit (lib) fileContents;
in {
  users.defaultUserShell = pkgs.zsh;

  environment = {
    etc.zshrc.text = lib.mkBefore ''
      if [[ -r "${"\${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}"}.zsh" ]]; then
        source "${"\${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}"}.zsh"
      fi
    '';

    sessionVariables = let
      fd = "${pkgs.fd}/bin/fd -H";
    in {
      BAT_PAGER = "less";
      SKIM_ALT_C_COMMAND = let
        alt_c_cmd = pkgs.writeScriptBin "cdr-skim.zsh" ''
          #!${pkgs.zsh}/bin/zsh
          ${fileContents ./cdr-skim.zsh}
        '';
      in "${alt_c_cmd}/bin/cdr-skim.zsh";
      SKIM_DEFAULT_COMMAND = fd;
      SKIM_CTRL_T_COMMAND = fd;
    };

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";

      os = "nixos-rebuild --use-remote-sudo";
      oss = "os switch";
      osb = "os build";

      df = "df -h";
      du = "du -h";

      ls = "exa";
      l = "ls -lhg --git";
      la = "l -a";
      t = "l -T";
      ta = "la -T";

      ps = "${pkgs.procs}/bin/procs";

      rz = "exec zsh";
    };

    systemPackages = with pkgs; [
      bat
      bzip2
      exa
      gitAndTools.hub
      gzip
      lrzip
      p7zip
      unzip
      procs
      skim
      xz
      zsh-completions
    ];
  };

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    enableBashCompletion = true;
    enableGlobalCompInit = false;

    histSize = 10000;

    setOptions = [
      "incappendhistory"
      "sharehistory"
      "histignoredups"
      "histfcntllock"
      "histreduceblanks"
      "histignorespace"
      "histallowclobber"
      "autocd"
      "cdablevars"
      "nomultios"
      "pushdignoredups"
      "autocontinue"
      "promptsubst"
    ];

    promptInit = let
      p10k = pkgs.writeText "pk10.zsh" (fileContents ./p10k.zsh);
      p10k-linux =
        pkgs.writeText "pk10-linux.zsh" (fileContents ./p10k-linux.zsh);
    in ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ -z $DISPLAY && -z $WAYLAND_DISPLAY ]] \
        && source ${p10k-linux} \
        || source ${p10k}
    '';

    interactiveShellInit = let
      zshrc = fileContents ./zshrc;

      sources = with pkgs; [
        ./cdr.zsh
        "${skim}/share/skim/completion.zsh"
        "${oh-my-zsh}/share/oh-my-zsh/plugins/sudo/sudo.plugin.zsh"
        "${oh-my-zsh}/share/oh-my-zsh/plugins/extract/extract.plugin.zsh"
        "${zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
        "${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        "${zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
      ];

      source = map (source: "source ${source}") sources;

      functions = pkgs.stdenv.mkDerivation {
        name = "zsh-functions";
        src = ./functions;

        ripgrep = "${pkgs.ripgrep}";
        man = "${pkgs.man}";
        exa = "${pkgs.exa}";

        installPhase = let
          basename = "\${file##*/}";
        in ''
          mkdir $out

          for file in $src/*; do
            substituteAll $file $out/${basename}
            chmod 755 $out/${basename}
          done
        '';
      };

      plugins = concatStringsSep "\n" source;

      localCompletions = toString ./completions;

      bashCompletion = ''
        complete -o nospace -C ${pkgs.nomad}/bin/nomad nomad
        complete -o nospace -C ${pkgs.consul}/bin/consul consul
        complete -o nospace -C ${pkgs.vault-bin}/bin/vault vault
        complete -o nospace -C ${pkgs.terraform}/bin/terraform terraform
        complete -o nospace -C ${pkgs.awscli}/bin/aws_completer aws
      '';
    in ''
      ${plugins}

      fpath+=( ${functions} ${localCompletions} )
      autoload -Uz ${functions}/*(:t)

      ${zshrc}

      ${bashCompletion}

      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
      eval $(${pkgs.gitAndTools.hub}/bin/hub alias -s)
      source ${pkgs.skim}/share/skim/key-bindings.zsh

      # needs to remain at bottom so as not to be overwritten
      bindkey jj vi-cmd-mode
    '';
  };
}
