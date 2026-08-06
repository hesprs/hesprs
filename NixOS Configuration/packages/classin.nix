{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  alsa-lib,
  e2fsprogs,
  expat,
  fontconfig,
  freetype,
  fribidi,
  gmp,
  libICE,
  libSM,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libdrm,
  libglvnd,
  libgpg-error,
  libuuid,
  libxcb,
  libxkbcommon,
  mesa,
  zlib,
}:

stdenv.mkDerivation {
  pname = "classin";
  version = "6.0.8.2737";

  src = fetchurl {
    url = "https://www.eeo.cn/download/client/classin_6.0.8.2737_amd64.deb";
    hash = "sha256-w+hx6vbygQ0Mn/sW9CWaapd4T27XMPQifd3vZoLXPgc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    e2fsprogs
    expat
    fontconfig
    freetype
    fribidi
    gmp
    libICE
    libSM
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libdrm
    libglvnd
    libgpg-error
    libuuid
    libxcb
    libxkbcommon
    mesa
    stdenv.cc.cc.lib
    zlib
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg -x "$src" .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -d "$out/lib" "$out/bin"
    cp -r opt/apps/classin "$out/lib/classin"

    makeWrapper "$out/lib/classin/ClassIn" "$out/bin/classin" \
      --run "cd $out/lib/classin"

    install -d "$out/share/applications"
    substitute usr/share/applications/classin.desktop \
      "$out/share/applications/classin.desktop" \
      --replace-fail 'Exec="/opt/apps/classin/ClassIn" %u' 'Exec=classin %u'

    install -Dm644 usr/share/icons/hicolor/scalable/apps/classin.svg \
      "$out/share/icons/hicolor/scalable/apps/classin.svg"
    install -Dm644 usr/share/icons/hicolor/scalable/apps/eeo-mime-x-edb.svg \
      "$out/share/icons/hicolor/scalable/apps/eeo-mime-x-edb.svg"
    install -Dm644 usr/share/mime/packages/eeo-edb-mime.xml \
      "$out/share/mime/packages/eeo-edb-mime.xml"

    runHook postInstall
  '';

  meta = {
    description = "Online education and classroom platform";
    homepage = "https://www.eeo.cn/";
    license = lib.licenses.unfree;
    mainProgram = "classin";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
