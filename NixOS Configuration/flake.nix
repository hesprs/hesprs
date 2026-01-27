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
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
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
      hyprland,
      hyprland-plugins,
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
                zen = inputs.zen-browser.packages.${system}.default;
                awww = inputs.awww.packages.${system}.awww;
                hyprland = inputs.hyprland.packages.${system}.default;
                hyprland-plugins = inputs.hyprland-plugins.packages.${pkgs.system};
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
