{
  fetchFromGitHub,
  cmake,
  stdenv,
  pkgconfig,
  libevdev,
  websocketd,
  gnused,
  gawk,
  iproute2,
}:
stdenv.mkDerivation {
  name = "controlliod";
  version = "";
  src = fetchFromGitHub {
    owner = "experiment322";
    repo = "controlloid-server";
    rev = "1137a81874120ea9dc10240e8a17f56d32d32cb4";
    hash = "sha256-XcvpFXxD3ftfEN5UHHrwfI3A+wBOakEhIpYlsvPpcdA=";
  };

  preConfigure = ''
    cd src/linux
  '';

  postInstall = ''
    cd ../../..

    mkdir -p $out/lib/udev/rules.d
    install -Dm444 dist/linux/udev/77-controlloid-uinput.rules $out/lib/udev/rules.d

    mv dist/linux/udev $out
    mv dist/linux/start.sh $out/bin/controlloid

    substituteInPlace $out/bin/controlloid \
      --replace ./websocketd/websocketd ${websocketd}/bin/websocketd \
      --replace ./bin/ws_handler $out/bin/ws_handler \
      --replace staticdir=. staticdir=..

    ln -s ${websocketd}/bin $out/websocketd
  '';

  nativeBuildInputs = [cmake pkgconfig libevdev];
}
