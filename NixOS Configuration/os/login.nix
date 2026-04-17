{
  services.greetd = {
    enable = true;
    settings.default_session.command = "tuigreet --time --cmd start-hyprland";
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
}
