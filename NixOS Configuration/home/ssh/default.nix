{ config, ... }:

{
  home.file.".ssh/id_ed25519.pub".source = ./id_ed25519.pub;
  sops.secrets.ssh-private-key = {
    mode = "0600";
    path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  };
}
