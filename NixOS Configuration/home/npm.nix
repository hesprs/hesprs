{ config, ... }:

{
  home.file.".npmrc".text = ''
    //registry.npmjs.org/:_authToken=${config.sops.secrets.npm-token}
    prefix=/home/hesprs/.local/share/npm
  '';
}
