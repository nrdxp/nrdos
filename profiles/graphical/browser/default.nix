{pkgs, ...}: {
  imports = [../.];

  services.psd.enable = true;
  systemd.user.services.psd.path = [pkgs.glib];
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

}
