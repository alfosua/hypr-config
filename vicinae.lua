-- Global variables --
local mod = "SUPER"

-- Key bindings --
-- Open Vicinae toggle menu on Super+Space
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("vicinae toggle"))
-- Open Vicinae clipboard history on Super+Y
hl.bind(mod .. " + Y", hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"))

-- Event-handling --
hl.on("hyprland.start", function()
  -- Start vicinae background server
  hl.exec_cmd("vicinae server")
end)

-- Window rules --
hl.window_rule({
  match = { class = "vicinae" },
  float = true,
  center = true,
  stay_focused = true,
  pin = true,
})

-- Layer rules --
hl.layer_rule({
  match = { namespace = "vicinae" },
  blur = true,
  ignore_alpha = 0.5,
})
