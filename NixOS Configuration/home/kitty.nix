{
  stylix.targets.kitty = {
    opacity.enable = false;
    colors.override = {
      base00 = "#1d1f28";
    };
    variant256Colors = true;
  };
  programs.kitty = {
    enable = true;

    settings = {
      # Set general behavior
      confirm_os_window_close = 0; # Never ask for confirmation
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      remember_window_size = false;
      initial_window_width = 950;
      initial_window_height = 500;
      cursor_blink_interval = 0.5;
      cursor_stop_blinking_after = 1;
      scrollback_lines = 2000;
      wheel_scroll_min_lines = 1;
      enable_audio_bell = false;
      window_padding_width = 10;
      hide_window_decorations = true;
      background_opacity = 0.7;
      dynamic_background_opacity = true;
      touch_scroll_multiplier = 7.0;
    };
  };
}
