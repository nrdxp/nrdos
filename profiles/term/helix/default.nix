{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    inputs.helix.defaultPackage.${system}
    nodePackages.bash-language-server
    shellcheck
    yaml-language-server
    cmake-language-server
    taplo-lsp
    rnix-lsp
  ];
  home-manager.sharedModules = lib.mkIf (config ? home-manager) [
    {
      programs.helix.enable = true;
      programs.helix.package = inputs.helix.defaultPackage.${pkgs.system};
      programs.helix.settings = {
        theme = "snazzy";
        keys.normal = {
          C-s = ":w";
          C-q = ":q";
          C-w = "rotate_view";
          y = ["yank" "yank_joined_to_clipboard"];
        };
        keys.insert.j.j = "normal_mode";
      };
      programs.helix.languages = [
        {
          name = "toml";
          language-server = {
            command = "taplo-lsp";
            args = ["run"];
          };
        }
      ];
    }
  ];
}
