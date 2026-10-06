# vesktop dependencies

Stowing this package links one file, the generated Wisteria Dusk theme at `~/.config/vesktop/themes/wisteria-dusk.theme.css`. Nothing else in `~/.config/vesktop` (settings, Quick CSS, session data, logins) is touched. Install the following first.

**Always stow this package with `--no-folding`:**

```sh
stow -n -v --no-folding vesktop   # dry run
stow -v --no-folding vesktop
stow -R --no-folding vesktop      # restow
```

Without it, on a machine where `~/.config/vesktop` doesn't exist yet, stow would link the whole directory into this repo, and Vesktop would write its session data and Discord login into the repo.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| Vesktop | Discord client with Vencord built in; loads themes from `~/.config/vesktop/themes/`. Tested on 1.6.7 | https://github.com/Vencord/Vesktop#installing |
| Network access to refact0r.github.io | The theme `@import`s refact0r's Midnight theme (built CSS, Figtree font and DMs icon) from GitHub Pages on every launch and only sets its color variables. Written against Midnight 2.1.1. Offline, Discord shows its stock look | https://github.com/refact0r/midnight-discord |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS (AUR, any helper)
paru -S vesktop-bin

# Anything else: Flatpak
flatpak install flathub dev.vencord.Vesktop
```

The Flatpak keeps its config under `~/.var/app/dev.vencord.Vesktop/config/vesktop/`, so stow won't reach it; copy the theme file there instead.

## Optional

| Dependency | Why | Install docs |
|---|---|---|
| Python 3 | Only to regenerate the theme with `python3 theming/generate.py` after editing a theme in `theming/themes/` | https://www.python.org/downloads/ |

## Verify

```sh
command -v vesktop >/dev/null && echo "vesktop ok" || echo "vesktop MISSING"
[ -f ~/.config/vesktop/themes/wisteria-dusk.theme.css ] && echo "theme linked" || echo "theme MISSING"
```

## After stowing

Nothing is required. To use the theme, open Vesktop → Settings → Vencord → Themes and enable "Wisteria Dusk" (Vesktop saves it in `~/.config/vesktop/settings/settings.json`, which stays out of the repo). The theme is built for window transparency: its panels are 75% opaque (matching Ghostty's `background-opacity`) and Midnight's solid base layer is removed, so also turn on Settings → Vencord → "Enable window transparency" (`"transparent": true` in that `settings.json`) and restart Vesktop. The `vesktop-no-shadow-blur` rule in `hyprland/.config/hypr/modules/rules.lua` turns Hyprland's blur off for Vesktop, so the desktop shows through unblurred. Without window transparency the see-through panels show whatever Vesktop paints behind them instead (untested). The opacity is `PANEL_OPACITY` in `theming/targets/vesktop.py`.

Midnight's layout options (font, gaps, top bar, window controls, …) are set in `theming/targets/vesktop.py` with Midnight's defaults; change them there and regenerate.
