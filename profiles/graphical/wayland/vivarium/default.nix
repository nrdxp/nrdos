{ inputs, pkgs, ... }:
let
  configFile =
    pkgs.writeText "config.toml" ''
      ${builtins.readFile ./config.toml}

      ### BACKGROUND ###
      # The background options are displayed using `swaybg`. Make sure you have this installed
      # if you want to use them.
      [background]
      colour = "#bbbbbb"
      image = "${./bg.jpg}"
      mode = "fill"
    '';

  vivarium = pkgs.vivarium.overrideAttrs
    (self: {
      nativeBuildInputs = self.nativeBuildInputs ++ [ pkgs.makeWrapper ];
      postInstall = self.postInstall + ''
        wrapProgram "$out/bin/vivarium" \
         --add-flags '--config ${configFile}'
      '';
    });
in
{
  imports = [ ../. ];

  environment.systemPackages = [
    vivarium
  ];

  nixpkgs.overlays = [ inputs.vivarium.overlay ];

  services.xserver.displayManager.sessionPackages = [ vivarium ];

  services.blueman.enable = true;
}
