{ pkgs, ... }:

{
  services = {
    xserver.enable = false;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    # First-login wizard, DLNA server, file sharing: none wanted.
    gnome.gnome-initial-setup.enable = false;
    gnome.rygel.enable = false;
    gnome.gnome-user-share.enable = false;
    gvfs.enable = true; # nautilus dependency
  };

  hardware.graphics.enable = true;

  # Keep nautilus / loupe / showtime / decibels / papers, drop the rest of
  # the GNOME app suite.
  environment.gnome.excludePackages = with pkgs; [
    baobab
    epiphany
    gnome-calendar
    gnome-clocks
    gnome-console
    gnome-connections
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-tecla
    gnome-text-editor
    gnome-weather
    simple-scan
    snapshot
    yelp
    gnome-tour
    gnome-user-docs
    orca # screen reader
  ];
}
