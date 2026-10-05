return {
  {
    -- Icons for various plugins (oil, lualine, telescope)
    "nvim-mini/mini.icons",
    lazy = true, -- Loaded on demand by the plugins that use it
    opts = {},
    init = function()
      -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = {
      -- Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
      mappings = {
        around_next = "aa",
        inside_next = "ii",
      },
      n_lines = 500,
    },
  },
  {
    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {},
  },
}
