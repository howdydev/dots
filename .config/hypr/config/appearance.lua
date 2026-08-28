hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 7,

        border_size = 1,

        col = {
            active_border = "#344A73",
            inactive_border = "#151923",
        },

        layout = "dwindle",

        resize_on_border = true,
        allow_tearing = false,
    },

    decoration = {
        rounding = 3,
        rounding_power = 2,

        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 2,
            color = "#00000055",
        },

        blur = {
            enabled = true,
            size = 8,
            passes = 2,

            new_optimizations = true,
            xray = false,

            noise = 0.01,
            contrast = 0.9,
            brightness = 0.8,
            vibrancy = 0.1,
        },
    },

    animations = {
        enabled = true,
    },

    misc = {
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
    },

    dwindle = {
        preserve_split = true,
        smart_resizing = true,
        use_active_for_splits = true,
    },
})

hl.curve("smooth", {
    type = "bezier",
    points = {
        { 0.22, 1.0 },
        { 0.36, 1.0 },
    },
})

hl.curve("fast", {
    type = "bezier",
    points = {
        { 0.15, 0.0 },
        { 0.10, 1.0 },
    },
})

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 1.6,
    bezier = "smooth",
})

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 1.4,
    bezier = "smooth",
    style = "popin 98%",
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 1.1,
    bezier = "fast",
    style = "popin 98%",
})

hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 1.4,
    bezier = "fast",
})

hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 1.8,
    bezier = "smooth",
    style = "slidefade 8%",
})

hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 1.4,
    bezier = "smooth",
    style = "fade",
})
