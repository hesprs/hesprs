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
    image = ./wallpapers/11.png;
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = (pkgs.callPackage ./fonts/SFDisplay { });
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
    targets.chromium.enable = false; # must be placed in System Configuration
  };
}
