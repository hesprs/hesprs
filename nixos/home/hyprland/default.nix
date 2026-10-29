{ pkgs, ... }:

{

  wayland.windowManager.hyprland = {
    enable = true;
    portalPackage = null;
    systemd.enable = false;
    configType = "lua";
    plugins = [ pkgs.cua-hyprland-plugin ];
    extraLuaFiles = {
      animations.content = ./animations.lua;
      decorations.content = ./decorations.lua;
      rules.content = ./rules.lua;
      binds.content = ./binds.lua;
      main.content = ./main.lua;
    };
  };

  stylix.targets.hyprland.colors.enable = false;
}
