package.path = package.path .. ";./?.lua;./?/init.lua"

local smw = require("plugins.split-monitor-workspaces")

smw.setup({
    workspace_count = 5,

    monitor_priority = { "DP-1", "DP-2" },

    keep_focused = true,
    enable_notifications = false,
    enable_persistent_workspaces = true,
    enable_wrapping = true,
    link_monitors = false,
})

local mod = "SUPER"

for i = 1, smw.get_amount_of_workspaces() do
    local n = tostring(i)
    hl.bind(mod .. " + " .. n, smw.workspace(n))
    hl.bind(mod .. " + SHIFT + " .. n, smw.move_to_workspace_silent(n))
end

hl.bind("SUPER + mouse_down", smw.cycle_workspaces("next"))
hl.bind("SUPER + mouse_up", smw.cycle_workspaces("prev"))
