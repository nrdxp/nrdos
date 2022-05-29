{pkgs, ...}: {
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

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  systemd.tmpfiles.rules = [
    "Q /srv 0775 root wheel"
  ];

  environment.etc."tmpfiles.d/home.conf".text = ''
    Q /home 0755 - - -
  '';
}
