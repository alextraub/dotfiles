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
    end
  }
}
