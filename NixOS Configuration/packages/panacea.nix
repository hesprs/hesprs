{
  lib,
  stdenv,
  fetchgit,
  makeWrapper,
  qt6,
  quickshell,
  jq,
  curl,
  ffmpeg,
  grim,
  slurp,
  wl-clipboard,
  cliphist,
  libnotify,
  python3,
  brightnessctl,
  ddcutil,
  cava,
  wtype,
  pipewire,
  networkmanager,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "panacea";
  version = "1.0.18";

  src = fetchgit {
    url = "https://github.com/EnsixD/Panacea";
    rev = "d12d4e454532307a4c2147990f57754b99e808f3";
    # Only the Quickshell shell; the repo also carries wallpapers and a video.
    sparseCheckout = [ "panacea" ];
    fetchSubmodules = false;
    hash = "sha256-tYr1LNve51vcYmwoAqUMICmxgyVmqPpXF7vui6Uslqk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -d $out/share
    cp -r panacea $out/share/panacea

    install -d $out/bin
    cat > $out/bin/panacea <<EOF
    #!${stdenv.shell}
    set -eu
    # The shell hardcodes ~/.config/panacea for its scripts, assets, sounds and
    # settings; only the read-only parts are linked to the store.
    cfg="\$HOME/.config/panacea"
    mkdir -p "\$cfg"
    for d in scripts assets sounds; do
      ln -sfn "$out/share/panacea/\$d" "\$cfg/\$d"
    done
    if [ ! -e "\$cfg/settings.json" ]; then
      install -m 644 "$out/share/panacea/settings.json" "\$cfg/"
    fi
    exec ${lib.getExe quickshell} -p "$out/share/panacea" "\$@"
    EOF
    chmod +x $out/bin/panacea

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/panacea \
      --prefix PATH : ${
        lib.makeBinPath [
          jq
          curl
          ffmpeg
          grim
          slurp
          wl-clipboard
          cliphist
          libnotify
          python3
          brightnessctl
          ddcutil
          cava
          wtype
          pipewire
          networkmanager
        ]
      } \
      --prefix QML_IMPORT_PATH : ${qt6.qtmultimedia}/lib/qt-6/qml \
      --prefix QT_PLUGIN_PATH : ${qt6.qtmultimedia}/lib/qt-6/plugins
  '';

  meta = {
    description = "Quickshell desktop shell, the pill";
    homepage = "https://github.com/EnsixD/Panacea";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "panacea";
  };
})
