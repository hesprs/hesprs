{ config, ... }:

let
  thisDir = "${config.home.homeDirectory}/Documents/Configurations/nixos/home/vscode";
in
{
  home.mutableFile.".config/VSCodium/User/settings.json".source = "${thisDir}/settings.json";
}
