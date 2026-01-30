{
  imports = [
    ./animations.nix
    ./decoration.nix
    ./rules.nix
    ./bind.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = [ "--all" ];
    xwayland.enable = true;

    settings = {
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$browser" = "zen";
      "$menu" = "rofi -show drun";
      "$mainMod" = "SUPER";

      monitor = [
        ",preferred,auto,1.0"
      ];

      exec-once = [
        "v2rayN"
        "awww-daemon"
        "awww img ~/Pictures/Wallpapers/10.jpg"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      general = {
        gaps_in = 6;
        gaps_out = "0, 12, 12, 12";
        border_size = 1;
        "col.active_border" = "rgba(aaaaaa66)";
        "col.inactive_border" = "rgba(aaaaaa66)";
        resize_on_border = true;
        layout = "dwindle";
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      binds = {
        workspace_back_and_forth = false;
        allow_workspace_cycles = true;
        pass_mouse_when_bound = false;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        initial_workspace_tracking = 1;
      };

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.3;
          disable_while_typing = false;
        };
      };
    };
  };
}
