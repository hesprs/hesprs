{ config, ... }:

let
  thisDir = "${config.home.homeDirectory}/Documents/Configurations/NixOS Configuration/home/noctalia";
in
{
  home.mutableFile.".config/noctalia/settings.json".source = "${thisDir}/settings.json";
}
