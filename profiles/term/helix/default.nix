{
  pkgs,
  inputs,
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
  home-manager.sharedModules = [
    {
      programs.helix.enable = true;
      programs.helix.package = inputs.helix.defaultPackage.${pkgs.system};
      programs.helix.settings = {
        theme = "snazzy";
        keys.normal = {
          n = "search_next";
          N = "search_prev";
          A-n = "extend_search_next";
          A-N = "extend_search_prev";
          C-s = ":w";
          C-q = ":q";
          C-w = "rotate_view";
          C-p = "file_picker";
          C-b = "buffer_picker";
          C-A-n = ":bn";
          C-A-p = ":bp";
          y = ["yank" "yank_joined_to_clipboard"];
        };
        keys.insert.j.j = "normal_mode";
      };
    }
  ];
}
