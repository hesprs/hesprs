{ pkgs, inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.noctalia.homeModules.default
    ./symlink.nix
    ./hyprland
    ./ssh
    ./vscode
    ./noctalia
    ./pi
    ./secrets.nix
    ./npm.nix
    ./git.nix
    ./ghostty.nix
    ./dconf.nix
    ./gtk.nix
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
    sessionVariables = {
      GNOME_DESKTOP_SESSION_ID = "this-is-deprecated"; # https://github.com/electron/electron/issues/39789#issuecomment-3433810585
      NIXOS_OZONE_WL = "1";
    };
    pointerCursor.enable = true;
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

  stylix.base16Scheme = ../packages/vivid.yaml;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
