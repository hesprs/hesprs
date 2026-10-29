{ lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./hyprland
    ./noctalia
    ./secrets
    ./vscode
    ./dconf.nix
    ./ghostty.nix
    ./git.nix
    ./gtk.nix
    ./starship.nix
    ./symlink.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = "hesprs";
    homeDirectory = "/home/hesprs";
    stateVersion = "26.05";
    file."Pictures/Wallpapers" = {
      source = ./wallpapers;
      recursive = true;
    };
    sessionPath = [ "\${HOME}/.cache/.bun/bin" ];
    sessionVariables = {
      GNOME_DESKTOP_SESSION_ID = "this-is-deprecated"; # https://github.com/electron/electron/issues/39789#issuecomment-3433810585
      NIXOS_OZONE_WL = "1";
    };
    pointerCursor = {
      enable = true;
      gtk.enable = true;
    };
  };
  stylix.base16Scheme = ../packages/vivid.yaml;
  xdg.portal = {
    # mkForce: the HM hyprland module also defines xdg.portal.enable (as
    # false when its portalPackage is null); outprioritize it so this
    # existing portal setup stays exactly as it is.
    enable = lib.mkForce true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk4
    ];
    config.common.default = [
      "hyprland"
      "gtk4"
    ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
