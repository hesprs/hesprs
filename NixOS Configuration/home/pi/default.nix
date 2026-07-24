{ config, ... }:

let
  thisDir = "${config.home.homeDirectory}/Documents/Configurations/NixOS Configuration/home/pi";
in
{
  home.mutableFile = {
    ".pi/agent/settings.json".source = "${thisDir}/settings.json";
    ".pi/agent/models.json".source = "${thisDir}/models.json";
  };
  programs.pi-coding-agent.enable = true;
}
