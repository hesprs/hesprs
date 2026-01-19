{
  description = "Your new nix config";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    stylix.url = "github:nix-community/stylix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs-unstable,
      nixpkgs-stable,
      home-manager,
      zen-browser,
      awww,
      stylix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs-stable = import inputs.nixpkgs-stable;
      pkgs = nixpkgs-unstable.legacyPackages.${system};
    in
    {
      nixosConfigurations.Libertas = nixpkgs-unstable.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          stylix.nixosModules.stylix
          ./os/configuration.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [
              (final: prev: {
                stable = pkgs-stable {
                  inherit system;
                  config = prev.config;
                  overlays = prev.overlays;
                };
              })
              (final: prev: {
                zen = inputs.zen-browser.packages.${system}.default;
              })
              (final: prev: {
                awww = inputs.awww.packages.${system}.awww;
              })
            ];
            home-manager = {
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
