## Before Re-Installation

Preserve:

- `~/.config/sops/age/keys.txt`
- `~/.thunderbird/*`

## After Re-Installation

- Name user to `hesprs`
- Clone Git repo to `~/Documents/Configurations/`
- Recover `~/.config/sops/age/keys.txt`
- Run `./setup.sh`

## Commands

- Update all flakes: `sudo nix flake update --flake /etc/nixos`
- Update individual flake: `sudo nix flake update <flake> --flake /etc/nixos`
- Edit Secret: `sops "NixOS Configuration/secrets/secrets.yaml"`
- Cleanup:

```sh
nix-collect-garbage -d
sudo nix-collect-garbage -d
sudo nixos-rebuild boot
```
