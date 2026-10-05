-- Vicinae opens with the cursor in its search bar when the whole window fits on the cursor's
-- monitor that way. Otherwise the cursor becomes one corner of the window, picking the corner
-- that keeps it on the monitor. Can be dragged around with SUPER + LMB while open, and closes
-- when you click another window.
-- Needs launcher_window.layer_shell.enabled = false in Vicinae's settings, so it is a normal
-- floating window Hyprland can place and move.

local CLASS = "vicinae"
-- Where the search text starts, measured from the window's top-left corner: just inside the
-- left edge of the search bar, halfway down it
local SEARCH_BAR_X = 18
local SEARCH_BAR_Y = 30

local M = {}

hl.on("window.open", function(w)
  if w.class ~= CLASS then return end
  local cursor = hl.get_cursor_pos()
  local m = hl.get_monitor_at_cursor() or w.monitor
  if not cursor or not m then return end

  local left, top = m.position.x, m.position.y
  local right, bottom = left + m.width, top + m.height
  local wx, wy = w.size.x, w.size.y

  -- Cursor at the start of the search bar, as if clicked there to type
  local x = cursor.x - SEARCH_BAR_X
  local y = cursor.y - SEARCH_BAR_Y

  if x < left or y < top or x + wx > right or y + wy > bottom then
    -- Cursor as a corner: grow right and down when there's room, otherwise left / up
    x = cursor.x + wx <= right and cursor.x or cursor.x - wx
    y = cursor.y + wy <= bottom and cursor.y or cursor.y - wy
    -- Still keep it on the monitor if neither side has room (cursor near the middle of a
    -- monitor smaller than about twice the window)
    x = math.max(left, math.min(x, right - wx))
    y = math.max(top, math.min(y, bottom - wy))
  end

  hl.dispatch(hl.dsp.window.move({ window = w, x = math.floor(x), y = math.floor(y) }))
end)

-- Clicking outside closes it. Focus only moves on click while it is open, so hovering off it
-- doesn't count, then any other window taking focus closes it. float_switch_override_focus has
-- to go too, or hovering from the floating launcher onto a tiled window still moves focus.
local CLICK_TO_FOCUS = {
  ["input.follow_mouse"]                = 2,
  ["input.float_switch_override_focus"] = 0,
}
-- The user's own values of the CLICK_TO_FOCUS settings, saved when the launcher opens so they
-- can be put back when it closes. Also doubles as the "override is active" flag: nil means the
-- user's settings are in effect, a table means click-to-focus is on and these are the originals.
local restore = nil

-- On open, save the user's settings and switch to click-to-focus. Skipped if an override is
-- already active, so a second launcher window can't save the click-to-focus values as the
-- "originals" and leave them stuck on after close.
hl.on("window.open", function(w)
  if w.class ~= CLASS or restore then return end
  restore = {}
  for key in pairs(CLICK_TO_FOCUS) do restore[key] = hl.get_config(key) end
  hl.config(CLICK_TO_FOCUS)
end)

-- On close, put the user's settings back and clear the flag
hl.on("window.close", function(w)
  if w.class ~= CLASS or not restore then return end
  hl.config(restore)
  restore = nil
end)

hl.on("window.active", function(w)
  if not w or w.class == CLASS then return end
  if hl.get_window("class:^" .. CLASS .. "$") then hl.exec_cmd("vicinae close") end
end)

-- Opens or closes based on whether the window exists. `vicinae toggle` reshows instead of closing
-- when it thinks it lost focus, which a SUPER + drag makes it think for the next few presses
M.toggle = function()
  hl.exec_cmd(hl.get_window("class:^" .. CLASS .. "$") and "vicinae close" or "vicinae open")
end

return M
