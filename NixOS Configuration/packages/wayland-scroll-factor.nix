{
  lib,
  stdenv,
  fetchzip,
  meson,
  ninja,
  pkg-config,
  python3,
}:

# GNOME/Mutter exposes no touchpad scroll-speed setting and libinput has no
# public scroll-factor API, so WSF interposes on libinput's scroll getters
# inside gnome-shell (see `home/home.nix` for the preload wiring) and scales
# every client's scrolling, Wayland and Xwayland alike. The GTK GUI is dropped:
# the factor lives in the Nix config, so only the CLI and the library are used.
stdenv.mkDerivation {
  pname = "wayland-scroll-factor";
  version = "1.0.0";

  src = fetchzip {
    url = "https://github.com/daniel-g-carrasco/wayland-scroll-factor/archive/refs/tags/v1.0.0.tar.gz";
    hash = "sha256-veg1tAIbHqKdtNMqb1y49cCIBOhdlESJAQKxDMC5LU4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  postInstall = ''
    rm -rf $out/bin/wsf-gui $out/share/applications $out/share/metainfo $out/share/icons
  '';

  meta = {
    description = "Tune touchpad scroll and gesture sensitivity on Wayland";
    homepage = "https://github.com/daniel-g-carrasco/wayland-scroll-factor";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "wsf";
  };
}
