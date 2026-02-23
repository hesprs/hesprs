# AGENTS Guide for `Configurations`

This file defines repository conventions for coding agents.
Follow user instructions first; otherwise follow this guide.

## Scope and layout
- Repo root: `Configurations/`
- NixOS flake root: `NixOS Configuration/`
- NixOS modules: `NixOS Configuration/os/*.nix`
- Home Manager modules: `NixOS Configuration/home/**/*.nix`
- VSCode files: `VSCode Configuration/`
- Bootstrap helper: `setup.sh`

## Cursor and Copilot rules
- `.cursor/rules/`: not present
- `.cursorrules`: not present
- `.github/copilot-instructions.md`: not present
- If added later, treat them as highest-priority repo rules.

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
nix build .#nixosConfigurations.Libertas.config.system.build.toplevel
```

### Rebuild commands
```bash
sudo nixos-rebuild dry-build --flake .#Libertas
sudo nixos-rebuild test --flake .#Libertas
sudo nixos-rebuild switch --flake .#Libertas
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

### Running one test/check (important)

When checks are present, run exactly one check:
```bash
nix build .#checks.x86_64-linux.<checkName>
```

When NixOS VM tests are present, run one test:
```bash
nix build .#nixosTests.<testName>
```

Current single-target fallback (option-level sanity test):
```bash
nix eval .#nixosConfigurations.Libertas.config.services.pipewire.enable
```

## Change strategy
- Keep edits narrow and module-local.
- Validate only touched areas before broad builds.
- Avoid formatting churn in unrelated files.
- Do not update `flake.lock` unless requested.

## Code style guidelines

### Module shape and imports
- Use the standard Nix module form:
  1) argument set (`{ pkgs, ... }:`)
  2) blank line
  3) returned attrset
- Keep `imports = [ ... ];` near the top of modules.
- Prefer explicit relative imports (`./desktop.nix`, `./waybar`).
- Keep imports grouped and stable; avoid reorder-only diffs.

### Formatting
- Use 2-space indentation in `.nix` files.
- Use trailing commas in multiline lists and attrsets.
- Use one item per line in multiline lists.
- Prefer double-quoted strings for normal values.
- Use `'' ... ''` for multiline strings or escape-heavy values.
- Keep expressions readable by splitting nested attrsets vertically.

### Types and values
- Match Nix option types strictly.
- Use booleans as `true`/`false`.
- Keep numeric values unquoted.
- Keep enum-like option values as strings.
- Quote attribute names containing dots or hyphens.
  - Example: `"format-icons"`, `"col.active_border"`

### Naming conventions
- File names: lowercase, concise, domain-based (`devices.nix`, `stylix.nix`).
- Feature directories should use `default.nix` entrypoints when modularized.
- Preserve existing canonical names (`Libertas`, `hesprs`).
- Avoid introducing new abbreviations unless widely standard in Nix.

### Dependency and overlay conventions
- Keep flake input names descriptive and stable.
- Use overlays only when package replacement/addition is required.
- Prefer standard overlay signature: `final: prev:`.
- Keep overlay scope minimal; avoid broad package rewrites.

### Error handling and safety
- For risky assumptions, add `assertions` with clear messages.
- For optional config, prefer `lib.mkIf` and `lib.mkDefault`.
- Do not silently remove behavior; provide replacement path.
- Keep secrets encrypted; use `sops-nix` patterns already in repo.
- Never commit decrypted secret material.

### Comments and documentation
- Keep comments brief and purpose-driven.
- Explain why when behavior is non-obvious.
- Keep useful workaround links (e.g., upstream issue references).
- Avoid comments that restate obvious assignments.

## Git hygiene for agents
- Keep commits small and reviewable.
- Never include unrelated file changes in the same commit.
- Report what commands were run and whether they passed.
- If validation was skipped, state why.

## Pre-PR checklist
```bash
nixfmt home/**/*.nix os/**/*.nix flake.nix
nix eval .#nixosConfigurations.Libertas.config.system.stateVersion
nix build .#nixosConfigurations.Libertas.config.system.build.toplevel
```

Optional for Home Manager-heavy edits:
```bash
nix build .#nixosConfigurations.Libertas.config.home-manager.users.hesprs.home.activationPackage
```

Keep this file updated when tooling or project conventions change.
