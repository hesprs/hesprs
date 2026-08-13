{ pkgs, ... }:

let
  theme = {
    package = pkgs.mactahoe-gtk-theme;
    name = "MacTahoe-Dark";
  };
in
{
  stylix.targets.gtk.enable = false;

  gtk = {
    enable = true;
    inherit theme;
    gtk3.theme = theme;
    gtk4.theme = theme;
    colorScheme = "dark";
  };
}
