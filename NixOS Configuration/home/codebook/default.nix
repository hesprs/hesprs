{ config, ... }:

let
  thisDir = "${config.home.homeDirectory}/Documents/Configurations/NixOS Configuration/home/codebook";
in
{
  home.mutableFile.".config/codebook/codebook.toml".source = "${thisDir}/codebook.toml";
}