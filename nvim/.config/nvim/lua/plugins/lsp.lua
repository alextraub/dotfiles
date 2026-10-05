return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      { "neovim/nvim-lspconfig" },
    },
    config = function ()
      require("mason").setup()
      require("mason-lspconfig").setup()

      vim.lsp.config("qmlls", {
        cmd = { "qmlls" },
        filetypes = { "qml", "qmljs" },
      })

      vim.o.autocomplete = true
    end
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the documentation for more options
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  }
}
