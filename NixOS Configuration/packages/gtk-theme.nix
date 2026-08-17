{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
  sassc,
  sidebarSize ? "200px",
  nautilusStyle ? "stable",
  panelStyle ? "default",
  panelOpacity ? 0.15,
  showappsButton ? "bigsur",
  panelSize ? "default",
  fontSize ? "normal",
  activities ? "default",
  panelFont ? "white",
  maxWindowStyle ? "square",
  monterey ? false,
  darker ? false,
  blur ? false,
  desktop ? "default",
  scale ? "default",
  shellVersion ? "old",
  scalingFactor ? 2,
  menuShadow ? "default",
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

  installPhase = ''
    runHook preInstall

    theme="$out/share/themes/MacTahoe-Dark-Blur"
    mkdir -p "$theme"/{gtk-2.0,gtk-3.0,gtk-4.0}
    cp src/sass/_gtk-base.scss src/sass/_gtk-base-temp.scss
    cp src/sass/_theme-options.scss src/sass/_theme-options-temp.scss
    substituteInPlace src/sass/_theme-options-temp.scss \
      --replace-fail "\$sidebar_size: 200px;" "\$sidebar_size: ${sidebarSize};" \
      --replace-fail "\$nautilus_style: 'stable';" "\$nautilus_style: '${nautilusStyle}';" \
      --replace-fail "\$panel_style: 'default';" "\$panel_style: '${panelStyle}';" \
      --replace-fail "\$panel_opacity: 0.15;" "\$panel_opacity: ${toString panelOpacity};" \
      --replace-fail "\$showapps_button: 'bigsur';" "\$showapps_button: '${showappsButton}';" \
      --replace-fail "\$panel_size: 'default';" "\$panel_size: '${panelSize}';" \
      --replace-fail "\$font_size: 'normal';" "\$font_size: '${fontSize}';" \
      --replace-fail "\$activities: 'default';" "\$activities: '${activities}';" \
      --replace-fail "\$panel_font: 'white';" "\$panel_font: '${panelFont}';" \
      --replace-fail "\$max_window_style: 'square';" "\$max_window_style: '${maxWindowStyle}';" \
      --replace-fail "\$monterey: 'false';" "\$monterey: '${lib.boolToString monterey}';" \
      --replace-fail "\$darker: 'false';" "\$darker: '${lib.boolToString darker}';" \
      --replace-fail "\$blur: 'false';" "\$blur: '${lib.boolToString blur}';" \
      --replace-fail "\$desktop: 'default';" "\$desktop: '${desktop}';" \
      --replace-fail "\$scale: 'default';" "\$scale: '${scale}';" \
      --replace-fail "\$shell_version: 'old';" "\$shell_version: '${shellVersion}';" \
      --replace-fail "\$scaling_factor: '2';" "\$scaling_factor: '${toString scalingFactor}';" \
      --replace-fail "\$menu_shadow: 'default';" "\$menu_shadow: '${menuShadow}';"

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
