{ pkgs, lib, ... }:
let
  # Radius = theme's `window.csd { border-radius: 24px }`.
  roundedCorners =
    "@a{sv} {'borderRadius': <@u 24>, 'enabled': <true>,"
    + " 'padding': <{'left': <@u 0>, 'right': <@u 0>, 'top': <@u 0>, 'bottom': <@u 0>}>,"
    + " 'keepRoundedCorners': <{'maximized': <false>, 'fullscreen': <false>}>,"
    + " 'smoothing': <0.0>, 'borderColor': <[0.5, 0.5, 0.5, 1.0]>}";
in
{
  dconf.settings = {
    "org/gnome/system/proxy".mode = "none";

    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":";
      # <Super>+left drag moves, <Super>+right drag resizes (Hyprland parity).
      mouse-button-modifier = "<Super>";
      resize-with-right-button = true;
      focus-mode = "sloppy";
    };

    "org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-type = "nothing";

    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
    };

    "org/gnome/desktop/interface".enable-hot-corners = false;

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
      disable-while-typing = false;
    };

    "org/gnome/shell".enabled-extensions = [
      "gnome-mosaic@jardon.github.com"
      "blur-my-shell@aunetx"
      "rounded-window-corners@fxgn"
      "user-theme@gnome-shell-extensions.gcampax.github.com"
      "appindicatorsupport@rgcjonas.gmail.com"
      "desktop-cube@schneegans.github.com"
      "just-perfection-desktop@just-perfection"
      "Rounded_Corners@lennart-k"
    ];
    # Stylix ships its own shell theme, MacTahoe wins.
    "org/gnome/shell/extensions/user-theme".name = lib.mkForce "MacTahoe-Dark-Blur";

    "org/gnome/shell/extensions/blur-my-shell/panel".blur = false;
    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      blur = true;
      style-components = 0; # do not style
    };
    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      brightness = 1.0;
      style-dialogs = 2; # light
    };
    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = true;
      enable-all = true;
      blacklist = [ ];
      pipeline = "pipeline_default_rounded";
      sigma = 50;
      static-blur = true;
      opacity = 255;
      dynamic-opacity = false;
    };

    "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
      skip-libadwaita-app = true;
    };

    "org/gnome/shell/extensions/lennart-k/rounded_corners".corner-radius = lib.hm.gvariant.mkInt32 18;

    "org/gnome/shell/extensions/gnome-mosaic" = {
      gap-inner = lib.hm.gvariant.mkUint32 3;
      gap-outer = lib.hm.gvariant.mkUint32 3;
      show-title = false;
      tile-by-default = true;
      toggle-floating = [ "<Super>v" ];
    };

    "org/gnome/shell/extensions/just-perfection" = {
      dash = false;
      panel = false;
    };

    "org/gnome/mutter/wayland/keybindings".restore-shortcuts = [ ];
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ ];
      toggle-tiled-right = [ ];
    };
    "org/gnome/shell/keybindings" = {
      open-application-menu = [ ];
      toggle-overview = [ ];
      # <Super>v belongs to Mosaic's toggle-floating, not the calendar.
      toggle-message-tray = [ ];
      # <Super>1..9 belongs to workspaces, not to the dash.
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = [ ];
      email = [ ];
      www = [ ];
      rotate-video-lock-static = [ ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-manager/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/browser/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
      name = "Terminal";
      command = "ghostty";
      binding = "<Super>q";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/file-manager" = {
      name = "File Manager";
      command = "nautilus";
      binding = "<Super>e";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/browser" = {
      name = "Browser";
      command = "zen-beta";
      binding = "<Super>b";
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [
        "<Super>c"
        "<Alt>F4"
      ];
      minimize = [ ];
      maximize = [ ];
      unmaximize = [ ];
      toggle-maximized = [ ];
      toggle-fullscreen = [ "<Super>f" ];
      switch-to-workspace-left = [ ];
      switch-to-workspace-right = [ ];
      switch-to-workspace-up = [ ];
      switch-to-workspace-down = [ ];
      move-to-workspace-left = [ ];
      move-to-workspace-right = [ ];
      move-to-workspace-up = [ ];
      move-to-workspace-down = [ ];
      move-to-monitor-left = [ ];
      move-to-monitor-right = [ ];
      move-to-monitor-up = [ ];
      move-to-monitor-down = [ ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      switch-to-workspace-10 = [ "<Super>0" ];
      move-to-workspace-1 = [ "<Super><Shift>1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
      move-to-workspace-5 = [ "<Super><Shift>5" ];
      move-to-workspace-6 = [ "<Super><Shift>6" ];
      move-to-workspace-7 = [ "<Super><Shift>7" ];
      move-to-workspace-8 = [ "<Super><Shift>8" ];
      move-to-workspace-9 = [ "<Super><Shift>9" ];
      move-to-workspace-10 = [ "<Super><Shift>0" ];
    };
  };

  # `global-rounded-corner-settings` is an `a{sv}`; HM's gvariant helper
  # serializes dict entries to text dconf can't parse
  # (`@{sv} {k,v}` instead of `{'k': <v>}`), so write it directly.
  # Activation runs as a system unit without a session bus (same reason HM
  # wraps its own `dconf load`), so start one when `DBUS_SESSION_BUS_ADDRESS`
  # is unset.
  home.activation.roundedWindowCorners = lib.hm.dag.entryAfter [ "dconfSettings" ] ''
    if [[ -v DBUS_SESSION_BUS_ADDRESS ]]; then
      ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/rounded-window-corners-reborn/global-rounded-corner-settings "${roundedCorners}"
    else
      # `--dbus-daemon` is explicit because this activation PATH has no dbus
      # libexec dir, unlike HM's own dconfSettings step which prepends it.
      ${pkgs.dbus}/bin/dbus-run-session --dbus-daemon=${pkgs.dbus}/bin/dbus-daemon \
        ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/rounded-window-corners-reborn/global-rounded-corner-settings "${roundedCorners}"
    fi
  '';
}
