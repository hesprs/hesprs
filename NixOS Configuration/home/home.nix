{ pkgs, inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./symlink.nix
    ./waybar
    ./swaync
    ./hyprland
    ./colours
    ./rofi
    ./vscode
    ./opencode
    ./secrets
    ./npm.nix
    ./gtk.nix
    ./git.nix
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
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
