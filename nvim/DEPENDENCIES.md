# nvim dependencies

Stowing this package links `~/.config/nvim`. Install the following first.

Plugins are managed by [lazy.nvim](https://lazy.folke.io/), which bootstraps itself on first launch and installs the versions pinned in `lazy-lock.json`. The system tools below are what those plugins need.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| Neovim >= 0.12, built with LuaJIT | nvim-treesitter (`main` branch in `lazy-lock.json`) needs 0.12+; `vim.lsp.config` in `lua/plugins/lsp.lua` needs 0.11+ | https://github.com/neovim/neovim/blob/master/INSTALL.md |
| git >= 2.19 | `lua/config/lazy.lua` clones lazy.nvim and all plugins with partial clones | https://lazy.folke.io/#%EF%B8%8F-requirements |
| tree-sitter-cli >= 0.26.1 | nvim-treesitter builds parsers with it (`build = ':TSUpdate'`). Install from a package manager, **not npm** | https://github.com/nvim-treesitter/nvim-treesitter/tree/main#requirements |
| C compiler (gcc or clang) + `make` | nvim-treesitter compiles parsers; telescope-fzf-native uses `build = 'make'` | https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation |
| curl, tar | nvim-treesitter downloads parser sources | https://github.com/nvim-treesitter/nvim-treesitter/tree/main#requirements |
| curl (or wget), unzip, tar, gzip | mason.nvim downloads and unpacks LSP servers | https://github.com/mason-org/mason.nvim#requirements |
| ripgrep | Telescope `live_grep` (`<leader>fg`) needs it; `find_files` prefers it | https://github.com/BurntSushi/ripgrep#installation |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS
sudo pacman -S --needed neovim git curl unzip tar gzip base-devel tree-sitter-cli ripgrep fd

# Debian / Ubuntu: distro neovim and tree-sitter-cli are usually too old.
# Install Neovim >= 0.12 per the Neovim INSTALL.md, and tree-sitter-cli >= 0.26.1 per the nvim-treesitter docs.
sudo apt install git curl unzip tar gzip build-essential ripgrep fd-find

# macOS
brew install neovim git ripgrep fd
# tree-sitter-cli: see the nvim-treesitter requirements link
```

## Optional

| Dependency | Why | Install docs |
|---|---|---|
| Nerd Font (>= 3.3), set as the terminal font | Icons from mini.icons in lualine, Telescope, oil and which-key render as boxes without it | https://www.nerdfonts.com/ · https://github.com/nvim-mini/mini.icons |
| fd | Faster `find_files` in Telescope. On Debian/Ubuntu the binary is `fdfind` | https://github.com/sharkdp/fd#installation |
| luarocks | lazy.nvim uses it for plugins with rockspecs; none of the current plugins need it, but `:checkhealth lazy` warns without it | https://lazy.folke.io/#%EF%B8%8F-requirements |
| qmlls (from Qt 6 Declarative) | QML language server configured in `lua/plugins/lsp.lua`. Not installed through Mason. On Arch it comes from `qt6-declarative` at `/usr/lib/qt6/bin/qmlls`, which is not on `PATH` by default | https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html |
| Terminal with truecolor | catppuccin colorscheme and the transparent background in `lua/plugins/colorscheme.lua` | https://github.com/catppuccin/nvim |

## Verify

```sh
nvim --version | head -1                       # needs v0.12 or later
nvim --version | grep -q LuaJIT && echo "luajit ok"
git --version                                  # needs 2.19 or later
tree-sitter --version                          # needs 0.26.1 or later
for c in cc make curl tar unzip gzip rg; do command -v "$c" >/dev/null && echo "$c ok" || echo "$c MISSING"; done
```

## After stowing

The first launch clones lazy.nvim and installs plugins. To do it without opening the UI:

```sh
nvim --headless "+Lazy! restore" +qa   # install the exact commits from lazy-lock.json
```

Then open `nvim` and run `:checkhealth` to confirm treesitter, telescope, mason and lazy are all healthy.
