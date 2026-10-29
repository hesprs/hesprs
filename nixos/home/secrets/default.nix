{ lib, config, pkgs, ... }:

let
  fingerprint = "D06E2C53BE99C65021C90A59008F467B48E4F85E";
  keyfile = config.sops.secrets.gpg-private-key.path;
in
{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    secrets = {
      gpg-private-key = { };
      ssh-private-key = {
        mode = "0600";
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
    };
  };

  programs.git.settings = {
    user.signingKey = fingerprint;
    gpg.format = "openpgp";
    commit.gpgsign = true;
  };

  home.file.".ssh/id_ed25519.pub".source = ./ssh.pub;

  home.activation.importGpgKey = lib.hm.dag.entryAfter [ "sops-nix" ] ''
    if [ -f "${keyfile}" ] && ! ${pkgs.gnupg}/bin/gpg --list-secret-keys "${fingerprint}" >/dev/null 2>&1; then
      ${pkgs.gnupg}/bin/gpg --batch --import "${keyfile}"
      echo "${fingerprint}:6:" | ${pkgs.gnupg}/bin/gpg --import-ownertrust
    fi
  '';
}
