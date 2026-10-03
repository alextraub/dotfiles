# hyprland dependencies

Stowing this package links `~/.config/hypr/{hyprland.lua,settings.lua,base.lua,modules}`. Install the following first.

The config uses the Lua format (`hyprland.lua`), not the older hyprlang `hyprland.conf`. Programs launched by keybinds are set in `base.lua` and can be swapped per machine in the untracked `locals.lua` (see `settings.lua`), so if you override e.g. `Programs.TERMINAL`, install that instead of the default listed here.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| Hyprland >= 0.55 | Lua config (`hyprland.lua`, `hl.*` API) was introduced in 0.55. Tested on 0.56.2 | https://wiki.hypr.land/Getting-Started/Installation/ |
| Ghostty | `Programs.TERMINAL` in `base.lua`, bound to `SUPER + Return` | https://ghostty.org/docs/install/binary |
| Thunar | `Programs.FILE_MANAGER` in `base.lua`, bound to `SUPER + E` | https://docs.xfce.org/xfce/thunar/start |
| hyprlauncher | `Programs.MENU` in `base.lua`, bound to `SUPER + Space` | https://wiki.hypr.land/Hypr-Ecosystem/hyprlauncher/ |
| WirePlumber (`wpctl`) + PipeWire | Volume / mute keys (`XF86Audio*`) in `modules/keybinds.lua` | https://pipewire.pages.freedesktop.org/wireplumber/ |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS
sudo pacman -S --needed hyprland ghostty thunar hyprlauncher pipewire wireplumber

# Other distros: follow the Hyprland installation page. Most distro packages
# lag behind and may be older than 0.55, which cannot read this config.
```

## Optional

| Dependency | Why | Install docs |
|---|---|---|
| brightnessctl | Screen brightness keys (`XF86MonBrightness*`) in `modules/keybinds.lua`. Only matters on laptops | https://github.com/Hummer12007/brightnessctl |
| playerctl | Media keys (`XF86AudioNext/Play/Pause/Prev`) in `modules/keybinds.lua` | https://github.com/altdesktop/playerctl |
| hyprshutdown | `SUPER + SHIFT + M` uses it for a graceful exit; falls back to `hyprctl dispatch 'hl.dsp.exit()'` without it | https://github.com/hyprwm/hyprshutdown |
| gvfs | Trash, removable drives and network locations in Thunar | https://docs.xfce.org/xfce/thunar/start |
| qt6ct | `QT_QPA_PLATFORMTHEME=qt6ct` in `modules/env.lua`. Without it Qt apps fall back to Qt's default light theme. Pick a dark style and color scheme in `qt6ct` after installing | https://github.com/trialuser02/qt6ct |
| qt5-wayland, qt6-wayland | `QT_QPA_PLATFORM=wayland;xcb` in `modules/env.lua`. Without them Qt apps fall back to XWayland | https://wiki.hypr.land/Getting-Started/Master-Tutorial/ |
| xdg-desktop-portal-hyprland | Screen sharing and file pickers. Referenced (commented out) in `modules/permissions.lua` | https://wiki.hypr.land/Hypr-Ecosystem/xdg-desktop-portal-hyprland/ |
| hyprpolkitagent | Password prompts for apps that need elevated rights. Not autostarted yet; add it to `modules/autostarts.lua` | https://wiki.hypr.land/Hypr-Ecosystem/hyprpolkitagent/ |

```sh
# Arch / CachyOS
sudo pacman -S --needed brightnessctl playerctl gvfs qt6ct qt5-wayland qt6-wayland \
  xdg-desktop-portal-hyprland hyprpolkitagent
# hyprshutdown: see its README
```

## Verify

```sh
Hyprland --version | head -1   # needs v0.55 or later
for c in Hyprland ghostty thunar hyprlauncher wpctl; do command -v "$c" >/dev/null && echo "$c ok" || echo "$c MISSING"; done
```

## After stowing

- On the first load, `settings.lua` creates `~/.config/hypr/locals.lua` (untracked, in `.gitignore`) with `base.lua` commented out as reference. Put machine-specific overrides there.
- If `~/.config/hypr` did not exist before stowing, stow links the whole directory into the repo, so `locals.lua` is written to `hyprland/.config/hypr/locals.lua`. It is still gitignored; nothing else to do.
- In a running session, apply changes with:

  ```sh
  hyprctl reload
  ```
