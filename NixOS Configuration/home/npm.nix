{ config, ... }:

{
  sops.templates.".npmrc".template = ''
    //registry.npmjs.org/:_authToken=${config.sops.placeholder.npm-token}
    prefix=/home/hesprs/.local/share/npm
  '';
}
