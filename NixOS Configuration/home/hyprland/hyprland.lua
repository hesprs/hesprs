hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1.0,
})

hl.on("hyprland.start", function()
    hl.exec_cmd("v2rayN")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
    general = {
        gaps_in = 6,
        gaps_out = 12,
        border_size = 1,
        col = {
            active_border = "rgba(aaaaaa66)",
            inactive_border = "rgba(aaaaaa66)",
        },
        resize_on_border = true,
        layout = "dwindle",
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    binds = {
        workspace_back_and_forth = false,
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        initial_workspace_tracking = 1,
        middle_click_paste = false,
    },

    ecosystem = {
        no_update_news = true,
    },

    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.3,
            disable_while_typing = false,
        },
    },
})

require("animations")
require("decoration")
require("rules")
require("bind")
