-- steam
hl.window_rule({
    name = "steam",
    match = {
        class = "^steam$",
    },
    monitor = "DP-1 silent",
    workspace = "4 silent",
})

-- steam games
hl.window_rule({
    name = "steam-games",
    match = {
        class = "^steam_app_.*",
    },

    monitor = "DP-1 silent",
    workspace = "5 silent",

    fullscreen = true,
    content = "game",

    idle_inhibit = "focus",

    no_anim = true,
    no_shadow = true,

    border_size = 0,
    rounding = 0,
})

hl.window_rule({
    name = "games-by-content",
    match = {
        content = "game",
    },

    idle_inhibit = "focus",

    no_anim = true,
    no_shadow = true,

    border_size = 0,
    rounding = 0,
})

-- Confirmation dialogs, file dialogs, Blender child dialogs, etc.
hl.window_rule({
    name = "modal-dialogs",
    match = {
        modal = true,
    },

    float = true,
    center = true,
})

-- Common simple utility/dialog applications.
hl.window_rule({
    name = "utility-dialogs",
    match = {
        class = "^(zenity|yad)$",
    },

    float = true,
    center = true,
})

hl.window_rule({
    name = "scratchpad-terminal",
    match = {
        class = "^hypr-scratchpad$",
    },

    float = true,
    center = true,

    size = {
        "monitor_w*0.70",
        "monitor_h*0.70",
    },
})
