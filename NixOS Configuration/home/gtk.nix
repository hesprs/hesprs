{
  pkgs,
  ...
}: let
  theme = {
    package = pkgs.mactahoe-gtk-theme;
    name = "MacTahoe-Dark-Blur";
  };
in {
  stylix.targets.gtk.enable = false;

  # Disable GTK3's built-in emoji chooser keybindings (Ctrl+. / Ctrl+;)
  xdg.configFile."gtk-3.0/gtk.css".text = ''
    @binding-set no-emoji {
      unbind "<Control>period";
      unbind "<Control>semicolon";
    }
    entry, textview { -gtk-key-bindings: no-emoji; }
  '';

  gtk = {
    enable = true;
    inherit theme;
    gtk3 = {
      theme = theme;
      extraConfig.gtk-decoration-layout = "menu:";
    };
    gtk4.theme = theme;
    colorScheme = "dark";
  };
}
