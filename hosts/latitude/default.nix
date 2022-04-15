{ pkgs, ... }: {
  imports = [
    ../../profiles/term
    ../../profiles/core.nix
    ../../profiles/laptop
    ../../profiles/graphical/x11/xmonad
    ../../profiles/graphical/wayland/vivarium
    ../../profiles/virt
    ../../profiles/network/torrent
    ./configuration.nix
  ];
}
