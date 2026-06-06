{
  stylix.targets.ghostty = {
    opacity.enable = false;
    colors.override.base00 = "000000";
  };
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      window-save-state = "never";
      window-width = 950;
      window-height = 500;
      window-padding-x = 10;
      window-padding-y = 10;
      copy-on-select = false;
      window-decoration = false;
      background-opacity = 0.7;
      scrollback-limit = 2000;
      mouse-scroll-multiplier = 0.7;
      window-padding-color = "extend";
      window-padding-balance = true;
      notify-on-command-finish-action = "no-bell,no-notify";
      confirm-close-surface = false;
    };
  };
}
