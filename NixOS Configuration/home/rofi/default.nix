{
  stylix.targets.rofi.enable = false;
  programs.rofi = {
    enable = true;
    theme = ./styles.rasi;
    extraConfig = {
      modi = [
        "drun"
        "filebrowser"
        "window"
        "run"
      ];
      font = "JetBrainsMono Nerd Font";
      show-icons = true;
      display-drun = " ";
      display-run = " ";
      display-filebrowser = "";
      display-window = "";
      drun-display-format = "{name}";
      hover-select = false;
      scroll-method = 1;
      me-select-entry = "";
      me-accept-entry = "MousePrimary";
      window-format = "{w} · {c} · {t}";
    };
  };
}
