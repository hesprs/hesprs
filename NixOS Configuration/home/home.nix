{ pkgs, inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.noctalia.homeModules.default
    ./symlink.nix
    ./hyprland
    ./codebook
    ./ssh
    ./noctalia
    ./zed
    ./secrets.nix
    ./npm.nix
    ./git.nix
    ./ghostty.nix
    ./dconf.nix
    ./starship.nix
    ./opencode.nix
  ];

  programs.home-manager.enable = true;
  programs.fastfetch.enable = true;
  services.dunst.enable = true;

  home = {
    username = "hesprs";
    homeDirectory = "/home/hesprs";
    stateVersion = "26.05";
    file."Pictures/Wallpapers" = {
      source = ./wallpapers;
      recursive = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [
      "hyprland"
      "gtk"
    ];
  };

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml";

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
