{
  imports = [
    ../../profiles/term
    ../../profiles/term/helix
    ../../profiles/core.nix
    ../../profiles/laptop
    ../../profiles/graphical/x11/xmonad
    ../../profiles/graphical/wayland/vivarium
    ../../profiles/virt
    ../../profiles/work/iog
    ../../profiles/network/torrent
    ./configuration.nix
  ];

  hardware.enableAllFirmware = true;

  services.pcscd.enable = true;

  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
  };
}
