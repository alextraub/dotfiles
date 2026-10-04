vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- NOrmal mode binds
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

vim.keymap.set("n", "<Up>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Down>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Left>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Right>", "<Nop>", { silent = true })
