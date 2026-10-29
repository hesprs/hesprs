{
  # disable the X11 windowing system.
  services = {
    xserver.enable = false;
    # Disable the GNOME Desktop Environment.
    displayManager.gdm.enable = false;
    desktopManager.gnome.enable = false;
    gvfs.enable = true; # nautilus dependency
    gnome = {
      gnome-keyring.enable = true;
      at-spi2-core.enable = true;
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  hardware.graphics.enable = true;
}
