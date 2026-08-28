hl.workspace_rule({
    workspace = "special:term",
    on_created_empty = "kitty --class hypr-scratchpad",
})

hl.bind(
    "SUPER + grave",
    hl.dsp.workspace.toggle_special("term")
)
