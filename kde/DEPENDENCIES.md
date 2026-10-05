# kde dependencies

Stowing this package links one file, the generated Wisteria Dusk KDE color scheme at `~/.local/share/color-schemes/WisteriaDusk.colors`. KDE apps (Dolphin, Kate, Okular) read some colors from `kdeglobals` through KColorScheme rather than from the Qt palette that qt6ct sets, so this scheme covers what the `qt6ct` package can't. `~/.config/kdeglobals` is deliberately not in this package: KDE apps and Plasma rewrite it. Install the following first.

**Always stow this package with `--no-folding`:**

```sh
stow -n -v --no-folding kde   # dry run
stow -v --no-folding kde
stow -R --no-folding kde      # restow
```

Without it, on a machine where `~/.local/share/color-schemes` doesn't exist yet, stow would link the whole directory into this repo, and any scheme saved from a KDE color settings dialog would land in the repo.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| KDE Frameworks 6 (KColorScheme) | Lists and loads schemes from `~/.local/share/color-schemes/`. Pulled in by any KDE app. The file follows the sections of Breeze's `BreezeDark.colors`. Written against Breeze 6.7 | https://develop.kde.org/docs/getting-started/installation/ |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Comes with any KDE app, e.g.
# Arch / CachyOS
sudo pacman -S --needed dolphin

# Debian / Ubuntu
sudo apt install dolphin

# Fedora
sudo dnf install dolphin
```

## Optional

| Dependency | Why | Install docs |
|---|---|---|
| plasma-workspace | Provides `plasma-apply-colorscheme`, which sets the scheme for every KDE app at once | https://invent.kde.org/plasma/plasma-workspace |

## Verify

```sh
[ -f ~/.local/share/color-schemes/WisteriaDusk.colors ] && echo "scheme linked" || echo "scheme MISSING"
```

## After stowing

Nothing is required. Stowing only makes the scheme available; apply it if and when you use a KDE app.

Note for doing that outside a Plasma session (e.g. Hyprland): a KDE app only uses the scheme when it is set in that app's own config. Without it, the app falls back to a stock Breeze scheme and ignores both `kdeglobals` and the qt6ct palette, so applying it globally (`plasma-apply-colorscheme WisteriaDusk` or `kcmshell6 kcm_colors`) isn't enough on its own. Tested with Dolphin 26.08 and KColorScheme 6.30:

```sh
kwriteconfig6 --file dolphinrc --group UiSettings --key ColorScheme WisteriaDusk
# same for other KDE apps, e.g. katerc, okularrc
```

The value is the file name without `.colors`, not the display name. Restart the app to pick it up; delete the `[UiSettings]` lines to undo.
