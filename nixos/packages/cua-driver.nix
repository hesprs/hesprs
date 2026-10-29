{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libx11,
  libxi,
  libxtst,
  libxext,
  pipewire,
  libei,
  libxkbcommon,
}:

let
  # The whole monorepo is needed: cua-driver path-depends on cua-telemetry in
  # libs/cua, which embeds libs/images/sandbox-images.json and the teleport
  # target list at build time. platform-linux also include_str!s the GNOME
  # Shell helper under libs/cua-driver/wayland-helper.
  src = fetchFromGitHub {
    owner = "trycua";
    repo = "cua";
    tag = "cua-driver-rs-v0.38.0";
    hash = "sha256-Fpryc6Vg9vtV3zRCaL4S38v8l4JluU95o86dQbzkDPM=";
  };

  version = (lib.importTOML "${src}/libs/cua-driver/rust/Cargo.toml").workspace.package.version;
in
rustPlatform.buildRustPackage {
  pname = "cua-driver";
  inherit version src;

  sourceRoot = "${src.name}/libs/cua-driver/rust";

  # Vendored from the committed Cargo.lock, so no cargoHash to maintain.
  cargoLock.lockFile = "${src}/libs/cua-driver/rust/Cargo.lock";

  # Only the Linux-capable crates; platform-macos/platform-windows are
  # cfg-gated and would not compile here. The portal features pull in the
  # PipeWire ScreenCast capture and libei RemoteDesktop input paths.
  cargoBuildFlags = [
    "-p"
    "cua-driver"
    "--features"
    "portal-input,portal-capture"
  ];

  nativeBuildInputs = [
    pkg-config
    # bindgen needs libclang for the libpipewire/libspa SPA pod codegen.
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    # Raw Xlib FFI (x11 crate) for MPX multi-cursor drags.
    libx11
    libxi
    libxtst
    libxext
    pipewire
    libei
    # reis links its keyboard support against libxkbcommon.
    libxkbcommon
  ];

  # Tests need a live X11 display and AT-SPI bus.
  doCheck = false;

  meta = {
    description = "Cross-platform MCP server for computer-use automation";
    homepage = "https://github.com/trycua/cua";
    license = lib.licenses.mit;
    mainProgram = "cua-driver";
    platforms = lib.platforms.linux;
  };
}
