{pkgs, ...}: {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.runAsRoot = false;
      allowedBridges = [
        "virbr0"
        "virbr1"
      ];
    };

    containers.enable = true;

    podman.enable = true;
    oci-containers.backend = "podman";
  };

  # you'll need to add your user to 'libvirtd' group to use virt-manager
  environment.systemPackages = with pkgs; [virt-manager];

  environment.shellAliases.docker = "podman";
}
