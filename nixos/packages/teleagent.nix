{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  addDriverRunpath,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  coreutils,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  glibc,
  gtk3,
  libdrm,
  libGL,
  libgbm,
  libglvnd,
  libpulseaudio,
  libsecret,
  libuuid,
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxshmfence,
  libxtst,
  nspr,
  nss,
  pango,
  systemd,
  wayland,
  xdg-utils,
  zlib,

  # for custom command line arguments, e.g. "--force-dark-mode"
  commandLineArgs ? "",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "teleagent";
  version = "2.7.1";

  src = fetchurl {
    # https://www.teleai.com.cn/product/teleagent redirects here via
    # https://agent.teleai.com.cn/superCowork/sapi/api/download/redirect/linux-x64
    url = "https://cdn01.teleai.com.cn/packages/${finalAttrs.version}/TeleAgent-${finalAttrs.version}-amd64.deb";
    hash = "sha256-NsXiLMWCXBhQJw1U3V6JWX+JXm80RyP3FOhqT5TMNT0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    gtk3

    # for dlopen
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    glibc
    libdrm
    libGL
    libgbm
    libglvnd
    libpulseaudio
    libsecret
    libuuid
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    libxrender
    libxscrnsaver
    libxshmfence
    libxtst
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    systemd
    wayland
    xdg-utils
    zlib
  ];

  # The app ships a bundled Electron (43.1.0) whose main process is
  # bytenode V8 bytecode (dist-electron/main.jsc); it only loads under
  # the exact bundled Electron, so we cannot use nixpkgs electron here.
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    dpkg -x $src .
    mkdir -p $out
    mv usr/share $out/
    mv opt $out/

    substituteInPlace $out/share/applications/teleagent.desktop \
      --replace-fail /opt/TeleAgent/teleagent $out/opt/TeleAgent/teleagent

    # Electron dlopens libsecret-1.so.0 at runtime for safeStorage
    # (login credential storage); without it login aborts with
    # "system credential storage unavailable".
    #
    # The app copies resources/plugins to ~/.config with fs.cp, which keeps
    # the store's read-only modes; the next launch's re-sync then fails with
    # "EACCES: permission denied, unlink" and aborts backend startup (the
    # "plugins" task is fatal). Store modes cannot be relaxed, so re-enable
    # writing before every launch.
    wrapProgram $out/opt/TeleAgent/teleagent \
      --add-flags "--ozone-platform=wayland" \
      --run '${coreutils}/bin/chmod -R u+w "''${HOME}/.config/TeleAgent/plugins" 2>/dev/null || true' \
      --set BASH_ENV $out/share/teleagent-fix-tool-env.sh \
      --prefix PATH : ${
        lib.makeBinPath [
          xdg-utils
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          libsecret
          stdenv.cc.cc.lib
        ]
      }:${addDriverRunpath.driverLink}/share \
      ${lib.optionalString (commandLineArgs != "") "--add-flags ${lib.escapeShellArg commandLineArgs}"}

    mkdir -p $out/bin
    ln -s $out/opt/TeleAgent/teleagent $out/bin/teleagent

    runHook postInstall
  '';

  postInstall = ''
    # Local patch: neutralize the AIGC watermark stamping and restore
    # the real XDG directories for agent-spawned shells.
    #
    # History: the XDG env redirection cannot be fixed inside the app
    # bundle. The operative main-process code is
    # dist-electron/main.jsc, a bytenode V8 bytecode bundle loaded via
    # main-loader.cjs; the plaintext main-runtime bundle shipped in
    # the asar is never loaded, and renaming strings inside the
    # bytecode corrupted the desktop-kernel local-auth handshake and
    # broke the app outright. The XDG fix below works outside the app
    # via BASH_ENV instead.
    asar=$out/opt/TeleAgent/resources/app.asar

    # Patch B: make the AIGC watermark runtime a pass-through. The store
    # copy is re-synced to ~/.config/TeleAgent/plugins at every launch.
    # Rename the original declaration and insert a stub with the
    # original name that copies input to output and restores the
    # input's atime/mtime, so every call site (md/pdf/image, hidden
    # and explicit modes) produces a byte-identical file with
    # preserved timestamps. getWatermark and everything else stay
    # intact.
    wm=$out/opt/TeleAgent/resources/plugins/watermark-runtime/index.cjs
    sed -i 's/async function addWatermark(inputPath, outputPath, mode) {/async function addWatermark(inputPath, outputPath, mode) { const fs = require("fs"); await fs.promises.copyFile(inputPath, outputPath); const st = await fs.promises.stat(inputPath); await fs.promises.utimes(outputPath, st.atime, st.mtime); return; }\nasync function __wm_disabled_addWatermark(inputPath, outputPath, mode) {/' "$wm"
    if ! grep -aqF '__wm_disabled_addWatermark' "$wm"; then
      echo 'ERROR: watermark patch did not apply (version drift?)' >&2
      exit 1
    fi

    # Patch C (partial by design): the watermark flag is enforced by
    # CLOUD sync, not local code. At every app start and session
    # create, the renderer fetches the account toggle
    # ai_watermark_enabled from the cloud and rewrites
    # user-agent-config.json through two paths: the desktop IPC
    # handler (the dotted path below) and the renderer's own
    # camel-key mergeItem. This rename moves only the desktop path
    # onto a junk key; the renderer path still writes the real key.
    # Turning the flag off durably therefore happens via the official
    # settings exemption (cloud-persisted) or an extra renderer
    # patch; the kernel is read-only and honors the real key live, so
    # patch B guarantees byte-identical files either way.
    sed -i 's/features\.watermark\.aiWatermarkEnabled/features.watermark.aiWatermarkEnablex/g' "$asar"
    if grep -aqF 'features.watermark.aiWatermarkEnabled' "$asar" \
      || ! grep -aqF 'features.watermark.aiWatermarkEnablex' "$asar"; then
      echo 'ERROR: watermark config-path patch did not apply (version drift?)' >&2
      exit 1
    fi

    # XDG fix for agent tool shells: the desktop's mergedEnv rewrites
    # XDG_CONFIG_HOME/XDG_DATA_HOME/XDG_CACHE_HOME to TeleAgent account
    # dirs in every tool process, silently breaking every
    # XDG-respecting host app the agent runs (gh auth, git global
    # config in ~/.config/git/config, Electron apps, browsers, ...).
    # Non-interactive bash sources $BASH_ENV before running a command,
    # and BASH_ENV is inherited from the app env through the kernel's
    # env merge, so the wrapper's --set makes every agent bash call
    # restore the real paths from $HOME. The app itself is untouched.
    mkdir -p $out/share
    cat > $out/share/teleagent-fix-tool-env.sh <<'EOF'
# Restored XDG directories for TeleAgent agent tool shells.
# Sourced via BASH_ENV by non-interactive bash; see teleagent.nix.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
EOF
  '';

  passthru = {
    updateScript = ''
      curl -sfI "https://agent.teleai.com.cn/superCowork/sapi/api/download/redirect/linux-x64" \
        | grep -i '^location:' | grep -oE 'TeleAgent-[0-9.]+-amd64.deb'
    '';
  };

  meta = {
    description = "TeleAgent 星辰超级智能体桌面版 - AI office agent by China Telecom";
    homepage = "https://www.teleai.com.cn/product/teleagent";
    downloadPage = "https://www.teleai.com.cn/product/teleagent";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "teleagent";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
