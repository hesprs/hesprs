{
  stylix.targets.ghostty = {
    opacity.enable = false;
    colors.override.base00 = "0C0C0E";
  };
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      window-save-state = "never";
      window-padding-x = 10;
      window-padding-y = 10;
      copy-on-select = false;
      window-decoration = true;
      background-opacity = 0.6;
      scrollback-limit = 2000;
      mouse-scroll-multiplier = 0.7;
      window-padding-color = "extend";
      window-padding-balance = true;
      notify-on-command-finish-action = "no-bell,no-notify";
      confirm-close-surface = false;
      cursor-style = "bar";
      adjust-cursor-thickness = 1;
    };
  };
}
