{ config, lib, ... }:

let
  thisDir = "${config.home.homeDirectory}/Documents/Configurations/NixOS Configuration/home/zed";
in
{
  programs.zed-editor = {
    enable = true;
    userSettings.buffer_font_size = lib.mkForce 13;
  };
  home.mutableFile.".config/zed/settings.json".source = "${thisDir}/settings.json";
}
