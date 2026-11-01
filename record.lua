-- Setup
local script_path = os.getenv("HOME") .. "/.config/hypr/scripts/record.sh"

-- Key bindings
hl.bind("CTRL + Print", hl.dsp.exec_cmd("bash " .. script_path))

-- Window rules
hl.window_rule({
  match = {
    title = "(?i)^screen recorder setup",
    class = "zenity",
  },
  float = true,
  center = true,
  stay_focused = true,
  pin = true,
  dim_around = true,
})
