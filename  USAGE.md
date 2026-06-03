## Before Re-installation

Preserve `/home/hesprs/.config/sops/age/keys.txt`

## After Re-installation

- Clone Git repo to `/home/hesprs/Documents/Configurations/`
- Recover `/home/hesprs/.config/sops/age/keys.txt`
- Run `./setup.sh`

## Commands

- Update all flakes: `sudo nix flake update --flake /etc/nixos`
- Update individual flake: `sudo nix flake update <flake> --flake /etc/nixos`
- Edit Secret `sops "NixOS Configuration/secrets/secrets.yaml"`
