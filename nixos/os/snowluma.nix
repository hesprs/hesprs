{
  pkgs,
  ...
}:

{
  # SnowLuma's hook injects into QQ via ptrace. Yama ptrace_scope=1
  # refuses sibling attaches, so the runtime binary needs
  # CAP_SYS_PTRACE. File capabilities only stick to an ELF, and store
  # paths are read-only, hence a wrapper copy of Bun. No systemd unit
  # by design: `snowluma` starts the bridge, Ctrl+C stops it.
  security.wrappers.snowluma-bun = {
    source = "${pkgs.bun}/bin/bun";
    capabilities = "cap_sys_ptrace+ep";
    # caps ride the exec, so keep execution to root and the user
    # group instead of the default world-executable wrapper.
    owner = "root";
    group = "users";
    permissions = "u+rx,g+rx";
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "snowluma" ''
      set -euo pipefail

      export SNOWLUMA_ACCEPT_EULA=1
      export SNOWLUMA_ACCEPT_PRIVACY=1
      export SNOWLUMA_HOOK_AUTOLOAD=1
      export SNOWLUMA_WEBUI_HOST=127.0.0.1
      export SNOWLUMA_WEBUI_PORT="''${SNOWLUMA_WEBUI_PORT:-5099}"

      # Compat manifest fetch goes through the local proxy; the
      # WebUI and OneBot listeners are loopback and must bypass it.
      export https_proxy="''${https_proxy:-http://127.0.0.1:10808}"
      export http_proxy="''${http_proxy:-http://127.0.0.1:10808}"
      export NO_PROXY="localhost,127.0.0.1''${NO_PROXY:+,$NO_PROXY}"
      export no_proxy="localhost,127.0.0.1''${no_proxy:+,$no_proxy}"

      # Resolve the runtime dir even outside a Hyprland session;
      # the bridge and the hook agree on the socket path through it.
      export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

      # config/ and logs/ are written relative to the CWD, never into
      # the read-only store tree.
      DATA="''${SNOWLUMA_DATA:-$HOME/.local/share/snowluma}"
      mkdir -p "$DATA"
      cd "$DATA"

      exec /run/wrappers/bin/snowluma-bun ${pkgs.snowluma}/opt/snowluma/index.mjs "$@"
    '')
  ];

  # Freeze QQ's silent hot-patch channel so the version-matched native
  # hook stays aligned with the nixpkgs QQ. The pkgs.qq wrapper already
  # pins the full-update config; this covers the patch channel.
  networking.extraHosts = ''
    0.0.0.0 qqpatch.gtimg.cn
  '';
}
