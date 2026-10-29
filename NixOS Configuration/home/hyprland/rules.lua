hl.window_rule({
    name = "float-pavucontrol",
    match = { title = "^(pavucontrol)$" },
    float = true,
})

hl.window_rule({
    name = "picture-in-picture",
    match = { title = "^(Picture-in-Picture)$" },
    float = true,
    pin = true,
    move = "69.5% 4%",
})

hl.layer_rule({
    name = "noctalia-blur",
    match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
    },
    no_anim = true,
    ignore_alpha = 0.3,
    blur = true,
    blur_popups = true,
})