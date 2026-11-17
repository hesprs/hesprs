final: prev:
let
  inherit (final) lib;

  version = "0.43.0-unstable-2026-11-17";

  src = final.fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    rev = "adcae1f809514446a2aa690f1e3c2531bc5bc73c";
    hash = "sha256-wcCvQqm/xGAqDs9Sc6dqORkOL8V4/FN5cGpP1kdrBqQ=";
  };

  agent-browser-unwrapped = final.rustPlatform.buildRustPackage (finalAttrs: {
    pname = "agent-browser";
    inherit version src;
    sourceRoot = "${finalAttrs.src.name}/cli";

    cargoHash = "sha256-MKTL/1k3gvGB0ylg4iAi2WyZ1sNrEpBJVtvjc7J6maA=";

    # The upstream Firefox engine expects a Firefox binary and a Firefox
    # version. Zen reports browserName "zen" and browserVersion "1.23.2b",
    # so accept Zen and read its Gecko version from the user agent.
    patches = [ ./agent-browser-zen.patch ];

    # Place the pre-built dashboard where RustEmbed expects it.
    postUnpack = ''
      chmod u+w source/packages/dashboard
      cp -r ${finalAttrs.passthru.dashboard} source/packages/dashboard/out
    '';

    postPatch = ''
      # `which_exists` spawns the external `which` binary at runtime to probe
      # for optional tools; pin it to an absolute store path.
      substituteInPlace src/doctor/helpers.rs src/install.rs \
        src/native/cdp/chrome.rs src/native/cdp/lightpanda.rs --replace-fail \
        '"which"' '"${lib.getExe final.which}"'

      substituteInPlace src/native/browser.rs src/native/cdp/obscura.rs \
        --replace-fail '"/bin/sleep"' '"${lib.getExe' final.coreutils "sleep"}"'
      substituteInPlace src/native/e2e_tests.rs \
        --replace-fail '"/bin/false"' '"${lib.getExe' final.coreutils "false"}"'
    '';

    nativeCheckInputs = [
      final.writableTmpDirAsHomeHook
    ];

    # Some tests use a shared state that makes them flaky when run concurrently.
    dontUseCargoParallelTests = true;

    # The upstream suite is large and serial; this is a local overlay, so skip it.
    doCheck = false;

    checkFlags = [
      # Launches Chrome.
      "--skip=a_rejected_write_with_stripped_credentials_still_reaches_the_replay"
    ]
    ++ lib.optionals (final.stdenv.hostPlatform.isLinux && final.stdenv.hostPlatform.isAarch64) [
      "--skip=install_rejects_an_invalid_explicit_ca_before_network_or_daemon"
    ];

    # The `skills` subcommand looks for `skills/` and `skill-data/` next to
    # `bin/`, relative to the canonical exe path. See cli/src/skills.rs.
    postInstall = ''
      cp -r ../skills $out/skills
      cp -r ../skill-data $out/skill-data
    '';

    passthru = {
      # The Rust CLI embeds the dashboard UI via RustEmbed at compile time.
      # Build the Next.js static export so it can be placed at the expected path.
      dashboard = final.stdenv.mkDerivation (finalAttrs': {
        pname = "agent-browser-dashboard";
        inherit (finalAttrs) version src;

        nativeBuildInputs = [
          final.nodejs
          final.pnpm_11
          final.pnpmConfigHook
        ];

        pnpmDeps = final.fetchPnpmDeps {
          pname = "agent-browser-dashboard";
          inherit (finalAttrs') version src;
          pnpm = final.pnpm_11;
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

          cp "${final.geist-font}/share/fonts/opentype/Geist-Regular.otf" \
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
      });
    };

    meta = {
      description = "Headless browser automation CLI for AI agents";
      homepage = "https://github.com/vercel-labs/agent-browser";
      license = lib.licenses.asl20;
      sourceProvenance = with lib.sourceTypes; [ fromSource ];
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      mainProgram = "agent-browser";
    };
  });
in
{
  # The daemon launches the Playwright-downloaded Chrome for Testing
  # (a generic FHS ELF from ~/.cache/ms-playwright); the FHS env gives
  # that child the /usr/lib it needs. Lib list from `ldd` of the
  # downloaded binary. Zen is the Gecko engine backend for `--engine
  # firefox`. skills/ and skill-data/ merge in from the inner $out,
  # next to /bin/agent-browser.
  agent-browser = final.buildFHSEnv {
    pname = "agent-browser";
    version = agent-browser-unwrapped.version;

    targetPkgs = pkgs: [
      agent-browser-unwrapped
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
      description = "Headless browser automation CLI for AI agents (FHS-wrapped for Playwright Chromium and Zen)";
      homepage = "https://github.com/vercel-labs/agent-browser";
      license = final.lib.licenses.asl20;
      mainProgram = "agent-browser";
      platforms = final.lib.platforms.linux;
    };
  };
}
