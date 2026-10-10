local M = {}

-- Rules are written against roles rather than physical monitors, so swapping the
-- roles (modules/swap.lua) makes the screens trade places completely.
-- These are the defaults; a swap flips them until the next login (see hyprland.start below).
local DEFAULT = {
  main = "desc:ASUSTek COMPUTER INC PG27AQDM S3LMRS014609",
  side = "desc:Microstep MAG274QRF-QD CA8A291700643",
}

-- Workspaces that belong to each role. The first one opens there on startup
local WORKSPACES = {
  main = { 1, 2, 3, 4, 5 },
  side = { 6, 7, 8, 9, 10 },
}

-- Apps that open on a role's screen, e.g. { class = "^(discord|vesktop)$", role = "side" }
local APPS = {
}

-- Remembers the swap across config reloads (see readSwapped and hyprland.start below)
local STATE_DIR  = (os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")) .. "/hypr"
local STATE_FILE = STATE_DIR .. "/monitor-roles.json"

local function readSwapped()
  local f = io.open(STATE_FILE, "r")
  if not f then return false end
  local contents = f:read("*a")
  f:close()
  return contents:match('"swapped"%s*:%s*true') ~= nil
end

M.swapped = readSwapped()

-- The monitor selector (desc:...) currently playing a role
M.monitorFor = function(role)
  if M.swapped then role = (role == "main") and "side" or "main" end
  return DEFAULT[role]
end

-- Connector name (e.g. DP-2) for a role, or nil if that monitor isn't connected
local function nameFor(role)
  local mon = hl.get_monitor(M.monitorFor(role))
  return mon and mon.name
end

-- The k-th workspace of the left or right screen, out of whichever role's
-- workspaces that screen holds right now (so it follows swaps).
-- With a single screen, `fallback` is used as is
M.screenWorkspace = function(screen, k, fallback)
  local mons = hl.get_monitors()
  if #mons < 2 then return fallback end
  table.sort(mons, function(a, b) return a.position.x < b.position.x end)
  local name = (screen == "right") and mons[#mons].name or mons[1].name
  for role, ids in pairs(WORKSPACES) do
    if nameFor(role) == name then return ids[k] end
  end
  return fallback
end

local function writeState()
  os.execute(string.format("mkdir -p '%s'", STATE_DIR))
  local f = io.open(STATE_FILE, "w")
  if not f then return end
  -- With only one monitor connected, it is main whichever role it normally plays
  local main, side = nameFor("main"), nameFor("side")
  if not main then main, side = side, nil end
  f:write(string.format('{ "swapped": %s, "main": "%s", "side": "%s" }\n',
    tostring(M.swapped), main or "", side or ""))
  f:close()
end

-- (Re)points every role-based rule at the monitors currently playing each role.
-- Calling the rule functions again with the same workspace or name updates them in place
M.apply = function()
  for role, ids in pairs(WORKSPACES) do
    for i, id in ipairs(ids) do
      hl.workspace_rule({ workspace = tostring(id), monitor = M.monitorFor(role), default = (i == 1), persistent = true })
    end
  end
  for i, app in ipairs(APPS) do
    hl.window_rule({
      name    = "role-app-" .. i,
      match   = { class = app.class },
      monitor = nameFor(app.role) or M.monitorFor(app.role),
    })
  end
  writeState()
end

M.toggle = function()
  M.swapped = not M.swapped
  M.apply()
end

M.apply()

-- A swap only lasts for the session: a fresh login starts with the default roles,
-- while config reloads keep the current swap. awww restores the swapped wallpapers
-- from its cache, so they are traded back too
hl.on("hyprland.start", function()
  if not M.swapped then return end
  M.toggle()
  require("modules.swap").swapWallpapers()
end)

-- Monitors aren't connected yet while the config first loads, so refresh the
-- connector names once they appear, and again when one is unplugged
hl.on("monitor.added", M.apply)
hl.on("monitor.removed", M.apply)

return M
