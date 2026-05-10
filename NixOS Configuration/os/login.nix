{
  programs.regreet.enable = true;
  services.displayManager.defaultSession = "hyprland";
  services.greetd.settings.terminal.vt = 1;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
