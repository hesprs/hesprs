{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  dialog,
  glib,
  gnome-themes-extra,
  jdupes,
  libxml2,
  sassc,
  util-linux,
  altVariants ? [ ],
  colorVariants ? [ ],
  opacityVariants ? [ ],
  themeVariants ? [ ],
  schemeVariants ? [ ],
  iconVariant ? null,
  panelOpacity ? null,
  panelSize ? null,
  roundedMaxWindow ? false,
  darkerColor ? false,
  blurVersion ? false,
  libadwaita ? false,
  fixedAccent ? false,
  highDefinition ? false,
  smallerFont ? false,
  noShadow ? false,
  showAppsNormal ? false,
}:

let
  pname = "mactahoe-gtk-theme";
  single = x: lib.optional (x != null) x;

in
lib.checkListOfEnum "${pname}: window control buttons variants" [ "normal" "alt" ] altVariants
  lib.checkListOfEnum
  "${pname}: color variants"
  [ "light" "dark" ]
  colorVariants
  lib.checkListOfEnum
  "${pname}: opacity variants"
  [ "normal" "solid" ]
  opacityVariants
  lib.checkListOfEnum
  "${pname}: accent color variants"
  [
    "default"
    "blue"
    "purple"
    "pink"
    "red"
    "orange"
    "yellow"
    "green"
    "grey"
  ]
  themeVariants
  lib.checkListOfEnum
  "${pname}: colorscheme style variants"
  [ "standard" "nord" ]
  schemeVariants
  lib.checkListOfEnum
  "${pname}: activities icon variants"
  [
    "apple"
    "simple"
    "gnome"
    "ubuntu"
    "tux"
    "arch"
    "manjaro"
    "fedora"
    "debian"
    "void"
    "opensuse"
    "popos"
    "mxlinux"
    "zorin"
    "budgie"
    "gentoo"
    "kali"
  ]
  (single iconVariant)
  lib.checkListOfEnum
  "${pname}: panel opacity"
  [ "default" "30" "45" "60" "75" ]
  (single panelOpacity)
  lib.checkListOfEnum
  "${pname}: panel size"
  [ "default" "smaller" "bigger" ]
  (single panelSize)

  stdenv.mkDerivation
  rec {
    pname = "mactahoe-gtk-theme";
    version = "2026-02-20";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "MacTahoe-gtk-theme";
      rev = version;
      hash = "sha256-93SXDOHIspb6AG/JDm2vSm74dhXc1dO0JUFIxZRLP2g=";
    };

    nativeBuildInputs = [
      dialog
      glib
      jdupes
      libxml2
      sassc
      util-linux
    ];

    buildInputs = [
      gnome-themes-extra
    ];

    postPatch = ''
      find -name "*.sh" -print0 | while IFS= read -r -d ''' file; do
        patchShebangs "$file"
      done

      substituteInPlace libs/lib-core.sh --replace-fail '$(which sudo)' false

      substituteInPlace libs/lib-core.sh --replace-fail 'MY_HOME=$(getent passwd "''${MY_USERNAME}" | cut -d: -f6)' 'MY_HOME=/tmp'
    '';

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes

      ./install.sh \
        ${toString (map (x: "--alt " + x) altVariants)} \
        ${toString (map (x: "--color " + x) colorVariants)} \
        ${toString (map (x: "--opacity " + x) opacityVariants)} \
        ${toString (map (x: "--theme " + x) themeVariants)} \
        ${toString (map (x: "--scheme " + x) schemeVariants)} \
        ${lib.optionalString roundedMaxWindow "--roundedmaxwindow"} \
        ${lib.optionalString darkerColor "--darkercolor"} \
        ${lib.optionalString blurVersion "--blur"} \
        ${lib.optionalString libadwaita "--libadwaita"} \
        ${lib.optionalString fixedAccent "--fixed"} \
        ${lib.optionalString highDefinition "--highdefinition"} \
        ${lib.optionalString smallerFont "--gnome-shell -sf"} \
        ${lib.optionalString noShadow "--gnome-shell -ns"} \
        ${lib.optionalString showAppsNormal "--gnome-shell -normal"} \
        ${lib.optionalString (iconVariant != null) ("--gnome-shell -i " + iconVariant)} \
        ${lib.optionalString (panelSize != null) ("--gnome-shell -h " + panelSize)} \
        ${lib.optionalString (panelOpacity != null) ("--gnome-shell -p " + panelOpacity)} \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = gitUpdater { };

    meta = {
      description = "A macOS Tahoe like theme for Linux GTK Desktops";
      homepage = "https://github.com/vinceliuice/MacTahoe-gtk-theme";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [
        # your maintainer handle
      ];
    };
  }
