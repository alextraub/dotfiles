local function clear_bg(group)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  hl.bg = nil
  vim.api.nvim_set_hl(0, group, hl)
end

local function setup_colors(scheme)
  vim.cmd.colorscheme(scheme)
  clear_bg("Normal")
  clear_bg("NormalFloat")
end

setup_colors("wisteria_dusk")
