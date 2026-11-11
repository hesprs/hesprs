{ pkgs, ... }:

let
  tuigreetConfig = (pkgs.formats.toml { }).generate "tuigreet.toml" {
    secret.mode = "characters";
    background.kind = "matrix";
    layout.widgets.status_position = "hidden";
    session.command = "uwsm start -eD Hyprland hyprland.desktop";
  };
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "tuigreet --config ${tuigreetConfig}";
      terminal.vt = 1;
    };
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
}
