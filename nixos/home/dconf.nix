{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/system/proxy".mode = "manual";
      "org/gnome/system/proxy/http" = {
        host = "127.0.0.1";
        port = 10808;
      };
      "org/gnome/system/proxy/https" = {
        host = "127.0.0.1";
        port = 10808;
      };
      "org/gnome/desktop/wm/preferences".button-layout = ":";
      "org/gnome/desktop/interface".accent-color = "purple";
    };
  };
}
