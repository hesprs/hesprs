final: prev: {
  # The daemon launches the Playwright-downloaded Chrome for Testing
  # (a generic FHS ELF from ~/.cache/ms-playwright); the FHS env gives
  # that child the /usr/lib it needs. Lib list from `ldd` of the
  # downloaded binary. skills/ and skill-data/ merge in from the inner
  # $out, next to /bin/agent-browser.
  agent-browser = final.buildFHSEnv {
    pname = "agent-browser";
    version = prev.agent-browser.version;

    targetPkgs = pkgs: [
      prev.agent-browser
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

    runScript = "${prev.agent-browser}/bin/agent-browser";

    meta = {
      description = "Headless browser automation CLI for AI agents (FHS-wrapped for Playwright Chromium)";
      homepage = "https://github.com/vercel-labs/agent-browser";
      license = final.lib.licenses.asl20;
      mainProgram = "agent-browser";
      platforms = final.lib.platforms.linux;
    };
  };
}
