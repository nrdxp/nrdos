{
  pkgs,
  lib,
  ...
}: {
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

  nix.settings.max-jobs = 18;
  systemd.services.nix-daemon.serviceConfig.LimitNOFILE = lib.mkForce 16384;

  # profile-sync daemon
  services.psd.enable = true;
  systemd.user.services.psd.path = [ pkgs.glib ];
  security.sudo.execWheelOnly = true;
  security.sudo.extraRules = [
    {
      users = ["nrd"];
      commands = [
        {
          command = "${pkgs.profile-sync-daemon}/bin/psd-overlay-helper";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

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

  # nvidia
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nvrun" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec -a "$0" "$@"
    '')
  ];
}
