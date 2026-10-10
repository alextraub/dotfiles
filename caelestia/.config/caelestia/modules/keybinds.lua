local zoomBy = require("modules.zoom").zoomBy
local swapMonitors = require("modules.swap").swapMonitors
local screenWorkspace = require("modules.roles").screenWorkspace
local openLauncher = require("modules.launcher").open

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
hl.bind(mainMod .. " + equal", zoomBy(0.5),  { repeating = true })
hl.bind(mainMod .. " + minus", zoomBy(-0.5), { repeating = true })

hl.bind(mainMod .. " + Space", openLauncher)
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
