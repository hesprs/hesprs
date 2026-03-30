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

  stylix = {
    image = ./wallpapers/11.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-gray.yaml";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
