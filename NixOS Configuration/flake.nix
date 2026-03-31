{
  description = "Your new nix config";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    stylix.url = "github:nix-community/stylix";
    opencode.url = "github:anomalyco/opencode";
    sops-nix.url = "github:Mic92/sops-nix";
    noctalia.url = "github:noctalia-dev/noctalia-shell";
  };

  outputs =
    inputs@{
      self,
      nixpkgs-unstable,
      home-manager,
      zen-browser,
      stylix,
      opencode,
      sops-nix,
      noctalia,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs-unstable.legacyPackages.${system};
    in
    {
      nixosConfigurations.Libertas = nixpkgs-unstable.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          stylix.nixosModules.stylix
          sops-nix.nixosModules.sops
          ./os/configuration.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [
              (import ./packages/codium)
              (final: prev: {
                zen = inputs.zen-browser.packages.${system}.default;
                opencode = inputs.opencode.packages.${system}.default;
                sf-pro-display = final.callPackage ./packages/sf-pro-display { };
                mactahoe-icon-theme = final.callPackage ./packages/icon-theme.nix {
                  themeVariants = [
                    "default"
                    "blue"
                  ];
                  boldPanelIcons = false;
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
