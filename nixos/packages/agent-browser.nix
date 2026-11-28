{ pkgs }:
let
  inherit (pkgs) lib;

  version = "0.45.0";

  src = pkgs.fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    rev = "v${version}";
    hash = "sha256-KS1GdQJS08DVbnzSGN2py28Sgey6E7ohkBPZU4q6rho=";
  };

  # The Rust CLI embeds the dashboard UI via RustEmbed at compile time.
  # Build the Next.js static export so it can be placed at the expected path.
  dashboard = pkgs.stdenv.mkDerivation {
    pname = "agent-browser-dashboard";
    inherit version src;

    nativeBuildInputs = [
      pkgs.nodejs
      pkgs.pnpm_11
      pkgs.pnpmConfigHook
    ];

    pnpmDeps = pkgs.fetchPnpmDeps {
      pname = "agent-browser-dashboard";
      inherit version src;
      pnpm = pkgs.pnpm_11;
      pnpmWorkspaces = [ "dashboard" ];
      fetcherVersion = 4;
      hash = "sha256-gSxTBHR2Fcaq/hUSiOMK5W+6+fLw/D2sCRurXEP8ApI=";
    };

    pnpmWorkspaces = [ "dashboard" ];

    # Replace Google Fonts fetch with a local font from nixpkgs since the
    # Nix sandbox has no network access.
    postPatch = ''
      substituteInPlace packages/dashboard/src/app/layout.tsx --replace-fail \
        '{ Geist } from "next/font/google"' \
        'localFont from "next/font/local"'

      substituteInPlace packages/dashboard/src/app/layout.tsx --replace-fail \
        'Geist({ subsets: ["latin"], variable: "--font-sans" })' \
        'localFont({ src: "./Geist-Regular.otf", variable: "--font-sans" })'

      cp "${pkgs.geist-font}/share/fonts/opentype/Geist-Regular.otf" \
        packages/dashboard/src/app/Geist-Regular.otf
    '';

    buildPhase = ''
      runHook preBuild
      pnpm --filter dashboard build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r packages/dashboard/out $out
      runHook postInstall
    '';
  };

  agent-browser-unwrapped = pkgs.rustPlatform.buildRustPackage {
    pname = "agent-browser";
    inherit version src;
    sourceRoot = "${src.name}/cli";

    cargoHash = "sha256-suI/aRLanHNLoDip5bm5DHY/PZT9UcRo6LswmmVSJhA=";

    patches = [ ./agent-browser-zen.patch ];

    # Place the pre-built dashboard where RustEmbed expects it.
    postUnpack = ''
      chmod u+w source/packages/dashboard
      cp -r ${dashboard} source/packages/dashboard/out
    '';

    doCheck = false;

    # The `skills` subcommand looks for `skills/` and `skill-data/` next to
    # `bin/`, relative to the canonical exe path. See cli/src/skills.rs.
    postInstall = ''
      cp -r ../skills $out/skills
      cp -r ../skill-data $out/skill-data
    '';
  };
in
# Downloaded Chrome builds need FHS library paths on NixOS.
pkgs.buildFHSEnv {
  pname = "agent-browser";
  version = agent-browser-unwrapped.version;

  targetPkgs = pkgs: [
    agent-browser-unwrapped
    pkgs.which
    pkgs.zen
    pkgs.alsa-lib
    pkgs.atk
    pkgs.at-spi2-atk
    pkgs.cairo
    pkgs.cups
    pkgs.dbus
    pkgs.expat
    pkgs.fontconfig
    pkgs.dejavu_fonts
    pkgs.glib
    pkgs.nspr
    pkgs.nss
    pkgs.pango
    pkgs.systemd
    pkgs.libdrm
    pkgs.libgbm
    pkgs.libxkbcommon
    pkgs.libx11
    pkgs.libxcb
    pkgs.libxcomposite
    pkgs.libxdamage
    pkgs.libxext
    pkgs.libxfixes
    pkgs.libxrandr
  ];

  runScript = "${agent-browser-unwrapped}/bin/agent-browser";

  meta = {
    description = "Headless browser automation CLI for AI agents";
    homepage = "https://github.com/vercel-labs/agent-browser";
    license = lib.licenses.asl20;
    mainProgram = "agent-browser";
    platforms = lib.platforms.linux;
  };
}
