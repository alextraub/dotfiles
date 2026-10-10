# hyprland dependencies

Stowing this package links `~/.config/hypr/{hyprland.lua,variables.lua,hyprland,scheme,utils,hypridle.conf,hyprpaper.conf,.luarc.json}`. Install the following first.

The config is caelestia's Hyprland config (`hypr/` in https://github.com/caelestia-dots/caelestia, synced at 158ac30) in the Lua format, with small local changes: `shellCmd`, `shellKillCmd` and `polkitAgentCmd` are variables instead of hardcoded, plus `follow_mouse` in `hyprland/input.lua` and `vrr` in `hyprland/misc.lua`. Defaults live in `variables.lua`; `hyprland.lua` overrides them with `~/.config/caelestia/hypr-vars.lua` and then loads `~/.config/caelestia/hypr-user.lua`, both from the `caelestia` package. Apps below are the ones those files pick; if you change one there, install that instead.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| Hyprland >= 0.55 | Lua config (`hyprland.lua`, `hl.*` API) was introduced in 0.55. Tested on 0.56.2 | https://wiki.hypr.land/Getting-Started/Installation/ |
| `caelestia` package from this repo | `hypr-vars.lua` and `hypr-user.lua` (overrides, custom binds and rules) are loaded from `~/.config/caelestia/`; stow that too | [../caelestia/DEPENDENCIES.md](../caelestia/DEPENDENCIES.md) |
| caelestia-cli (`caelestia`) | Writes `scheme/current.lua`, which `variables.lua` and `hypr-vars.lua` read for colors; also runs the screenshot (`Print`), recording (`CTRL + ALT + R` and variants), clipboard (`SUPER + V`) and emoji (`SUPER + Period`) binds in `hyprland/keybinds.lua`. Pulls in grim, slurp, swappy, wl-clipboard, cliphist, fuzzel and gpu-screen-recorder. AUR on Arch | https://github.com/caelestia-dots/cli |
| Ghostty | `terminal` in `hypr-vars.lua`, bound to `SUPER + Return` | https://ghostty.org/docs/install/binary |
| Zen Browser | `browser` in `hypr-vars.lua`, bound to `SUPER + W` | https://zen-browser.app/download/ |
| VSCodium (`codium`) | `editor` in `variables.lua`, bound to `SUPER + C` | https://vscodium.com/#install |
| Thunar | `fileExplorer` in `variables.lua`, bound to `SUPER + E` | https://docs.xfce.org/xfce/thunar/start |
| pwvucontrol | `audioSettings` in `variables.lua`, bound to `CTRL + ALT + V` | https://github.com/saivert/pwvucontrol |
| WirePlumber (`wpctl`) + PipeWire | Volume and mute keys (`XF86Audio*`, `SUPER + SHIFT + M`) in `hyprland/keybinds.lua` | https://pipewire.pages.freedesktop.org/wireplumber/ |
| caelestia-shell + Quickshell (`qs`, the `quickshell-git` AUR package) | Desktop shell, started at login by `shellCmd` from `variables.lua` (`caelestia shell -d`, run by `hyprland/execs.lua`; `shellKillCmd` and `shellCmd` also drive the restart binds in `hyprland/keybinds.lua`). Also handles the `caelestia:*` global binds in `hyprland/keybinds.lua`: session menu (`CTRL + ALT + Delete`), sidebar (`SUPER + N`), lock (`SUPER + L`), region screenshots (`SUPER + SHIFT + S`), brightness keys (`XF86MonBrightness*`) and media keys (`XF86Audio{Play,Pause,Next,Prev,Stop}`, `CTRL + SUPER + Space/Equal/Minus/Backspace`). Its source is the `quickshell` package's `caelestia` submodule; stow that too. AUR on Arch | https://github.com/caelestia-dots/shell |
| hyprpolkitagent | Polkit agent picked by `polkitAgentCmd` in `hypr-vars.lua` (started in `hyprland/execs.lua`), for password prompts from apps that need elevated rights. The command runs `systemctl --user reset-failed` first: when Hyprland restarts without a full logout, the unit keeps restarting with no compositor, hits systemd's start limit, and would otherwise refuse to start in the new session | https://wiki.hypr.land/Hypr-Ecosystem/hyprpolkitagent/ |
| gnome-keyring | `gnome-keyring-daemon --start --components=secrets` in `hyprland/execs.lua`. Provides the D-Bus Secret Service that `vicinae server` waits for in the `autostarts` list in `hypr-vars.lua`; Vicinae aborts at startup (`Database keychain unavailable`) without one. Unlocked with the login password by `pam_gnome_keyring.so` in the login manager's PAM file (SDDM ships it) | https://wiki.gnome.org/Projects/GnomeKeyring |
| Vicinae | `vicinae server` from the `autostarts` list in `hypr-vars.lua`; opened and closed by tapping `SUPER` (bound in the caelestia package's `modules/keybinds.lua`, in place of caelestia's own launcher, which `kbLauncher = ""` in `hypr-vars.lua` turns off); `modules/launcher.lua` also places it at the cursor and closes it on outside clicks. That needs `"launcher_window": { "layer_shell": { "enabled": false } }` in `~/.config/vicinae/settings.json` (not tracked). AUR on Arch (`vicinae-bin`) | https://vicinae.com/docs |
| hypridle | `autostarts` list in `hypr-vars.lua`; reads `hypridle.conf` (screen off after 5 min, lock before sleep) | https://wiki.hypr.land/Hypr-Ecosystem/hypridle/ |
| hyprlock | `lock_cmd` in `hypridle.conf`. No `hyprlock.conf` is tracked here, so it runs with its defaults | https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/ |
| systemd-logind (`loginctl`) | `before_sleep_cmd = loginctl lock-session` in `hypridle.conf`; `systemctl suspend-then-hibernate` is `sleepGestureCmd` in `variables.lua` (`SUPER + SHIFT + L`) | https://www.freedesktop.org/software/systemd/man/latest/loginctl.html |
| awww | `awww-daemon` from the `autostarts` list in `hypr-vars.lua`, as the wallpaper daemon | https://codeberg.org/LGFae/awww |
| SwayNotificationCenter (`swaync`) | Notification daemon, from the `autostarts` list in `hypr-vars.lua` | https://github.com/ErikReider/SwayNotificationCenter |
| cliphist + wl-clipboard | `wl-paste --watch cliphist store` in `hyprland/execs.lua` records clipboard history for `SUPER + V`. Both come with caelestia-cli | https://github.com/sentriz/cliphist |
| qtengine | `QT_QPA_PLATFORMTHEME=qtengine` in `hyprland/env.lua`; caelestia-cli writes its colors and config to `~/.config/qtengine/`, and that config always selects the Darkly widget style (`darkly-qt6-git` in the AUR). Without qtengine Qt apps fall back to Qt's default theme; without Darkly they get caelestia's colors on a fallback style | https://github.com/kossLAN/qtengine |
| Sweet cursors (`Sweet-cursors`) | `cursorTheme` in `hypr-vars.lua` (upstream's `variables.lua` says `sweet-cursors`, which matches no package), set through `XCURSOR_THEME` in `hyprland/env.lua` and `hyprctl setcursor` / `gsettings` in `hyprland/execs.lua`. The untracked `~/.config/gtk-{3,4}.0/settings.ini` should name it too (`gtk-cursor-theme-name=Sweet-cursors`). Builds from source with Inkscape; export `NO_AT_BRIDGE=1` first, or each of its ~370 Inkscape runs prints an accessibility-bus warning that looks like a loop | https://github.com/Gigas002/Sweet |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS
sudo pacman -S --needed hyprland ghostty thunar pipewire wireplumber pwvucontrol \
  hypridle hyprlock awww swaync hyprpolkitagent gnome-keyring
yay -S aur/quickshell-git caelestia-shell caelestia-cli vicinae-bin zen-browser-bin vscodium-bin qtengine darkly-qt6-git   # AUR, or any AUR helper
NO_AT_BRIDGE=1 yay -S --removemake sweet-cursors-git   # long Inkscape build, see the table

# Other distros: follow the Hyprland installation page. Most distro packages
# lag behind and may be older than 0.55, which cannot read this config.
```

## Optional

| Dependency | Why | Install docs |
|---|---|---|
| hyprshutdown | `SUPER + SHIFT + E` in the caelestia package's `modules/keybinds.lua` uses it for a graceful exit; falls back to `hyprctl dispatch 'hl.dsp.exit()'` without it | https://github.com/hyprwm/hyprshutdown |
| hyprpicker | Color picker on `SUPER + SHIFT + C` in `hyprland/keybinds.lua` | https://wiki.hypr.land/Hypr-Ecosystem/hyprpicker/ |
| ydotool | Types the latest clipboard entry on `CTRL + SHIFT + ALT + V` in `hyprland/keybinds.lua` | https://github.com/ReimuNotMoe/ydotool |
| libnotify (`notify-send`) | Test notification on `SUPER + ALT + F12` in `hyprland/keybinds.lua` | https://gitlab.gnome.org/GNOME/libnotify |
| trash-cli (`trash-empty`) | `trash-empty 30` in `hyprland/execs.lua` clears trash older than 30 days at login | https://github.com/andreafrancia/trash-cli |
| gammastep + geoclue | Night light: `gammastep` and geoclue's demo agent (`/usr/lib/geoclue-2.0/demos/agent`) in `hyprland/execs.lua` | https://gitlab.com/chinstrap/gammastep |
| bluez-utils (`mpris-proxy`) | `mpris-proxy` in `hyprland/execs.lua` forwards Bluetooth headset media buttons to MPRIS | https://github.com/bluez/bluez |
| foot, fish, btop | The system monitor special workspace (`CTRL + SHIFT + Escape`) launches `foot … fish -C 'exec btop'` from `utils/functions.lua` | https://codeberg.org/dnkl/foot |
| Spotify + spicetify, Discord, Todoist | Launched by the music (`SUPER + M`), communication (`SUPER + D`) and todo (`SUPER + R`) special workspaces in `utils/functions.lua` | https://spicetify.app/docs/getting-started |
| pipeweaver | `pipeweaver-daemon --background` in the `autostarts` list in `hypr-vars.lua` (audio routing). Only needed if you use it; AUR on Arch | https://github.com/pipeweaver/pipeweaver |
| qt5-wayland, qt6-wayland | `QT_QPA_PLATFORM=wayland;xcb` in `hyprland/env.lua`. Without them Qt apps fall back to XWayland | https://wiki.hypr.land/Getting-Started/Master-Tutorial/ |
| gvfs | Trash, removable drives and network locations in Thunar | https://docs.xfce.org/xfce/thunar/start |
| hyprpaper | Only `hyprpaper.conf` (`splash = false`) refers to it; it is not autostarted, awww sets the wallpaper instead | https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/ |

```sh
# Arch / CachyOS
sudo pacman -S --needed hyprpicker ydotool libnotify trash-cli gammastep geoclue bluez-utils \
  foot fish btop qt5-wayland qt6-wayland gvfs hyprpaper hyprshutdown
yay -S pipeweaver   # AUR, or any AUR helper
```

## Verify

```sh
Hyprland --version | head -1   # needs v0.55 or later
for c in Hyprland caelestia ghostty zen-browser codium thunar pwvucontrol wpctl qs gnome-keyring-daemon vicinae hypridle hyprlock loginctl awww-daemon swaync cliphist wl-paste; do command -v "$c" >/dev/null && echo "$c ok" || echo "$c MISSING"; done
systemctl --user cat hyprpolkitagent.service >/dev/null 2>&1 && echo "hyprpolkitagent ok" || echo "hyprpolkitagent MISSING"
find /usr/lib -path '*platformthemes*' -iname '*qt6engine*' 2>/dev/null | grep -q . && echo "qtengine ok" || echo "qtengine MISSING"
find /usr/lib -path '*styles*' -iname 'darkly*' 2>/dev/null | grep -q . && echo "darkly ok" || echo "darkly MISSING"
find /usr/share/icons ~/.local/share/icons ~/.icons -maxdepth 1 -name Sweet-cursors 2>/dev/null | grep -q . && echo "Sweet-cursors ok" || echo "Sweet-cursors MISSING"
```

## After stowing

- `hyprland.lua` copies `scheme/default.lua` (caelestia's stock colors) to `scheme/current.lua` if it is missing; `caelestia scheme set` (see the `caelestia` package) replaces it with the active scheme. `current.lua` is gitignored.
- In a running session, apply changes with:

  ```sh
  hyprctl reload
  ```
