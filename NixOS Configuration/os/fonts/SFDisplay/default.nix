{ config, pkgs, lib, ... }:

pkgs.stdenv.mkDerivation {
  pname = "SF-Display";
  version = "1.0"; # Set the actual version
  src = ./sf-display.zip;

  unpackPhase = ''
    runHook preUnpack
    ${pkgs.unzip}/bin/unzip $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype
    # Copy your font files (e.g., .ttf, .otf)
    # Adjust the source folder ('./*') based on what the zip extracts
    find . -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec install -Dm644 {} $out/share/fonts/truetype/ \;
    runHook postInstall
  '';

  meta = with lib; {
    description = "A custom font not in nixpkgs";
    license = licenses.unfree;
  };
}