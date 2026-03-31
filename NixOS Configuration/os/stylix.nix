{ pkgs, ... }:

{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-gray.yaml";
    polarity = "dark";
    homeManagerIntegration.followSystem = true;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.sf-pro-display;
        name = "SF Pro Display";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
    icons = {
      enable = true;
      package = pkgs.mactahoe-icon-theme;
      light = "MacTahoe";
      dark = "MacTahoe";
    };
    targets.chromium.enable = false; # must be placed in System Configuration
  };
}
