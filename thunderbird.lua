-- Events
hl.on("hyprland.start", function()
  hl.exec_cmd("thunderbird")
end)

-- Key bindings
-- Toggle mail client special workspace with Super + M
hl.bind("SUPER + M", hl.dsp.workspace.toggle_special("mail"))

-- Window rules
hl.window_rule({
  match = { class = ".*thunderbird.*" },
  workspace = "special:mail silent",
})
