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
  shellVersion ? "new",
  scalingFactor ? 2,
  menuShadow ? "default",
  colorVariants ? [ "Dark" ],
  themeVariants ? [ "default" ],
  schemeVariants ? [ "standard" ],
}:

let
  pname = "mactahoe-gtk-theme";

  colors = [ "Light" "Dark" ];
  themes = [ "default" "blue" "purple" "pink" "red" "orange" "yellow" "green" "grey" ];
  schemes = [ "standard" "nord" ];

  expand = allowed: chosen: if builtins.elem "all" chosen then allowed else chosen;
  suffix = default: value: if value == default then "" else "-${value}";

  variants = map (
    { color, theme, scheme }:
    let
      accent = "${suffix "default" theme}${suffix "standard" scheme}";
    in
    {
      inherit color theme scheme accent;
      name = "MacTahoe-${color}${accent}${lib.optionalString blur "-Blur"}";
      assets = "-${color}${accent}";
    }
  ) (lib.cartesianProduct {
    color = expand colors colorVariants;
    theme = expand themes themeVariants;
    scheme = expand schemes schemeVariants;
  });
in
lib.checkListOfEnum "${pname}: color variants" (colors ++ [ "all" ]) colorVariants
(lib.checkListOfEnum "${pname}: theme variants" (themes ++ [ "all" ]) themeVariants
(lib.checkListOfEnum "${pname}: scheme variants" (schemes ++ [ "all" ]) schemeVariants
stdenvNoCC.mkDerivation {
  inherit pname;
  version = "2026-09-10";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "MacTahoe-gtk-theme";
    tag = "2026-09-10";
    hash = "sha256-P4zevOTHd7KKLj3a9wkaY96tMFMg7iZEpz3NkbdyTwM=";
  };

  nativeBuildInputs = [
    jdupes
    sassc
  ];

  installPhase = ''
    runHook preInstall

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

    # GNOME Shell 50 support
    cp src/main/gnome-shell/_shell-base.scss src/main/gnome-shell/_shell-base-temp.scss
    substituteInPlace src/main/gnome-shell/_shell-base-temp.scss \
      --replace-fail '$GNOME_SHELL: 46;' '$GNOME_SHELL: 50;' \
      --replace-fail 'widgets-46-0' 'widgets-48-0'

    ${lib.concatMapStringsSep "\n" ({ color, theme, scheme, accent, name, assets }: ''
      dir="$out/share/themes/${name}"
      mkdir -p "$dir"/{gtk-2.0,gtk-3.0,gtk-4.0,gnome-shell/assets}

      cp src/sass/_gtk-base.scss src/sass/_gtk-base-temp.scss
      substituteInPlace src/sass/_gtk-base-temp.scss \
        --replace-fail "\$theme: 'default';" "\$theme: '${theme}';" \
        --replace-fail "\$scheme: 'standard';" "\$scheme: '${scheme}';"

      for gtk in gtk-3.0 gtk-4.0; do
        cp -r src/assets/gtk/common-assets/assets "$dir/$gtk/"
        cp -r src/assets/gtk/scalable "$dir/$gtk/assets"
        cp -r src/assets/gtk/windows-assets/titlebutton${suffix "standard" scheme} "$dir/$gtk/windows-assets"
        cp "src/assets/gtk/thumbnails/thumbnail${assets}.png" "$dir/$gtk/thumbnail.png"
        sassc -t expanded "src/main/$gtk/gtk-${color}.scss" "$dir/$gtk/gtk.css"
        sassc -t expanded "src/main/$gtk/gtk-Dark.scss" "$dir/$gtk/gtk-dark.css"
      done

      cp "src/main/gtk-2.0/gtkrc${assets}" "$dir/gtk-2.0/gtkrc"
      cp "src/main/gtk-2.0/menubar-toolbar-${color}.rc" "$dir/gtk-2.0/menubar-toolbar.rc"
      cp src/main/gtk-2.0/common/*.rc "$dir/gtk-2.0/"
      cp -r "src/assets/gtk-2.0/assets-common-${color}${suffix "standard" scheme}" "$dir/gtk-2.0/assets"
      cp "src/assets/gtk-2.0/assets${assets}"/*.png "$dir/gtk-2.0/assets/"

      shell="$dir/gnome-shell"
      cp -r src/assets/gnome-shell/icons "$shell/"
      cp src/main/gnome-shell/pad-osd.css "$shell/"
      sassc -t expanded "src/main/gnome-shell/gnome-shell-${color}.scss" "$shell/gnome-shell.css"
      cp -r src/assets/gnome-shell/common-assets/. "$shell/assets/"
      cp -r "src/assets/gnome-shell/assets-${color}/." "$shell/assets/"
      cp -r "src/assets/gnome-shell/theme${accent}/." "$shell/assets/"
      cp src/assets/gnome-shell/activities/activities-apple.svg "$shell/assets/activities.svg"
      cp src/assets/gnome-shell/activities/activities-apple.svg "$shell/assets/activities-white.svg"
      mv "$shell/assets/no-events.svg" "$shell/assets/process-working.svg" "$shell/assets/no-notifications.svg" "$shell/"

      printf '[Desktop Entry]\nType=X-GNOME-Metatheme\nName=${name}\n\n[X-GNOME-Metatheme]\nGtkTheme=${name}\n' > "$dir/index.theme"
    '') variants}

    jdupes --link-soft --recurse "$out/share"

    runHook postInstall
  '';

  meta = {
    description = "macOS Tahoe style GTK theme";
    homepage = "https://github.com/vinceliuice/MacTahoe-gtk-theme";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}))
