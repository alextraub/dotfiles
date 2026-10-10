local zoomBy = require("modules.zoom").zoomBy
local swapMonitors = require("modules.swap").swapMonitors
local screenWorkspace = require("modules.roles").screenWorkspace
local toggleLauncher = require("modules.launcher").toggle

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
hl.bind(mainMod .. " + equal", zoomBy(0.5),  { repeating = true })
hl.bind(mainMod .. " + minus", zoomBy(-0.5), { repeating = true })

-- Tapping SUPER on its own toggles Vicinae, like caelestia's launcher bind. hypr-vars.lua empties
-- kbLauncher so caelestia's own isn't made. Hyprland only fires a release bind when the released key
-- was the last one pressed, so SUPER + key binds already skip it, but mouse buttons don't count, so
-- clicks while SUPER is held (a SUPER + drag) are tracked here. Like caelestia's, it also does nothing
-- over a fullscreen window
local superClicked = false
local passThrough = { non_consuming = true }
-- SUPER isn't in the modifier state yet while SUPER_L itself goes down, so this matches each fresh press
hl.bind("SUPER_L", function() superClicked = false end, passThrough)
hl.bind(mainMod .. " + mouse:272", function() superClicked = true end, passThrough)
hl.bind(mainMod .. " + mouse:273", function() superClicked = true end, passThrough)
hl.bind(mainMod .. " + SUPER_L", function()
  local active = hl.get_active_window()
  if superClicked or (active and active.fullscreen ~= 0) then return end
  toggleLauncher()
end, { release = true })

hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + SHIFT + Tab", swapMonitors)

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
-- 1-5 are the right screen's workspaces and 6-0 the left's, whichever IDs each holds after a swap
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  local screen = (i <= 5) and "right" or "left"
  local k = (i - 1) % 5 + 1
  hl.bind(mainMod .. " + " .. key, function()
    hl.dispatch(hl.dsp.focus({ workspace = screenWorkspace(screen, k, i) }))
  end)
  hl.bind(mainMod .. " + SHIFT + " .. key, function()
    hl.dispatch(hl.dsp.window.move({ workspace = screenWorkspace(screen, k, i) }))
  end)
end
