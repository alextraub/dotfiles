-- Overrideable settings, resolved once for the whole config.
--
-- base.lua is the tracked source of truth and the fallback for every key.
-- locals.lua holds this machine's overrides and is untracked; if it doesn't
-- exist an empty one is generated, with base.lua commented out for
-- reference. Only keys set in locals.lua override base.lua, so other files
-- can just `require("settings")` and read values directly.

local base_path = assert(package.searchpath("base", package.path))
local locals_path = (base_path:gsub("base%.lua$", "locals.lua"))

local function exists(path)
  local f = io.open(path, "r")
  if f then f:close() end
  return f ~= nil
end

if not exists(locals_path) then
  local src = assert(io.open(base_path, "r"))
  local contents = src:read("*a")
  src:close()

  local dst = io.open(locals_path, "w")
  if dst then
    dst:write(
      "-- Machine-specific overrides. Not tracked in git.\n",
      "-- Set only the keys you want to change; everything else comes from base.lua.\n",
      "-- Example: return { Programs = { TERMINAL = \"foot\" } }\n",
      "\n",
      "-- base.lua at the time this file was generated:\n",
      "--\n",
      (contents:gsub("[^\n]*", "-- %0"):gsub("%-%- \n", "--\n"):gsub("%-%- $", "")),
      "\n",
      "return {}\n"
    )
    dst:close()
  end
end

-- Recursively layer override on top of base without mutating either.
local function merge(base, override)
  local out = {}
  for k, v in pairs(base) do out[k] = v end
  for k, v in pairs(override) do
    if type(v) == "table" and type(out[k]) == "table" then
      out[k] = merge(out[k], v)
    else
      out[k] = v
    end
  end
  return out
end

local base = require("base")

local ok, overrides = pcall(require, "locals")
if not ok then
  io.stderr:write("settings: failed to load locals.lua, using base.lua: ", tostring(overrides), "\n")
  overrides = {}
elseif type(overrides) ~= "table" then
  overrides = {}
end

return merge(base, overrides)
