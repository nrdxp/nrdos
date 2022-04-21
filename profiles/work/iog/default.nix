{ ... }:
{
  # for work
  environment.sessionVariables.DEVSHELL_TARGET = "ops";

  home-manager.users.nrd.programs.git.includes = [
    {
      condition = "gitdir:~/work/**";
      contents.user.email = "tim.deherrera@iohk.io";
    }
  ];
}
