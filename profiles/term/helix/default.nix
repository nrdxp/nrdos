{
  pkgs,
  inputs,
  lib,
  ...
}: let
  helix = inputs.helix.packages.${pkgs.system}.default.overrideAttrs (self: {
    makeWrapperArgs = with pkgs;
      self.makeWrapperArgs
      or []
      ++ [
        "--suffix"
        "PATH"
        ":"
        (lib.makeBinPath [
          nodePackages.bash-language-server
          shellcheck
          yaml-language-server
          cmake-language-server
          taplo-lsp
          rnix-lsp
          python3Packages.python-lsp-server
          clang-tools
          rust-analyzer
          inputs.nickel.defaultPackage.${system}
          gopls
          go
        ])
        "--set-default"
        "RUST_SRC_PATH"
        "${rustPlatform.rustcSrc}/library"
      ];
  });
in {
  environment.systemPackages = [helix];
  home-manager.sharedModules = [
    {
      programs.helix.enable = true;
      programs.helix.package = helix;
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
