{
  programs.regreet = {
    enable = true;
    extraCss = ./style.css;
  };
  services.displayManager.defaultSession = "hyprland";
  services.greetd.settings.terminal.vt = 1;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
