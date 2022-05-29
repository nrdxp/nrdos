# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot.supportedFilesystems = ["zfs"];

  # use grub
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.mirroredBoots = [
    {
      devices = ["nodev"];
      path = "/boot-0";
    }
    {
      devices = ["nodev"];
      path = "/boot-1";
    }
  ];

  # zfs
  services.zfs.trim.enable = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.autoScrub.pools = ["tank"];
  services.zfs.autoSnapshot.enable = true;

  # permissions
  system.activationScripts.setPerms.text = ''
    chmod 775 /srv
    chown root:wheel /srv
  '';

  fileSystems."/" = {
    device = "tank/local/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "tank/local/nix";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "tank/safe/var";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "tank/safe/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5E71-67F1";
    fsType = "vfat";
  };

  fileSystems."/boot-0" = {
    device = "/dev/disk/by-uuid/5D6B-A725";
    fsType = "vfat";
  };

  fileSystems."/boot-1" = {
    device = "/dev/disk/by-uuid/5EB7-6B63";
    fsType = "vfat";
  };

  fileSystems."/srv" = {
    device = "tank/safe/srv";
    fsType = "zfs";
  };

  swapDevices = [];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}