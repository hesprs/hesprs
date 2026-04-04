{ config, ... }:

{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    secrets.github-token = { };
    templates.nix-github-conf.content = ''
      access-tokens = github.com=${config.sops.placeholder.github-token}
    '';
  };

  nix.extraOptions = ''
    !include ${config.sops.templates.nix-github-conf.path}
  '';

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
