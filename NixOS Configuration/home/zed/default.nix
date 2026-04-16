{ config, ... }:

let
  thisDir = "${config.home.homeDirectory}/Documents/Configurations/NixOS Configuration/home/zed";
in
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "rust"
      "oxc"
    ];
  };
  home.mutableFile.".config/zed/settings.json".source = "${thisDir}/settings.json";
}
