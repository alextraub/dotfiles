# qt6ct dependencies

Stowing this package links one file, the generated Wisteria Dusk color scheme at `~/.config/qt6ct/colors/wisteria-dusk.conf`, written by `theming/targets/qtct.py` alongside the `qt5ct` one. `~/.config/qt6ct/qt6ct.conf` is deliberately not in this package: qt6ct rewrites it (including window geometry) whenever a setting changes in the GUI. Install the following first.

**Always stow this package with `--no-folding`:**

```sh
stow -n -v --no-folding qt6ct   # dry run
stow -v --no-folding qt6ct
stow -R --no-folding qt6ct      # restow
```

Without it, on a machine where `~/.config/qt6ct` doesn't exist yet, stow would link the whole directory into this repo, and qt6ct would write `qt6ct.conf` into the repo.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| qt6ct | Loads color schemes from `~/.config/qt6ct/colors/`. The scheme lists 22 colors per group, ending with `Accent`, which needs Qt >= 6.6. Tested on qt6ct 0.11 with Qt 6.11 | https://www.opencode.net/trialuser/qt6ct |
| `QT_QPA_PLATFORMTHEME=qt6ct` | Without it Qt apps ignore qt6ct. Set in `hyprland/.config/hypr/modules/env.lua` | https://wiki.archlinux.org/title/Uniform_look_for_Qt_and_GTK_applications |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS
sudo pacman -S --needed qt6ct

# Debian / Ubuntu
sudo apt install qt6ct

# Fedora
sudo dnf install qt6ct
```

## Optional

None.

## Verify

```sh
command -v qt6ct >/dev/null && echo "qt6ct ok" || echo "qt6ct MISSING"
[ "$QT_QPA_PLATFORMTHEME" = qt6ct ] && echo "platform theme ok" || echo "QT_QPA_PLATFORMTHEME not qt6ct"
```

## After stowing

Open `qt6ct`, go to Appearance, tick "Custom" under Palette, and choose `wisteria-dusk` from the color scheme list. A widget style that follows the palette, such as Fusion, shows it most faithfully. Restart Qt apps to pick it up.
