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
  coreutils,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  glibc,
  gtk3,
  libdrm,
  libGL,
  libgbm,
  libglvnd,
  libpulseaudio,
  libsecret,
  libuuid,
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
  systemd,
  wayland,
  xdg-utils,
  zlib,

  # for custom command line arguments, e.g. "--force-dark-mode"
  commandLineArgs ? "",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "teleagent";
  version = "2.7.1";

  src = fetchurl {
    # https://www.teleai.com.cn/product/teleagent redirects here via
    # https://agent.teleai.com.cn/superCowork/sapi/api/download/redirect/linux-x64
    url = "https://cdn01.teleai.com.cn/packages/${finalAttrs.version}/TeleAgent-${finalAttrs.version}-amd64.deb";
    hash = "sha256-NsXiLMWCXBhQJw1U3V6JWX+JXm80RyP3FOhqT5TMNT0=";
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
    libdrm
    libGL
    libgbm
    libglvnd
    libpulseaudio
    libsecret
    libuuid
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

  # The app ships a bundled Electron (43.1.0) whose main process is
  # bytenode V8 bytecode (dist-electron/main.jsc); it only loads under
  # the exact bundled Electron, so we cannot use nixpkgs electron here.
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    dpkg -x $src .
    mkdir -p $out
    mv usr/share $out/
    mv opt $out/

    substituteInPlace $out/share/applications/teleagent.desktop \
      --replace-fail /opt/TeleAgent/teleagent $out/opt/TeleAgent/teleagent

    # Electron dlopens libsecret-1.so.0 at runtime for safeStorage
    # (login credential storage); without it login aborts with
    # "system credential storage unavailable".
    #
    # The app copies resources/plugins to ~/.config with fs.cp, which keeps
    # the store's read-only modes; the next launch's re-sync then fails with
    # "EACCES: permission denied, unlink" and aborts backend startup (the
    # "plugins" task is fatal). Store modes cannot be relaxed, so re-enable
    # writing before every launch.
    wrapProgram $out/opt/TeleAgent/teleagent \
      --add-flags "--ozone-platform=wayland" \
      --run '${coreutils}/bin/chmod -R u+w "''${HOME}/.config/TeleAgent/plugins" 2>/dev/null || true' \
      --prefix PATH : ${
        lib.makeBinPath [
          xdg-utils
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          libsecret
          stdenv.cc.cc.lib
        ]
      }:${addDriverRunpath.driverLink}/share \
      ${lib.optionalString (commandLineArgs != "") "--add-flags ${lib.escapeShellArg commandLineArgs}"}

    mkdir -p $out/bin
    ln -s $out/opt/TeleAgent/teleagent $out/bin/teleagent

    runHook postInstall
  '';

  passthru = {
    updateScript = ''
      curl -sfI "https://agent.teleai.com.cn/superCowork/sapi/api/download/redirect/linux-x64" \
        | grep -i '^location:' | grep -oE 'TeleAgent-[0-9.]+-amd64.deb'
    '';
  };

  meta = {
    description = "TeleAgent 星辰超级智能体桌面版 - AI office agent by China Telecom";
    homepage = "https://www.teleai.com.cn/product/teleagent";
    downloadPage = "https://www.teleai.com.cn/product/teleagent";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "teleagent";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
