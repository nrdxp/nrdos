{
  inputs,
  pkgs,
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
}
