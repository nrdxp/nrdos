{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.nrd = {
    imports = [ ./alacritty ./git ./direnv ];

    programs.git = {
      extraConfig = {
        user = {
          name = "Timothy DeHerrera";
          signingKey = "19B7285E0F84A536";
          email = "tim@nrdxp.dev";
        };

        commit.gpgSign = true;
      };

      includes = [
        {
          condition = "gitdir:~/work/**";
          contents = {
            user.email = "tim.deherrera@iohk.io";
          };
        }
      ];
    };
  };
}
