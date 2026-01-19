{
  # 1. Enable the Home Manager Kitty module
  programs.kitty = {
    enable = true;

    # 2. Configure fonts
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    # 3. Configure settings
    # The 'settings' attribute set directly corresponds to options in kitty.conf
    # (e.g., setting background_opacity 0.5 in kitty.conf maps to background_opacity = 0.5 in Nix)
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
