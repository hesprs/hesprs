{
  lib,
  stdenv,
  fetchurl,
  patchelf,
}:

stdenv.mkDerivation rec {
  pname = "snowluma";
  version = "2.3.4";

  # No bundled runtime: the tree is edited only for store realities
  # (read-only root, missing global lib paths) below, never to alter
  # the addons' own code. All four addons dlopen and run identically
  # under Bun 1.4.2 on this machine (verified 2026-11-02).
  src = fetchurl {
    url = "https://github.com/SnowLuma/SnowLuma/releases/download/v${version}/SnowLuma-v${version}-linux-x64-lite.tar.gz";
    hash = "sha256-GMMXfAjFwQCvik62MqrZPNYgDFog5+ncXUI7/+mXkns=";
  };

  nativeBuildInputs = [ patchelf ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  # Only the explicit edits below touch the tree: no fixup pass that
  # could churn the addons or the injected payload ELF.
  dontStrip = true;
  dontFixup = true;

  # The addons NEED libstdc++.so.6 / libgcc_s.so.1. NixOS has no
  # global path for them, and the capability wrapper that runs the
  # bridge scrubs LD_LIBRARY_PATH (secure exec), so no environment
  # can supply them. Bake the path into each addon's RUNPATH. The
  # injected payload .so is deliberately NOT touched: it runs inside
  # the QQ process, which maps its own libstdc++ (verified), and
  # rewriting its ELF could break injection.
  addonsRpath = lib.makeLibraryPath [ (lib.getLib stdenv.cc.cc) ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/snowluma
    tar -xzf $src -C $out/opt/snowluma

    # applyPendingUpdate() runs before the app spawns and rm's
    # <bundle-root>/.update-install. On a read-only store that rm
    # fails with EROFS and startup aborts. Redirect just this
    # startup cleanup to a never-existing /tmp path; the real
    # update-install staging calls (only reachable with a pending
    # update transaction) stay untouched.
    substituteInPlace $out/opt/snowluma/index.mjs \
      --replace-fail 'await rm(path.join(root, ".update-install"), {' 'await rm(path.join(os$1.tmpdir(), "snowluma-readonly-root-noop"), {'

    for elf in $(find $out/opt/snowluma/native -type f -name '*.node'); do
      patchelf --add-rpath "$addonsRpath" "$elf"
    done

    runHook postInstall
  '';

  meta = {
    description = "OneBot v11 bridge that hooks the running QQ client (lite, no runtime bundled)";
    homepage = "https://github.com/SnowLuma/SnowLuma";
    downloadPage = "https://github.com/SnowLuma/SnowLuma/releases";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
