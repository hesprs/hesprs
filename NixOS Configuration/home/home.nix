{ pkgs, inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./waybar
    ./swaync
    ./hyprland
    ./colours
    ./rofi
    ./secrets
    ./npm.nix
    ./gtk.nix
    ./git.nix
    ./kitty.nix
    ./dconf.nix
    ./stylix.nix
    ./starship.nix
  ];

  programs.home-manager.enable = true;
  programs.fastfetch.enable = true;
  services.dunst.enable = true;

  home = {
    username = "hesprs";
    homeDirectory = "/home/hesprs";
    stateVersion = "25.05";
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
    file."Pictures/Wallpapers" = {
      recursive = true;
      source = ./wallpapers;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
