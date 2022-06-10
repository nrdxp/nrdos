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
          # --- Kakoune Like ---
          # w = "extend_move_next_word_start";
          # b = "extend_move_prev_word_start";
          # e = "extend_move_next_word_end";
          # W = "extend_move_next_long_word_start";
          # B = "extend_move_prev_long_word_start";
          # E = "extend_move_next_long_word_end";
          # t = "extend_find_till_char";
          # f = "extend_find_next_char";
          # T = "extend_till_prev_char";
          # F = "extend_find_prev_char";

          # emulate kakoune's defuault search behavior
          n = "search_next";
          N = "search_prev";
          A-n = "extend_search_next";
          A-N = "extend_search_prev";
          # --------------------

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
