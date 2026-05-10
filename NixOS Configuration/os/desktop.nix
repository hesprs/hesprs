{
  # disable the X11 windowing system.
  services.xserver.enable = false;

  # Disable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;

  services.gvfs.enable = true; # nautilus dependency

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  hardware.graphics.enable = true;
}
