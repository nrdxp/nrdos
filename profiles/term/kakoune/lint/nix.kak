hook -group lint global WinSetOption filetype=nix %{
  set buffer lintcmd '/etc/xdg/kak/autoload/lint/nix.sh'

  hook buffer BufWritePre .* %{
    lint
  }
}
