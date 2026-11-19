{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libx11,
  libxi,
  libxkbcommon,
  # Runtime-loaded by the portal ScreenCast route (dlopen, not DT_NEEDED).
  pipewire,
}:

# Prebuilt release binary, no Rust compile. The tarball ships the CLI, the
# cursor-theme sidecar the CLI looks for next to itself, the UniFFI SDK
# library, a Node runtime, the ABI header, and the GNOME wayland-helper; only
# the CLI and its sidecar are installed here. zstd is statically vendored in
# the release build, so no zstd dependency exists.
stdenv.mkDerivation (finalAttrs: {
  pname = "cua-driver";
  version = "0.53.0";

  src = fetchurl {
    url = "https://github.com/trycua/cua/releases/download/cua-driver-rs-v${finalAttrs.version}/cua-driver-rs-${finalAttrs.version}-linux-x86_64-binary.tar.gz";
    hash = "sha256-/e6GxCs/H0ORaIfwXjjMa3mINmjN5VwpyoYquwnbGQg=";
  };

  # This asset is flat: the archive has no single top-level directory, so
  # disable stdenv's auto-detection (it would pick wayland-helper/).
  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    libx11
    libxi
    libxkbcommon
    stdenv.cc.cc.lib # libgcc_s
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 cua-driver $out/bin/cua-driver
    install -Dm755 cua-cursor-theme $out/bin/cua-cursor-theme
    runHook postInstall
  '';

  # The portal video route dlopens libpipewire at recording time instead of
  # linking it, so autoPatchelf cannot see it; add the search path.
  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath [ pipewire ]} $out/bin/cua-driver
  '';

  meta = {
    description = "Cross-platform MCP server for computer-use automation (prebuilt release binary)";
    homepage = "https://github.com/trycua/cua";
    license = lib.licenses.mit;
    mainProgram = "cua-driver";
    platforms = [ "x86_64-linux" ];
  };
})