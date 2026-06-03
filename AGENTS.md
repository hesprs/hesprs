# AGENTS Guide for `Configurations`

## Scope and layout

- Repo root: `Configurations/`
- NixOS flake root: `NixOS Configuration/`
- NixOS modules: `NixOS Configuration/os/*.nix`
- Home Manager modules: `NixOS Configuration/home/**/*.nix`
- Bootstrap helper: `setup.sh`

## Repository assumptions

- Target platform: Linux/NixOS
- Flake-based workflow
- Main host: `Libertas`
- Exposed output: `nixosConfigurations.Libertas`

## Build, lint, and test commands

Run these from `NixOS Configuration/`.

### Fast sanity checks

```bash
nix flake show
nix flake metadata
nix eval .#nixosConfigurations.Libertas.config.networking.hostName
```

### Full system build

```bash
nix build .#nixosConfigurations.Libertas.config.system.build.toplevel --show-trace
```

### Rebuild commands

```bash
sudo nixos-rebuild dry-build
sudo nixos-rebuild test
sudo nixos-rebuild switch
```

Use `dry-build` or `test` for validation. Use `switch` only when explicitly requested.

### Home Manager-only validation

```bash
nix build .#nixosConfigurations.Libertas.config.home-manager.users.hesprs.home.activationPackage
```

### Formatting / linting

```bash
nixfmt home/**/*.nix os/**/*.nix flake.nix
```

Notes:

- `nixfmt` is available in system packages.
- No dedicated lint tools (`statix`, `deadnix`) are configured yet.

### Flake checks

```bash
nix flake check
```

Current flake has no custom `checks` outputs.
