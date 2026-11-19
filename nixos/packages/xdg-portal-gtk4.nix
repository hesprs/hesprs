{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  wrapGAppsHook4,
  gtk4,
  glib,
  gdk-pixbuf,
}:

# Prebuilt-binary variant of xdg-desktop-portal-gtk4.
# Binary comes from the upstream release (built on ubuntu-latest with stable
# Rust, stripped); the Makefile and data/ templates come from the same
# release's git-archive source tarball. No Rust toolchain, no cargo vendor
# step. The Makefile install targets never invoke cargo, so staging the
# prebuilt binary into a fake CARGO_TARGET_DIR is enough.

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-gtk4";
  version = "1.6.6";

  srcs = [
    # Flat archive: just the "xdg-desktop-portal-gtk4" binary.
    (fetchurl {
      url = "https://github.com/JohnRTitor/xdg-desktop-portal-gtk4/releases/download/v${finalAttrs.version}/xdg-desktop-portal-gtk4-linux-x86_64.tar.gz";
      hash = "sha256-lzg6bC76y9ttpo4jQHthJJ+A5Yqw8wB7A0xQwbe6AIU=";
    })
    # git archive of the tag: Makefile + data/ templates (plus full source).
    (fetchurl {
      url = "https://github.com/JohnRTitor/xdg-desktop-portal-gtk4/releases/download/v${finalAttrs.version}/xdg-desktop-portal-gtk4-${finalAttrs.version}.tar.gz";
      hash = "sha256-iEoE0hfdpNC/iHJyTlyR+2vnbrBNTRDwMBJi8/a59b0=";
    })
  ];

  sourceRoot = ".";
  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    glib
    gdk-pixbuf
  ];

  installPhase = ''
    runHook preInstall

    # Stage the prebuilt binary where the Makefile expects cargo output.
    mkdir -p target/release
    install -m 0755 xdg-desktop-portal-gtk4 target/release/xdg-desktop-portal-gtk4

    # install-bin copies the staged binary; install-data renders the
    # .service/.desktop/.portal templates with the right prefix baked in.
    make -C "xdg-desktop-portal-gtk4-${finalAttrs.version}" install \
      PREFIX="$out" CARGO_TARGET_DIR="$PWD/target"

    runHook postInstall
  '';

  meta = {
    description = "GTK4 backend for xdg-desktop-portal";
    homepage = "https://github.com/JohnRTitor/xdg-desktop-portal-gtk4";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
