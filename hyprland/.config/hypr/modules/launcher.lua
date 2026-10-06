-- Vicinae opens with the cursor in its search bar when the whole window fits on the cursor's
-- monitor that way. Otherwise the cursor becomes one corner of the window, picking the corner
-- that keeps it on the monitor. Opened with { center = true } (the status bar button), it goes
-- in the middle of the cursor's monitor instead. Can be dragged around with SUPER + LMB while open, and closes
-- when you click another window.
-- Needs launcher_window.layer_shell.enabled = false in Vicinae's settings, so it is a normal
-- floating window Hyprland can place and move.

local CLASS = "vicinae"
-- Where the search text starts, measured from the window's top-left corner: just inside the
-- left edge of the search bar, halfway down it
local SEARCH_BAR_X = 18
local SEARCH_BAR_Y = 30

local M = {}

-- How long a sent `vicinae open` blocks further ones if its window never shows up
local OPEN_TIMEOUT_MS = 2000
-- Set while a `vicinae open` has been sent but its window hasn't appeared yet, so a second
-- press in that gap doesn't send another. Holds that open's options ({ center = true }) for the
-- placement below. A fresh table per open, so a timeout left over from an earlier open can't
-- clear a newer one.
local opening = nil

hl.on("window.open", function(w)
  if w.class ~= CLASS then return end
  local center = opening and opening.center
  opening = nil

  local cursor = hl.get_cursor_pos()
  local m = hl.get_monitor_at_cursor() or w.monitor
  if not cursor or not m then return end

  local left, top = m.position.x, m.position.y
  local right, bottom = left + m.width, top + m.height
  local wx, wy = w.size.x, w.size.y

  if center then
    local x, y = left + (m.width - wx) / 2, top + (m.height - wy) / 2
    hl.dispatch(hl.dsp.window.move({ window = w, x = math.floor(x), y = math.floor(y) }))
    return
  end

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

-- Functions registered with M.on_change, called with true when the launcher opens and false
-- when it closes
local listeners = {}

local function notify(open)
  for _, fn in ipairs(listeners) do
    -- One failing listener shouldn't stop the others or the settings restore around it
    local ok, err = pcall(fn, open)
    if not ok then print("launcher listener failed: " .. tostring(err)) end
  end
end

-- On open, save the user's settings and switch to click-to-focus. Skipped if an override is
-- already active, so a second launcher window can't save the click-to-focus values as the
-- "originals" and leave them stuck on after close.
hl.on("window.open", function(w)
  if w.class ~= CLASS or restore then return end
  restore = {}
  for key in pairs(CLICK_TO_FOCUS) do restore[key] = hl.get_config(key) end
  hl.config(CLICK_TO_FOCUS)
  notify(true)
end)

-- On close, put the user's settings back and clear the flag
hl.on("window.close", function(w)
  if w.class ~= CLASS or not restore then return end
  hl.config(restore)
  restore = nil
  notify(false)
end)

hl.on("window.active", function(w)
  if not w or w.class == CLASS then return end
  if hl.get_window("class:^" .. CLASS .. "$") then hl.exec_cmd("vicinae close") end
end)

-- open, close and toggle are also what Quickshell calls (over Hyprland's socket, see
-- PopupService.qml), so the guards here apply however the launcher is opened.
-- Opens it unless the window already exists or is on its way, in which case it does nothing.
-- opts.center puts it in the middle of the cursor's monitor instead of at the cursor. Anything
-- that isn't a table (e.g. whatever a keybind passes) counts as no options.
M.open = function(opts)
  if opening or hl.get_window("class:^" .. CLASS .. "$") then return end
  local token = { center = type(opts) == "table" and opts.center or false }
  opening = token
  hl.exec_cmd("vicinae open")
  hl.timer(function()
    if opening == token then opening = nil end
  end, { timeout = OPEN_TIMEOUT_MS, type = "oneshot" })
end

M.close = function()
  if hl.get_window("class:^" .. CLASS .. "$") then hl.exec_cmd("vicinae close") end
end

-- Picks open or close from whether the window exists. `vicinae toggle` reshows instead of
-- closing when it thinks it lost focus, which a SUPER + drag makes it think for the next few presses
M.toggle = function(opts)
  if hl.get_window("class:^" .. CLASS .. "$") then M.close() else M.open(opts) end
end

-- For the status bar button, which can only name a function to call
M.toggle_centered = function()
  M.toggle({ center = true })
end

-- Registers fn(open) to run whenever the launcher opens (open = true) or closes (open = false).
-- Rides on the same flag as the click-to-focus override, so it fires once per open/close even
-- if Vicinae briefly has two windows.
M.on_change = function(fn)
  table.insert(listeners, fn)
end

return M
