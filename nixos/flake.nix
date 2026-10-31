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
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
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
                  betterbird = final.callPackage ./packages/betterbird.nix { };
                  mactahoe-icon-theme = final.callPackage ./packages/icon-theme.nix {
                    themeVariants = [
                      "default"
                      "blue"
                    ];
                    boldPanelIcons = true;
                  };
                  mactahoe-gtk-theme = final.callPackage ./packages/gtk-theme.nix {
                    blur = true;
                  };
                  lark = final.callPackage ./packages/lark.nix { };
                  teleagent = final.callPackage ./packages/teleagent.nix { };
                  wordcraft = final.callPackage ./packages/wordcraft.nix { };
                  cua-driver = final.callPackage ./packages/cua-driver.nix { };
                  # Upstream pins the v3 input route to Hyprland 0.56.2; it does not build against 0.57.0 yet.
                  # Flip withInput back once a released driver tag supports 0.57.0.
                  cua-hyprland-plugin = final.callPackage ./packages/cua-hyprland-plugin.nix {
                    withInput = false;
                  };
                  xdg-desktop-portal-gtk4 = final.callPackage ./packages/xdg-portal-gtk4.nix { };
                })
                (import ./packages/obsidian.nix)
                # (import ./packages/vscodium)
                (import ./packages/pi.nix)
                (import ./packages/agent-browser.nix)
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
