local M = {}

-- Windows Magnifier-style full screen zoom with mainMod + -/=
M.zoomBy = function(step)
  return function()
    local current = hl.get_config("cursor:zoom_factor") or 1.0
    local target  = math.max(1.0, math.min(10.0, current + step))
    hl.config({ cursor = { zoom_factor = target } })
  end
end

return M
