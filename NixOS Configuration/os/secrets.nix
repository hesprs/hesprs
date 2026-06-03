{ config, ... }:

{
	sops = {
    defaultSopsFile = ../home/secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/hesprs/.config/sops/age/keys.txt";
    secrets.github-token = { };
    templates.nix-github-conf.content = ''
      access-tokens = github.com=${config.sops.placeholder.github-token}
    '';
  };
}
