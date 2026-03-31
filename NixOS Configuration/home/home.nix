{ pkgs, inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.noctalia.homeModules.default
    ./symlink.nix
    ./hyprland
    ./vscode
    ./opencode
    ./secrets
    ./npm.nix
    ./git.nix
    ./shell.nix
    ./kitty.nix
    ./dconf.nix
    ./starship.nix
  ];

  programs.home-manager.enable = true;
  programs.fastfetch.enable = true;
  services.dunst.enable = true;

  home = {
    username = "hesprs";
    homeDirectory = "/home/hesprs";
    stateVersion = "25.05";
    file."Pictures/Wallpapers" = {
      source = ./wallpapers;
      recursive = true;
    };
  };

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-gray.yaml";

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
