{
  pkgs,
  config,
  lib,
  ...
}: let
  gamescope = pkgs.callPackage ./gamescope.nix {
    udev = pkgs.systemdMinimal;
  };
  controlloid = pkgs.callPackage ./controlloid.nix {};
in {
  imports = [./udev.nix];

  environment.systemPackages = with pkgs; [
    retroarchBare
    pcsx2
    qjoypad
  ];

  services.udev.packages = [controlloid];

  # steam hardware
  hardware.steam-hardware.enable = true;

  # services.wii-u-gc-adapter.enable = true;

  # fps games on laptop need this
  services.xserver.libinput.touchpad.disableWhileTyping = false;

  # Launch steam from display managers
  # services.xserver.windowManager.steam = {enable = true;};

  programs.steam.enable = true;

  # 32-bit support needed for steam
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # better for steam proton games
  systemd = {
    services.controlloid = {
      description = "Controlloid Daemon";

      path = with pkgs; [gnused gawk iproute2];
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        ExecStart = "${controlloid}/bin/controlloid";
        User = "controlloid";
        Group = "controlloid";
      };
    };

    extraConfig = "DefaultLimitNOFILE=1048576";
  };

  networking.firewall.allowedTCPPorts = [31415];
  networking.firewall.allowedUDPPorts = [31415];

  users.users.controlloid.isSystemUser = true;
  users.users.controlloid = {
    group = "controlloid";
    extraGroups = ["input"];
  };
  users.groups.controlloid = {};

  # improve wine performance
  environment.sessionVariables = {WINEDEBUG = "-all";};

  security.wrappers.gamescope = {
    owner = "root";
    group = "root";
    source = "${gamescope}/bin/gamescope";
    capabilities = "cap_sys_nice+pie";
  };

  boot.kernel.sysctl."dev.i915.perf_stream_paranoid" = 0;
}
