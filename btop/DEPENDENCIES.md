# btop dependencies

Stowing this package links one file, the generated Wisteria Dusk theme at `~/.config/btop/themes/wisteria-dusk.theme`. `~/.config/btop/btop.conf` is deliberately not in this package: btop rewrites it on exit. Install the following first.

**Always stow this package with `--no-folding`:**

```sh
stow -n -v --no-folding btop   # dry run
stow -v --no-folding btop
stow -R --no-folding btop      # restow
```

Without it, on a machine where `~/.config/btop` doesn't exist yet, stow would link the whole directory into this repo, and btop would write `btop.conf` and its log into the repo.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| btop | Loads themes from `~/.config/btop/themes/`. The theme uses the keys of btop's built-in Default theme. Tested on 1.4.7 | https://github.com/aristocratos/btop#installation |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS
sudo pacman -S --needed btop

# Debian / Ubuntu
sudo apt install btop

# Fedora
sudo dnf install btop

# macOS
brew install btop
```

## Optional

| Dependency | Why | Install docs |
|---|---|---|
| A 24-bit color terminal | The theme uses hex colors; btop falls back to 256 colors otherwise. Ghostty supports them | https://ghostty.org/docs |

## Verify

```sh
command -v btop >/dev/null && echo "btop ok" || echo "btop MISSING"
[ -f ~/.config/btop/themes/wisteria-dusk.theme ] && echo "theme linked" || echo "theme MISSING"
```

## After stowing

Nothing is required. To use the theme, open btop, press `Esc` → Options, and pick `wisteria-dusk` under Color theme (btop saves it as `color_theme` in `btop.conf`). `main_bg` is left empty so the terminal's background, and Ghostty's background opacity, show through.
