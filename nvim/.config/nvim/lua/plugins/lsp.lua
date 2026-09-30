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
        cmd = { "qmlls", "-E" },
        filetypes = { "qml", "qmljs" },
      })
    end
  }
}
