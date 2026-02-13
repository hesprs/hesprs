{ pkgs, ... }:

{
  imports = [
    ./waybar
    ./swaync
    ./hyprland
    ./colours
    ./rofi
    ./gtk.nix
    ./git.nix
    ./swayosd.nix
    ./kitty.nix
    ./dconf.nix
    ./stylix.nix
    ./starship.nix
  ];

  programs.home-manager.enable = true;
  programs.fastfetch.enable = true;
  services.dunst.enable = true;

  home.file."Pictures/Wallpapers" = {
    recursive = true;
    source = ./wallpapers;
  };

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
    sessionVariables = {
      PNPM_HOME = "\${HOME}/.local/share/pnpm";
    };
    sessionPath = [
      "\${PNPM_HOME}"
    ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
