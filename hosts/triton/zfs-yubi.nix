{
  pkgs,
  lib,
  ...
}: {
  boot.zfs.requestEncryptionCredentials = [];

  boot.initrd = {
    extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.gnupg}/bin/gpg
      copy_bin_and_libs ${pkgs.gnupg}/bin/gpg-agent
      copy_bin_and_libs ${pkgs.gnupg}/libexec/scdaemon
    '';

    extraUtilsCommandsTest = ''
      $out/bin/gpg --version
      $out/bin/gpg-agent --version
      $out/bin/scdaemon --version
    '';

    postDeviceCommands = lib.mkAfter ''
      gpg-agent --daemon \
      --scdaemon-program ${pkgs.gnupg}/libexec/scdaemon \
      --allow-loopback-pinentry

      dataset=tank

      pubkey="$(zfs get -H -o value ca.nrdxp:gpg-pubkey "$dataset")"
      if [ "$pubkey" != "-" ]; then
          echo "$pubkey" | base64 -d | gpg --import
      fi

      gpg --card-status > /dev/null 2> /dev/null

      while ! gpg --card-status > /dev/null 2> /dev/null; do
      read -p "GPG smartcard not present. try again? (Y/n)" input
      if [ "$input" == "n" -o "$input" == "N" ]; then
          break
      fi
      done

      read -s -p "enter GPG smartcard PIN:" pin

      cipher="$(zfs get -H -o value ca.nrdxp:gpg-cipher "$dataset")"
      if [ "$cipher" != "-" ]; then
          for i in $(seq 3); do
          echo "$cipher" | base64 -d \
          | gpg --batch --decrypt --pinentry-mode loopback \
              --passphrase-file <(echo "$pin") \
          | zfs load-key "$dataset"
          if [ "$?" == 0 ]; then
            break
          else
            read -s -p "Wrong PIN: enter GPG smartcard PIN:" pin
          fi
          done
      fi

      zfs load-key -a
    '';
  };
}
