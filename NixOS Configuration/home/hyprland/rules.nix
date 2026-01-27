{
  wayland.windowManager.hyprland.settings = {
    windowrulev3 = [
      # Standard App Rules
      "match:title ^(pavucontrol)$, float on"
      "match:title ^(blueman-manager)$, float on"
      "match:title ^(nm-connection-editor)$, float on"
      "match:title ^(qalculate-gtk)$, float on"

      # Browser Picture in Picture Rules
      "match:title ^(Picture-in-Picture)$, float on, pin on, move 69.5% 4%"
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
