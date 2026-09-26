{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  addDriverRunpath,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  glibc,
  gnutls,
  gtk3,
  libdrm,
  libGL,
  libgbm,
  libgcrypt,
  libglvnd,
  libpulseaudio,
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxshmfence,
  libxtst,
  nspr,
  nss,
  pango,
  pciutils,
  systemd,
  wayland,
  xdg-utils,
  zlib,

  # for custom command line arguments, e.g. "--force-dark-mode"
  commandLineArgs ? "",
}:

stdenv.mkDerivation {
  pname = "lark";
  version = "7.72.23";

  src = fetchurl {
    url = "https://sf16-sg.larksuitecdn.com/obj/lark-version-sg/b69ee051/Lark-linux_x64-7.72.23.deb";
    hash = "sha256-cSKhFlj8DqkTkrMkEYNzP4jRrG6ruyO+LLV24MhNrI8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    gtk3

    # for dlopen
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    glibc
    gnutls
    libdrm
    libGL
    libgbm
    libgcrypt
    libglvnd
    libpulseaudio
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    libxrender
    libxscrnsaver
    libxshmfence
    libxtst
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    systemd
    wayland
    xdg-utils
    zlib
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    dpkg -x $src .
    mkdir -p $out
    mv usr/share $out/
    mv opt $out/

    substituteInPlace $out/share/applications/bytedance-lark.desktop \
      --replace-fail /usr/bin/bytedance-lark-stable $out/opt/bytedance/lark/bytedance-lark

    # Wrap the launcher; it execs the `lark` binary with $HERE on
    # LD_LIBRARY_PATH, so the app's own libraries keep resolving.
    wrapProgram $out/opt/bytedance/lark/bytedance-lark \
      --prefix PATH : ${
        lib.makeBinPath [
          pciutils
          xdg-utils
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          stdenv.cc.cc.lib
        ]
      }:${addDriverRunpath.driverLink}/share \
      ${lib.optionalString (commandLineArgs != "") "--add-flags ${lib.escapeShellArg commandLineArgs}"}

    for size in 16 24 32 48 64 128 256; do
      install -Dm644 $out/opt/bytedance/lark/product_logo_$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/bytedance-lark.png
    done

    mkdir -p $out/bin
    ln -s $out/opt/bytedance/lark/bytedance-lark $out/bin/lark

    runHook postInstall
  '';

  passthru = {
    updateScript = ''
      curl -sf "https://www.larksuite.com/api/package_info?platform=10"
    '';
  };

  meta = {
    description = "All-in-one collaboration suite";
    homepage = "https://www.larksuite.com/";
    downloadPage = "https://www.larksuite.com/download";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "lark";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
