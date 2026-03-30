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
        command = "start-hyprland";
      };
    };
  };
}
