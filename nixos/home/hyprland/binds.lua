local terminal     = "uwsm app -- ghostty"
local file_manager = "uwsm app -- nautilus"
local browser      = "uwsm app -- zen-beta"
local menu         = "noctalia msg panel-toggle launcher"
local main_mod     = "SUPER"

-- Application Launchers
hl.bind(main_mod .. "_L", hl.dsp.exec_cmd(menu), { release = true })
hl.bind(main_mod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(file_manager .. " -w"))
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd(browser))

-- Window Management
hl.bind(main_mod .. " + C", hl.dsp.window.close())
hl.bind(main_mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(main_mod .. " + J", hl.dsp.layout("togglesplit"))

-- Focus Navigation (Arrow Keys)
hl.bind(main_mod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch to workspace (Mod + 1-9, 0 for 10)
for workspace = 1, 10 do
    local key = workspace % 10
    hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
end

-- Move window to workspace (Mod + Shift + 1-9, 0 for 10)
for workspace = 1, 10 do
    local key = workspace % 10
    hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

-- Special Workspace ("magic")
hl.bind(main_mod .. " + S",     hl.dsp.workspace.toggle_special("magic"))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Audio Control
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

-- Media Player Control (Locked to prevent interference)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),     { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

-- Brightness Control
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"))

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd('noctalia msg screenshot-region'))

-- Lid Switch (Lock Screen)
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("noctalia ipc call lockScreen lock"), { locked = true })

-- Mouse Drag/Resize
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Touchpad Gestures
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})
