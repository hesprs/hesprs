{
  lib,
  stdenvNoCC,
  fetchzip,
  glib,
}:

# Fork of Rounded Window Corners Reborn carrying upstream PR #165 (applies the
# rounding effect to the window's surface actor instead of the whole window
# actor). Without it the effect's offscreen framebuffer swallows Blur My Shell's
# blur actor and non-GTK windows stay square. The v25.1-beta release tag points
# at that PR's head commit.
stdenvNoCC.mkDerivation {
  pname = "gnome-shell-extension-rounded-window-corners-reborn";
  version = "25.1-beta";

  src = fetchzip {
    # `@` in the asset name breaks fetchzip's default derivation name.
    name = "rounded-window-corners-reborn.zip";
    url = "https://github.com/kem-a/rounded-window-corners/releases/download/v25.1-beta/rounded-window-corners@fxgn.zip";
    hash = "sha256-dqVw2DErydTxwsJ3BBvUBF/O6uVBZjLySJCngiVpBwE=";
    stripRoot = false;
  };

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/rounded-window-corners@fxgn
    cp -r . $out/share/gnome-shell/extensions/rounded-window-corners@fxgn/
    runHook postInstall
  '';

  meta = {
    description = "Add rounded corners to all windows";
    homepage = "https://github.com/kem-a/rounded-window-corners";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
