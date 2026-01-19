{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # Standard App Rules
      "tile, title:^(Microsoft-edge)$"
      "tile, title:^(Brave-browser)$"
      "tile, title:^(Chromium)$"
      "float, title:^(pavucontrol)$"
      "float, title:^(blueman-manager)$"
      "float, title:^(nm-connection-editor)$"
      "float, title:^(qalculate-gtk)$"

      # Browser Picture in Picture Rules
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"
      "move 69.5% 4%, title:^(Picture-in-Picture)$"

      # idleinhibit Rule
      "idleinhibit fullscreen,class:([window])"

      # file chooser fix
      "noblur, class:^(Xdg-desktop-portal-gtk)$"
      "noborder, class:^(Xdg-desktop-portal-gtk)$"
      "noshadow, class:^(Xdg-desktop-portal-gtk)$"
    ];

    layerrule = [
      # swaync
      "blur on, match:namespace swaync-control-center"
      "blur on, match:namespace swaync-notification-window"
      "ignore_alpha 0.5, match:namespace swaync-control-center"
      "ignore_alpha 0.5, match:namespace swaync-notification-window"

      # Waybar
      "blur on, match:namespace waybar"
      "ignore_alpha 0.5, match:namespace waybar"

      # Rofi
      "blur on, match:namespace rofi"
      "ignore_alpha 0.5, match:namespace rofi"
    ];
  };
}
