{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  glib,
  jdupes,
  libxml2,
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
    hash = "sha256-SdfFDX1G2PEy90l1y55V7QfwwAi10aOZOsVYjB4RR6k=";
  };

  nativeBuildInputs = [
    glib
    jdupes
    libxml2
    sassc
  ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = ''
    patchShebangs install.sh
    substituteInPlace libs/lib-core.sh \
      --replace-fail 'start_animation() {' 'start_animation() { return 0; }\n+start_animation_disabled() {' \
      --replace-fail 'stop_animation() {' 'stop_animation() { return 0; }\n+stop_animation_disabled() {'
  '';

  installPhase = ''
    runHook preInstall

    ./install.sh \
      --dest "$out/share/themes" \
      --name MacTahoe \
      --color dark \
      --opacity normal \
      --theme default \
      --scheme standard

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
