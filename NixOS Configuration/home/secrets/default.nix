{ config, ... }:

{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };

  # template
  #
  # sops = {
  #   secrets.npm-token = { };
  #   templates.".npmrc".content = ''
  #     //registry.npmjs.org/:_authToken=${config.sops.placeholder.npm-token}
  #     prefix=/home/hesprs/.local/share/npm
  #   '';
  # };
}
