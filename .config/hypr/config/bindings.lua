local mod = "SUPER"

hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + Space", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("kitty -e yazi"))

hl.bind(mod .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"))

hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(
    "SUPER + T",
    hl.dsp.window.float({
        action = "toggle",
    })
)

hl.bind(
    "SUPER + M",
    hl.dsp.window.fullscreen({
        mode = "maximized",
        action = "toggle",
    })
)

hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))

hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), {
    mouse = true,
})

hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), {
    mouse = true,
})

hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true }
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true }
)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), {
    locked = true,
})
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), {
    locked = true,
})
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), {
    locked = true,
})
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), {
    locked = true,
})
