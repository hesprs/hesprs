{
  stylix.targets.ghostty = {
    opacity.enable = false;
    colors.override.base00-hex = "000000";
  };
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      window-save-state = "never";
      window-width = 950;
      window-height = 500;
      window-padding-x = 10;
      window-padding-7 = 10;
      copy-on-select = false;
      window-decoration = false;
      background-opacity = 0.7;
      scrollback-limit = 2000;
      mouse-scroll-multiplier = 0.7;
    };
  };
}
