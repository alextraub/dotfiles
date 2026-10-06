# hyprland dependencies

Stowing this package links `~/.config/hypr/{hyprland.lua,settings.lua,base.lua,modules,hypridle.conf,hyprpaper.conf}`. Install the following first.

The config uses the Lua format (`hyprland.lua`), not the older hyprlang `hyprland.conf`. Programs launched by keybinds are set in `base.lua` and can be swapped per machine in the untracked `locals.lua` (see `settings.lua`), so if you override e.g. `Programs.TERMINAL`, install that instead of the default listed here.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| Hyprland >= 0.55 | Lua config (`hyprland.lua`, `hl.*` API) was introduced in 0.55. Tested on 0.56.2 | https://wiki.hypr.land/Getting-Started/Installation/ |
| Ghostty | `Programs.TERMINAL` in `base.lua`, bound to `SUPER + Return` | https://ghostty.org/docs/install/binary |
| Thunar | `Programs.FILE_MANAGER` in `base.lua`, bound to `SUPER + E` | https://docs.xfce.org/xfce/thunar/start |
| Vicinae | `vicinae server` autostarted in `modules/autostarts.lua`; opened and closed by the `SUPER + Space` toggle in `modules/launcher.lua`, which also places it at the cursor and closes it on outside clicks. That needs `"launcher_window": { "layer_shell": { "enabled": false } }` in `~/.config/vicinae/settings.json` (not tracked). AUR on Arch (`vicinae-bin`) | https://vicinae.com/docs |
| KWallet (`kwalletd6`) + kwallet-pam | Started via `/usr/lib/pam_kwallet_init` before `vicinae server` in `modules/autostarts.lua`: Vicinae stores secrets through the D-Bus Secret Service and aborts at startup (`Database keychain unavailable`) without one. kwallet-pam unlocks the wallet with the login password (needs `pam_kwallet5.so` in the login manager's PAM file, which SDDM ships, and a wallet password equal to the login password). Any provider of `org.freedesktop.secrets` works (e.g. gnome-keyring) if you swap the command | https://invent.kde.org/frameworks/kwallet |
| WirePlumber (`wpctl`) + PipeWire | Volume / mute keys (`XF86Audio*`) in `modules/keybinds.lua` | https://pipewire.pages.freedesktop.org/wireplumber/ |
| hypridle | Autostarted in `modules/autostarts.lua`; reads `hypridle.conf` (screen off after 5 min, lock before sleep) | https://wiki.hypr.land/Hypr-Ecosystem/hypridle/ |
| hyprlock | `lock_cmd` in `hypridle.conf`. No `hyprlock.conf` is tracked here, so it runs with its defaults | https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/ |
| systemd-logind (`loginctl`) | `before_sleep_cmd = loginctl lock-session` in `hypridle.conf` | https://www.freedesktop.org/software/systemd/man/latest/loginctl.html |
| awww | `awww-daemon` autostarted in `modules/autostarts.lua` as the wallpaper daemon | https://codeberg.org/LGFae/awww |
| Quickshell (`qs`) | Status bar, autostarted in `modules/autostarts.lua`. Its config is the `quickshell` package; stow that too | https://quickshell.org/docs/guide/install-setup/ |
| SwayNotificationCenter (`swaync`) | Notification daemon, autostarted in `modules/autostarts.lua` | https://github.com/ErikReider/SwayNotificationCenter |
| hyprpolkitagent | `systemctl --user start hyprpolkitagent` in `modules/autostarts.lua`, for password prompts from apps that need elevated rights | https://wiki.hypr.land/Hypr-Ecosystem/hyprpolkitagent/ |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS
sudo pacman -S --needed hyprland ghostty thunar pipewire wireplumber \
  hypridle hyprlock awww quickshell swaync hyprpolkitagent kwallet kwallet-pam
yay -S vicinae-bin   # AUR, or any AUR helper

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
| pipeweaver | `pipeweaver-daemon --background` in `modules/autostarts.lua` (audio routing). Only needed if you use it; AUR on Arch | https://github.com/pipeweaver/pipeweaver |
| wlogout | Power menu on `SUPER + M` in `modules/keybinds.lua` | https://github.com/ArtsyMacaw/wlogout |
| wl-clipboard (`wl-copy`) | Copies that screenshot to the clipboard | https://github.com/bugaevc/wl-clipboard |
| libnotify (`notify-send`) | "Screenshot saved" notification for that screenshot | https://gitlab.gnome.org/GNOME/libnotify |
| xdg-user-dirs | Finds the Pictures folder for screenshots (`~/Pictures/Screenshots`); falls back to `~/Pictures` without it | https://www.freedesktop.org/wiki/Software/xdg-user-dirs/ |
| hyprpaper | Only `hyprpaper.conf` (`splash = false`) refers to it; it is not autostarted, awww sets the wallpaper instead | https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/ |

```sh
# Arch / CachyOS
sudo pacman -S --needed brightnessctl playerctl gvfs qt6ct qt5-wayland qt6-wayland \
  xdg-desktop-portal-hyprland wlogout hyprpaper wl-clipboard libnotify xdg-user-dirs
yay -S pipeweaver   # AUR, or any AUR helper
# hyprshutdown: see its README
```

## Verify

```sh
Hyprland --version | head -1   # needs v0.55 or later
for c in Hyprland ghostty thunar vicinae kwalletd6 wpctl hypridle hyprlock loginctl awww-daemon qs swaync; do command -v "$c" >/dev/null && echo "$c ok" || echo "$c MISSING"; done
systemctl --user cat hyprpolkitagent.service >/dev/null 2>&1 && echo "hyprpolkitagent ok" || echo "hyprpolkitagent MISSING"
```

## After stowing

- On the first load, `settings.lua` creates `~/.config/hypr/locals.lua` (untracked, in `.gitignore`) with `base.lua` commented out as reference. Put machine-specific overrides there.
- If `~/.config/hypr` did not exist before stowing, stow links the whole directory into the repo, so `locals.lua` is written to `hyprland/.config/hypr/locals.lua`. It is still gitignored; nothing else to do.
- In a running session, apply changes with:

  ```sh
  hyprctl reload
  ```
