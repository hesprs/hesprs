{ config, ... }:

{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${home.homeDirectory}/.config/sops/age/keys.txt";
  };
}
