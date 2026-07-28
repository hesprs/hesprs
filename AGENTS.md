## Layout

- Repo root: `Configurations/`
- NixOS flake root: `NixOS Configuration/`
- NixOS modules: `NixOS Configuration/os/*.nix`
- Home Manager modules: `NixOS Configuration/home/**/*.nix`
- Nix deviations: `NixOS Configuration/packages/*`
- Bootstrap helper: `setup.sh`

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
