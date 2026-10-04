local M = {}

-- The wallpaper wipe and the window slide share a duration and curve so they move together
local DURATION = 0.5                                    -- seconds
local BEZIER   = { {0.54, 0}, {0.34, 0.99} }            -- awww's default wipe curve
local DELAY    = 0.1                                    -- seconds; awww's wipe starts drawing a bit after awww img returns

hl.curve("monitorSwap", { type = "bezier", points = BEZIER })

local transition = string.format(
  "--transition-duration %s --transition-fps 144 --transition-bezier %s,%s,%s,%s --transition-type",
  DURATION, BEZIER[1][1], BEZIER[1][2], BEZIER[2][1], BEZIER[2][2]
)

-- Prints what awww is showing on output $1 in a form `awww img` accepts
-- (an image path, or 0xRRGGBB for a solid color)
local wallpaperOf = [[wp() { awww query | sed -n "s/^: $1: .*currently displaying: //p" | sed -e 's/^image: //' -e 's/^color: /0x/'; }]]

-- Swaps the workspaces with the window slide timed to match the wallpaper wipe,
-- moves the hidden ones across too, flips the monitor roles so rules follow,
-- then restores the usual window animation (inherited from "windows" in animations.lua)
M.swapWorkspaces = function(a, b)
  -- A monitor may have been unplugged while the wallpapers were being set
  if not (hl.get_monitor(a) and hl.get_monitor(b)) then return end

  local hidden = {}
  for _, ws in ipairs(hl.get_workspaces()) do
    local mon = ws.monitor and ws.monitor.name
    if not ws.special and not ws.visible and (mon == a or mon == b) then
      table.insert(hidden, { id = ws.id, to = (mon == a) and b or a })
    end
  end

  hl.animation({ leaf = "windowsMove", enabled = true, speed = DURATION * 10, bezier = "monitorSwap" })
  hl.dispatch(hl.dsp.workspace.swap_monitors({ monitor1 = a, monitor2 = b }))
  for _, ws in ipairs(hidden) do
    hl.dispatch(hl.dsp.workspace.move({ workspace = ws.id, monitor = ws.to }))
  end
  require("modules.roles").toggle()
  hl.timer(function()
    hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.79, spring = "easy" })
  end, { timeout = math.floor(DURATION * 1000) + 200, type = "oneshot" })
end

-- Swaps the active workspaces and awww wallpapers of the first two monitors
M.swapMonitors = function()
  -- Nothing to swap with a single monitor
  local mons = hl.get_monitors()
  if #mons < 2 then return end
  local left, right = mons[1], mons[2]
  if left.position.x > right.position.x then left, right = right, left end
  local a, b = left.name, right.name

  -- Windows slide toward the other monitor, so the left monitor's new wallpaper wipes
  -- in from its right edge and vice versa. The workspaces are swapped DELAY after awww img
  -- returns so both animations begin together
  hl.exec_cmd(string.format(
    [[%s; A="$(wp %s)"; B="$(wp %s)"; awww img %s right -o %s "$B" & awww img %s left -o %s "$A" & wait; sleep %s; ]] ..
    [[hyprctl dispatch '(function() require("modules.swap").swapWorkspaces("%s", "%s") end)']],
    wallpaperOf, a, b, transition, a, transition, b, DELAY, a, b
  ))
end

-- Trades the wallpapers of the two screens instantly, once awww-daemon is up and has
-- restored its cache. Used at login to undo a swap left over from the last session
M.swapWallpapers = function()
  hl.exec_cmd(string.format(
    [[%s; for _ in $(seq 50); do awww query >/dev/null 2>&1 && break; sleep 0.2; done; awww restore; ]] ..
    [[set -- $(awww query | sed -n 's/^: \([^:]*\): .*/\1/p'); [ $# -eq 2 ] || exit; ]] ..
    [[A="$(wp $1)"; B="$(wp $2)"; awww img --transition-type none -o $1 "$B" & awww img --transition-type none -o $2 "$A" & wait]],
    wallpaperOf
  ))
end

return M
