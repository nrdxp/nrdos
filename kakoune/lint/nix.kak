hook -group lint global WinSetOption filetype=nix %{
  set buffer lintcmd '/etc/xdg/kak/autoload/lint/nix.sh'
  set buffer formatcmd "nixpkgs-fmt"

  hook buffer BufWritePre .* %{
    format
    lint
  }
}
