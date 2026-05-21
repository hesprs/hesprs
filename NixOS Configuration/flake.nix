{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    stylix.url = "github:nix-community/stylix";
    sops-nix.url = "github:Mic92/sops-nix";
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    opencode.url = "github:anomalyco/opencode";
  };

  outputs =
    inputs@{ ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.Libertas = inputs.nixpkgs-unstable.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
          ./os/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          (
            { ... }:
            {
              nixpkgs.overlays = [
                (final: prev: {
                  zen = inputs.zen-browser.packages.${system}.default;
                  sf-pro-display = final.callPackage ./packages/sf-pro-display { };
                  obsidian = prev.obsidian.override {
                    commandLineArgs = "--password-store=gnome-libsecret";
                  };
                  noctalia = inputs.noctalia.packages.${system}.default;
                  opencode = inputs.opencode.packages.${system}.default.overrideAttrs (oldAttrs: {
                    postPatch = ''
                      # Relax the bun version check
                      substituteInPlace packages/script/src/index.ts \
                        --replace-fail 'if (!semver.satisfies(process.versions.bun, expectedBunVersionRange))' \
                                       'if (false && !semver.satisfies(process.versions.bun, expectedBunVersionRange))'
                    '';
                  });
                  mactahoe-icon-theme = final.callPackage ./packages/icon-theme.nix {
                    themeVariants = [
                      "default"
                      "blue"
                    ];
                    boldPanelIcons = true;
                  };
                })
              ];
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                users.hesprs = import ./home/home.nix;
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bak";
              };
            }
          )
        ];
      };
    };
}
