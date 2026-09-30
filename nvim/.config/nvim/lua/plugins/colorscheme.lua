local function setup_colors(scheme)
  vim.cmd.colorscheme(scheme)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      setup_colors("catppuccin")
    end,
    opts = {
    }
  },
}
