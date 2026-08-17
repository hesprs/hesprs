hl.window_rule({
    name = "float-pavucontrol",
    match = { title = "^(pavucontrol)$" },
    float = true,
})

hl.window_rule({
    name = "float-blueman-manager",
    match = { title = "^(blueman-manager)$" },
    float = true,
})

hl.window_rule({
    name = "float-nm-connection-editor",
    match = { title = "^(nm-connection-editor)$" },
    float = true,
})

hl.window_rule({
    name = "float-qalculate-gtk",
    match = { title = "^(qalculate-gtk)$" },
    float = true,
})

hl.window_rule({
    name = "picture-in-picture",
    match = { title = "^(Picture-in-Picture)$" },
    float = true,
    pin = true,
    move = "69.5% 4%",
})

for _, namespace in ipairs({
    "swaync-control-center",
    "swaync-notification-window",
    "waybar",
    "rofi",
}) do
    hl.layer_rule({
        name = namespace .. "-blur",
        match = { namespace = namespace },
        blur = true,
    })

    hl.layer_rule({
        name = namespace .. "-ignore-alpha",
        match = { namespace = namespace },
        ignore_alpha = 0.5,
    })
end
