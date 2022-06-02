{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    discord
    element-desktop
    signal-desktop
    slack
  ];
  environment.shellAliases = let
    launcherHack = cmd: ''
      ( rundir=/run/user/$UID/${cmd}
        mkdir -p $rundir ''${XDG_CACHE_DIR:=~/.cache}/${cmd} && cd $rundir
        ${cmd} &> $XDG_CACHE_DIR/${cmd}/log &!
      )&!
    '';
  in {
    sl = launcherHack "slack";
    ma = launcherHack "element-desktop";
  };
}
