hl.config({
    general = {
        border_size = 1,
        col = {
            active_border = "rgba(aaaaad55)",
            inactive_border = "rgba(88888b55)",
        },
    },
    decoration = {
        rounding = 20,
        rounding_power = 3;
        dim_inactive = true,
        dim_strength = 0.1,

        blur = {
            enabled = true,
            size = 3,
            passes = 4,
            vibrancy = 0.3,
            ignore_opacity = true,
            xray = true,
            noise = 0,
        },

        shadow = {
            enabled = true,
            range = 1,
            color = "rgba(000000d3)",
            color_inactive = "rgba(0000008d)",
            sharp = true,
        },
    },
})