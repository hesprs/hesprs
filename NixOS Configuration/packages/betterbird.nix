{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  alsa-lib,
  at-spi2-core,
  cairo,
  dbus,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  libcanberra,
  libnotify,
  libpulseaudio,
  libGL,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libXtst,
  libdrm,
  libgbm,
  libxcb,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  stdenv,
  wayland,
  xdg-utils,
  zlib,
}:

let
  runtimeLibraries = [
    alsa-lib
    at-spi2-core
    cairo
    dbus
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libcanberra
    libnotify
    libpulseaudio
    libGL
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libXtst
    libdrm
    libgbm
    libxcb
    libxkbcommon
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    wayland
    zlib
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "betterbird";
  version = "153.2.0esr-bb8";

  src = fetchurl {
    url = "https://www.betterbird.eu/downloads/LinuxArchive/betterbird-${finalAttrs.version}.en-US.linux-x86_64.tar.xz";
    hash = "sha256-FC67Y9P4TG1KiCUs7Swt0s5dKOs7CLBfENhB/j1PgAE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -d "$out/lib" "$out/bin" "$out/share/applications"
    cp -r . "$out/lib/betterbird"

    makeWrapper "$out/lib/betterbird/betterbird" "$out/bin/betterbird" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibraries}" \
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}" \
      --set MOZ_APP_LAUNCHER betterbird \
      --set MOZ_LEGACY_PROFILES 1 \
      --set MOZ_ALLOW_DOWNGRADE 1

    install -Dm644 "$out/lib/betterbird/chrome/icons/default/default128.png" \
      "$out/share/icons/hicolor/128x128/apps/betterbird.png"

    cat > "$out/share/applications/betterbird.desktop" <<'EOF'
    [Desktop Entry]
    Categories=Network;Chat;Email;Feed;GTK;News
    Comment=Read and write e-mails or RSS feeds, or manage tasks on calendars.
    Exec=betterbird %U
    GenericName=Email Client
    Icon=betterbird
    Keywords=mail;email;e-mail;messages;rss;calendar;address book;addressbook;chat
    MimeType=message/rfc822;x-scheme-handler/mailto;text/calendar;text/x-vcard
    Name=Betterbird
    StartupNotify=true
    StartupWMClass=betterbird
    Terminal=false
    Type=Application
    Version=1.5
    EOF

    runHook postInstall
  '';

  meta = {
    description = "Fine-tuned Thunderbird email client";
    homepage = "https://www.betterbird.eu/";
    license = lib.licenses.mpl20;
    mainProgram = "betterbird";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
