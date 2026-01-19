{
  pkgs,
  ...
}:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "hesprs";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
      };
    };
  };
}
