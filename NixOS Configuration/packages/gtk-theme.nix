{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
  sassc,
  gtk-engine-murrine,
}:

stdenvNoCC.mkDerivation {
  pname = "mactahoe-gtk-theme";
  version = "2026-08-08";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "MacTahoe-gtk-theme";
    tag = "2026-08-08";
    hash = "sha256-UEJZFXCVox3KCTZqSeOILumKCbUIeDTzcbLjimtotEI=";
  };

  nativeBuildInputs = [
    jdupes
    sassc
  ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall

    theme="$out/share/themes/MacTahoe-Dark-Blur"
    mkdir -p "$theme"/{gtk-2.0,gtk-3.0,gtk-4.0}
    cp src/sass/_gtk-base.scss src/sass/_gtk-base-temp.scss
    cp src/sass/_theme-options.scss src/sass/_theme-options-temp.scss
    substituteInPlace src/sass/_theme-options-temp.scss \
      --replace-fail "\$blur: 'false';" "\$blur: 'true';"

    for gtk in gtk-3.0 gtk-4.0; do
      cp -r src/assets/gtk/common-assets/assets "$theme/$gtk/"
      cp -r src/assets/gtk/scalable "$theme/$gtk/assets"
      cp -r src/assets/gtk/windows-assets/titlebutton "$theme/$gtk/windows-assets"
      cp src/assets/gtk/thumbnails/thumbnail-Dark.png "$theme/$gtk/thumbnail.png"
    done
    sassc -t expanded src/main/gtk-3.0/gtk-Dark.scss "$theme/gtk-3.0/gtk.css"
    sassc -t expanded src/main/gtk-3.0/gtk-Dark.scss "$theme/gtk-3.0/gtk-dark.css"
    sassc -t expanded src/main/gtk-4.0/gtk-Dark.scss "$theme/gtk-4.0/gtk.css"
    sassc -t expanded src/main/gtk-4.0/gtk-Dark.scss "$theme/gtk-4.0/gtk-dark.css"

    cp src/main/gtk-2.0/gtkrc-Dark "$theme/gtk-2.0/gtkrc"
    cp src/main/gtk-2.0/menubar-toolbar-Dark.rc "$theme/gtk-2.0/menubar-toolbar.rc"
    cp src/main/gtk-2.0/common/*.rc "$theme/gtk-2.0/"
    cp -r src/assets/gtk-2.0/assets-common-Dark "$theme/gtk-2.0/assets"
    cp src/assets/gtk-2.0/assets-Dark/*.png "$theme/gtk-2.0/assets/"

    cat > "$theme/index.theme" <<'EOF'
    [Desktop Entry]
    Type=X-GNOME-Metatheme
    Name=MacTahoe-Dark-Blur

    [X-GNOME-Metatheme]
    GtkTheme=MacTahoe-Dark-Blur
    EOF

    jdupes --link-soft --recurse "$out/share"

    runHook postInstall
  '';

  meta = {
    description = "macOS Tahoe style GTK theme";
    homepage = "https://github.com/vinceliuice/MacTahoe-gtk-theme";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
