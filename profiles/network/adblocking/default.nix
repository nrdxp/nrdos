{ pkgs, ... }:
let
  inherit (builtins) concatStringsSep;
  inherit (pkgs) fetchFromGitHub stdenv gnugrep;
  inherit (builtins) readFile fetchurl;

  hosts = stdenv.mkDerivation {
    name = "hosts";

    src = fetchFromGitHub {
      owner = "StevenBlack";
      repo = "hosts";
      rev = "0d99f8f6d0e3b63fd456aaaf0feaaba8921d5de8";
      hash = "sha256-wLqp2iD9z4RM2ELyfzzQ9xdmPUiKiKUA6irPvIOK/fU=";
    };

    nativeBuildInputs = [ gnugrep ];

    installPhase = ''
      mkdir -p $out/etc

      # filter whitelist
      grep -Ev '(${whitelist})' hosts > $out/etc/hosts

      # filter blacklist
      cat << EOF >> $out/etc/hosts
      ${blacklist}
      EOF
    '';
  };

  whitelist = concatStringsSep "|" [ ".*pirate(bay|proxy).*" ];

  blacklist = concatStringsSep ''

    0.0.0.0 ''
    [
      "# auto-generated: must be first"

      # starts here
    ];

in
{ networking.extraHosts = readFile "${hosts}/etc/hosts"; }
