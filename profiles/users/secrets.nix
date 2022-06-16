{
  lib,
  pkgs,
  ...
}: let
  secrets = builtins.fetchurl {
    url = "https://github.com/nrdxp/nrdos-secrets/archive/master.tar.gz";
    sha256 = "sha256:0psdl295zq92w67jcakz4lkl1j434w22rk1dw23wwi3bnpfh2j5m";
  };
in {
  home.activation.writeSecrets = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export GOPASS_CONFIG=$(mktemp)

    trap "rm -rf $GOPASS_CONFIG" EXIT

    cat << EOF > $GOPASS_CONFIG
    path: ${secrets}
    EOF

    declare -a secrets=($(
      cd ${secrets}
      ${pkgs.fd}/bin/fd --strip-cwd-prefix -e gpg . -X printf "%s\n" {.}
    ))

    for secret in ''${secrets[@]}; do
      gopass fscopy "$secret" "$HOME/''${secret//__/\.}"
    done
  '';
}
