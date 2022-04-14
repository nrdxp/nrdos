{ ... }: {
  imports = [ ../. ];

  services.xbanish.enable = true;
  services.xserver.enable = true;
}
