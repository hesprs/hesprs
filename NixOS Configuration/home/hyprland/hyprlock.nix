{ config, ... }:

{
  stylix.targets.hyprlock.colors.enable = false;

  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        path = "${config.home.homeDirectory}/Pictures/Wallpapers/11.png";
        blur_passes = 2;
        blur_size = 2;
        new_optimizations = true;
        ignore_opacity = false;
      };

      input-field = {
        size = "280, 40";
        outline_thickness = 1;
        dots_size = 0.4;
        outer_color = "rgba(40,40,40,0.0)";
        inner_color = "rgba(200, 200, 200, 0.8)";
        font_color = "rgba(10, 10, 10, 0.8)";
        dots_spacing = 0.2;
        dots_center = true;
        fade_on_empty = false;
        placeholder_text = "Enter Password";
        hide_input = false;
        position = "0, 150";
        halign = "center";
        valign = "bottom";
      };

      label = [
        {
          text = "cmd[update:1000] echo \"<span>$(date '+%A, %d %B')</span>\"";
          color = "rgba(250, 250, 250, 0.8)";
          font_size = 18;
          font_family = "SF Pro Display Bold";
          position = "0, -170";
          halign = "center";
          valign = "top";
        }
        {
          text = "cmd[update:1000] echo \"<span>$(date '+%H:%M')</span>\"";
          color = "rgba(250, 250, 250, 0.8)";
          font_size = 100;
          font_family = "SF Pro Display";
          position = "0, -200";
          halign = "center";
          valign = "top";
        }
        {
          text = "   $USER";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 24;
          font_family = "SF Pro Display";
          position = "0, 210";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
