{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  hicolor-icon-theme,
  jdupes,
  boldPanelIcons ? false,
  themeVariants ? [ ],
}:

let
  pname = "mactahoe-icon-theme";
in
lib.checkListOfEnum "${pname}: theme variants"
  [
    "default"
    "blue"
    "purple"
    "green"
    "red"
    "orange"
    "yellow"
    "grey"
    "nord"
    "all"
  ]
  themeVariants

  stdenvNoCC.mkDerivation
  rec {
    inherit pname;
    version = "2026-09-10";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "MacTahoe-icon-theme";
      tag = "${version}";
      hash = "sha256-NAahlBOYub0QlqkYStamoCbyWh+H5JG/iFm4Ws9EU3A=";
    };

    nativeBuildInputs = [
      gtk3
      jdupes
    ];

    buildInputs = [ hicolor-icon-theme ];

    # These fixup steps are slow and unnecessary
    dontPatchELF = true;
    dontRewriteSymlinks = true;
    dontDropIconThemeCache = true;

    postPatch = ''
      patchShebangs install.sh
    '';

    installPhase = ''
      runHook preInstall

      ./install.sh --dest $out/share/icons \
        --name MacTahoe \
        --theme ${toString themeVariants} \
        ${lib.optionalString boldPanelIcons "--bold"}

      jdupes --link-soft --recurse $out/share

      runHook postInstall
    '';

    meta = {
      description = "MacOS Tahoe style icon theme for Linux desktops";
      homepage = "https://github.com/vinceliuice/MacTahoe-icon-theme";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
    };
  }
