{ config, ... }:

let
  thisDir = "${config.home.homeDirectory}/Documents/Configurations/NixOS Configuration/home/hyprland";
in
{
  home.mutableFile = {
    ".config/hypr/hyprland.lua".source = "${thisDir}/hyprland.lua";
    ".config/hypr/animations.lua".source = "${thisDir}/animations.lua";
    ".config/hypr/decorations.lua".source = "${thisDir}/decorations.lua";
    ".config/hypr/rules.lua".source = "${thisDir}/rules.lua";
    ".config/hypr/binds.lua".source = "${thisDir}/binds.lua";
  };

  stylix.targets.hyprland.colors.enable = false;
}
