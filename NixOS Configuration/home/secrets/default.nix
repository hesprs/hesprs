{ config, ... }:

{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/user/hesprs/.config/sops/age/keys.txt";
    secrets = {
      npm-token = { };
    };
    templates.".npmrc".template = ''
      //registry.npmjs.org/:_authToken=${config.sops.secrets.npm-token}
      prefix=/home/hesprs/.local/share/npm
    '';
  };
}
