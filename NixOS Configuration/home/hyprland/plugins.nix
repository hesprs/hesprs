{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    plugins = with pkgs; [
      hyprland-plugins.borders-plus-plus
    ];
    settings.plugin = {
      borders-plus-plus = {
        add_borders = 1;
        col.border_1 = "rgba(44, 44, 44, 0.15)";
        border_size_1 = -1;
        natural_rounding = false;
      };
    };
  };
}
