{
  description = "Your new nix config";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    stylix.url = "github:nix-community/stylix";
    opencode.url = "github:anomalyco/opencode";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs-unstable,
      home-manager,
      zen-browser,
      awww,
      stylix,
      opencode,
      sops-nix,
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
              (final: prev: {
                zen = inputs.zen-browser.packages.${system}.default;
                awww = inputs.awww.packages.${system}.default;
                opencode = inputs.opencode.packages.${system}.default;
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
