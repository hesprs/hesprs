{ pkgs, inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./symlink.nix
    ./vscode
    ./secrets
    ./git.nix
    ./ghostty.nix
    ./dconf.nix
    ./gtk.nix
    ./starship.nix
  ];

  programs.home-manager.enable = true;
  programs.fastfetch.enable = true;
  programs.pi-coding-agent.enable = true;

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
      NIXOS_OZONE_WL = "1";
    };
    pointerCursor = {
      enable = true;
      gtk.enable = true;
    };
  };

  stylix.base16Scheme = ../packages/vivid.yaml;

  # GNOME has no touchpad scroll-speed setting and libinput exposes no
  # scroll-factor API, so WSF interposes on libinput's scroll getters inside
  # gnome-shell (via the systemd user environment) and scales every app's
  # scrolling, Wayland and Xwayland alike.
  xdg.configFile = {
    "wayland-scroll-factor/config".text =
      "scroll_vertical_factor=0.35\nscroll_horizontal_factor=0.35\n";
    "environment.d/wayland-scroll-factor.conf".text =
      "LD_PRELOAD=${pkgs.wayland-scroll-factor}/lib/wayland-scroll-factor/libwsf_preload.so\n";
  };

  # v2rayN has no systemd user service, launch it with the session.
  xdg.autostart = {
    enable = true;
    entries = [ "${pkgs.v2rayn}/share/applications/v2rayn.desktop" ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
