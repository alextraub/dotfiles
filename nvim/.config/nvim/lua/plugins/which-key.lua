return {
  "folke/which-key.nvim",
  event = "VeryLazy", -- Load after startup; which-key only needs to be ready by the first keypress
  opts = {
    -- Delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    icons = { mappings = true }, -- Nerd Font is required by this config (see DEPENDENCIES.md)
    -- Document existing key chains
    spec = {
      { "<leader>f", group = "[F]ind", mode = { "n", "v" } }, -- Telescope pickers
      { "<leader>t", group = "[T]oggle" },
      { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } }, -- gitsigns on_attach keymaps
      { "<leader>g", group = "[G]it" }, -- fugitive keymaps
      { "<leader>l", group = "[L]ine numbers" },
      { "gr", group = "LSP Actions", mode = { "n" } },
    },
  },
  keys = {
    {
      "<leader>?",
      function() require("which-key").show({ global = false }) end,
      desc = "Buffer local keymaps (which-key)",
    },
  },
}
