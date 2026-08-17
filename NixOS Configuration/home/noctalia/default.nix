{ config, ... }:

let
  thisDir = "${config.home.homeDirectory}/Documents/Configurations/NixOS Configuration/home/noctalia";
in
{
  home.mutableFile.".config/noctalia/settings.toml".source = "${thisDir}/settings.toml";
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };
}
