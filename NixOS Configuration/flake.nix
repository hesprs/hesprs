{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    stylix = {
      url = "github:nix-community/stylix/pull/2337/head";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
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
          (
            { ... }:
            {
              nixpkgs.overlays = [
                (final: prev: {
                  stable = import inputs.nixpkgs-stable {
                    system = system;
                    config.allowUnfree = true;
                  };
                  zen = inputs.zen-browser.packages.${system}.default;
                  sf-pro-display = final.callPackage ./packages/sf-pro-display { };
                  obsidian = prev.obsidian.override {
                    commandLineArgs = "--password-store=gnome-libsecret";
                  };
                  noctalia = inputs.noctalia.packages.${system}.default;
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
          inputs.stylix.nixosModules.stylix
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          ./os/configuration.nix
        ];
      };
    };
}
