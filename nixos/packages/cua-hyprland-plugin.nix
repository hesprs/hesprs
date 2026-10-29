{
  lib,
  gcc16Stdenv,
  stdenvAdapters,
  cmake,
  ninja,
  pkg-config,
  binutils,
  fetchFromGitHub,
  hyprland,
  aquamarine,
  hyprcursor,
  hyprgraphics,
  hyprlang,
  hyprutils,
  libdrm,
  libGL,
  cairo,
  libxkbcommon,
  libinput,
  wayland,
  libxcb,
  libxcb-wm,
  libxcb-errors,
  # Build the experimental v3 input route (foreground activation + raw
  # background input). Pinned by upstream to Hyprland 0.56.2 exactly.
  withInput ? true,
}:

let
  # Same monorepo and tag as packages/cua-driver.nix — only the sourceRoot
  # differs. Nix reuses the identical source store path for both packages.
  src = fetchFromGitHub {
    owner = "trycua";
    repo = "cua";
    tag = "cua-driver-rs-v0.38.0";
    hash = "sha256-Fpryc6Vg9vtV3zRCaL4S38v8l4JluU95o86dQbzkDPM=";
  };

  # ABI parity with the compositor: nixpkgs builds Hyprland 0.56.2 with
  # gcc16Stdenv + mold (see pkgs/by-name/hy/hyprland/package.nix), and the
  # plugin must be built with the same toolchain family. Mirror that recipe
  # so the two stay in sync if either changes.
  stdenv = stdenvAdapters.useMoldLinker gcc16Stdenv;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cua-hyprland-plugin";
  version = "0.38.0";

  inherit src;
  sourceRoot = "${src.name}/libs/cua-driver/hyprland-plugin";

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    # readelf for the build-time C++ runtime verification (CMAKE_READELF).
    binutils
  ];

  buildInputs = [
    # Headers + hyprland.pc (Version/Cflags pin the ABI probe).
    hyprland.dev
    # Everything hyprland.pc Requires, with nixpkgs attribute names:
    aquamarine
    hyprcursor.dev
    hyprgraphics
    hyprlang
    hyprutils
    libdrm
    libGL # provides egl.pc
    cairo
    libxkbcommon
    libinput
    wayland
    libxcb # xcb, xcb-render, xcb-xfixes, xcb-composite, xcb-res
    libxcb-wm # xcb-icccm
    libxcb-errors
  ];

  cmakeBuildType = "Release";

  cmakeFlags = [
    (lib.cmakeBool "CUA_HYPRLAND_INPUT" withInput)
    "-DBUILD_TESTING=OFF"
    "-DCUA_HYPRLAND_EXPECTED_VERSION=${lib.getVersion hyprland}"
    "-DCMAKE_READELF=${binutils}/bin/readelf"
  ];

  # The plugin sets _FORTIFY_SOURCE=3 itself (Release); nixpkgs' default fortify would redefine the macro and trip -Werror.
  hardeningDisable = [
    "fortify"
    "fortify3"
  ];

  # '!strip' in the upstream PKGBUILD: keep the module unstripped.
  dontStrip = true;
  strictDeps = true;

  postInstall = ''
    # CMake installs to lib/cua/hyprland/. Home Manager's
    # wayland.windowManager.hyprland.plugins resolves packages as
    # <pkg>/lib/lib<pname>.so, so expose the conventional location too.
    mkdir -p $out/lib
    ln -s cua/hyprland/cua-hyprland-plugin.so $out/lib/libcua-hyprland-plugin.so
  '';

  meta = {
    description = "Hyprland compositor plugin for cua-driver (input/activation adapter)";
    homepage = "https://github.com/trycua/cua";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
