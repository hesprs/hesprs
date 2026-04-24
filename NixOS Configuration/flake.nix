{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    stylix.url = "github:nix-community/stylix";
    sops-nix.url = "github:Mic92/sops-nix";
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    opencode.url = "github:anomalyco/opencode?ref=v1.14.22";
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
          {
            nixpkgs.overlays = [
              (final: prev: {
                zen = inputs.zen-browser.packages.${system}.default;
                sf-pro-display = final.callPackage ./packages/sf-pro-display { };
                noctalia = inputs.noctalia.packages.${system}.default;
                opencode = inputs.opencode.packages.${system}.opencode.overrideAttrs (old: {
                  preBuild = (old.preBuild or "") + ''
                    substituteInPlace packages/opencode/src/cli/cmd/generate.ts \
                      --replace-fail 'const prettier = await import("prettier")' 'const prettier: any = { format: async (s: string) => s }' \
                      --replace-fail 'const babel = await import("prettier/plugins/babel")' 'const babel = {}' \
                      --replace-fail 'const estree = await import("prettier/plugins/estree")' 'const estree = {}'
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
        ];
      };
    };
}
