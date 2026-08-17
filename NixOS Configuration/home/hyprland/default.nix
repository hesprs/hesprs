{ config, ... }:

let
  thisDir = "${config.home.homeDirectory}/Documents/Configurations/NixOS Configuration/home/hyprland";
in
{
  home.mutableFile = {
    ".config/hypr/hyprland.lua".source = "${thisDir}/hyprland.lua";
    ".config/hypr/animations.lua".source = "${thisDir}/animations.lua";
    ".config/hypr/decoration.lua".source = "${thisDir}/decoration.lua";
    ".config/hypr/rules.lua".source = "${thisDir}/rules.lua";
    ".config/hypr/bind.lua".source = "${thisDir}/bind.lua";
  };

  stylix.targets.hyprland.colors.enable = false;
}
