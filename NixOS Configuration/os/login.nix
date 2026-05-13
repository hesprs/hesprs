{
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "tuigreet --time --cmd start-hyprland";
      terminal.vt = 1;
    };
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
}
