{
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "tuigreet --time --cmd 'uwsm start -eD Hyprland hyprland.desktop'";
      terminal.vt = 1;
    };
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
}
