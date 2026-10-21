{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  addDriverRunpath,
  libglvnd,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  libxkbcommon,
  vulkan-loader,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wordcraft";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/storytold/wordcraft/releases/download/v${finalAttrs.version}/wordcraft-${finalAttrs.version}-linux-x86_64.tar.gz";
    hash = "sha256-Ds4Hzz2RuSPf2A+QMQ4EmDveZvAnnGtg3c6JWW3eDd8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    addDriverRunpath
  ];

  buildInputs = [ stdenv.cc.cc.lib ];

  # Everything is dlopen'd by winit/wgpu at runtime; the binaries themselves
  # only link against libc.
  postFixup = ''
    for bin in wordcraft wordcraft-cli; do
      wrapProgram $out/bin/$bin \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            libglvnd
            libx11
            libxcb
            libxcursor
            libxi
            libxrandr
            libxkbcommon
            vulkan-loader
            wayland
          ]
        }:${addDriverRunpath.driverLink}/lib
    done
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/bin $out/share
    cp -r bin/. $out/bin/
    cp -r share/. $out/share/

    runHook postInstall
  '';

  meta = {
    description = "Word processor reimplemented in Rust";
    homepage = "https://getartcraft.com/apps/wordcraft";
    downloadPage = "https://github.com/storytold/wordcraft/releases";
    license = with lib.licenses; [
      mit
      asl20
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "wordcraft";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
