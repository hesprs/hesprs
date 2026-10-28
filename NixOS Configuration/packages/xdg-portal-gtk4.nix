{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  glib,
}:

rustPlatform.buildRustPackage {
  pname = "xdg-desktop-portal-gtk4";
  version = "1.5.1-unstable-2026-10-02";

  src = fetchFromGitHub {
    owner = "JohnRTitor";
    repo = "xdg-desktop-portal-gtk4";
    rev = "8f88da61d347f1af9cc74618ed6823b385754ba3";
    hash = "sha256-bLbuL7M9K7YuQez0mZH2vk4SypxBLRoCKzjZiIfJ4Ms=";
  };

  cargoHash = "sha256-xODGcjjHgVPnFDIICcU71RLB54P4vdf/UjGMSkjZbw8=";

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    glib
  ];

  postInstall = ''
    rm -rf $out/bin
    make install DESTDIR= PREFIX=$out CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}
  '';

  meta = {
    description = "GTK4 backend for xdg-desktop-portal";
    homepage = "https://github.com/JohnRTitor/xdg-desktop-portal-gtk4";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
