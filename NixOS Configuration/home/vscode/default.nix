{ config, ... }:

let
  thisDir = "${config.home.homeDirectory}/Documents/Configurations/NixOS Configurations/home/vscode";
in
{
  home.mutableFile = {
    ".config/VSCodium/User/keybindings.json".source = "${thisDir}/keybindings.json";
    ".config/VSCodium/User/settings.json".source = "${thisDir}/settings.json";
  };
}
