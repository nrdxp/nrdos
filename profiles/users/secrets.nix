secrets: {
  lib,
  pkgs,
  ...
}: {
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
