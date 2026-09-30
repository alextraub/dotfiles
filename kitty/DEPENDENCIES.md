# kitty dependencies

Stowing this package links `~/.config/kitty/kitty.conf`. Install the following first.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| kitty >= 0.37 | `cursor_trail 1` in `kitty.conf` was added in 0.37; older versions ignore it with a warning. Tested on 0.49.1 | https://sw.kovidgoyal.net/kitty/binary/ |
| zsh | `shell zsh` in `kitty.conf` launches it instead of the login shell. See the `zsh` package | https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH |
| JetBrainsMono Nerd Font (>= 3.0) | `font_family JetBrainsMono Nerd Font`. Also supplies the icons the `nvim` package expects | https://www.nerdfonts.com/font-downloads · https://github.com/ryanoasis/nerd-fonts#font-installation |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS
sudo pacman -S --needed kitty zsh ttf-jetbrains-mono-nerd

# macOS
brew install --cask kitty font-jetbrains-mono-nerd-font
brew install zsh

# Debian / Ubuntu: the distro kitty is usually older than 0.37. Use the official
# installer from the kitty binary docs (pipes a remote script to sh, installs to
# ~/.local/kitty.app), then follow its desktop integration steps:
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
sudo apt install zsh fontconfig
# Font: download JetBrainsMono.zip from nerdfonts.com, unzip into
# ~/.local/share/fonts, then run `fc-cache -f`.
```

## Optional

| Dependency | Why | Install docs |
|---|---|---|
| Compositor (X11 only) | `background_opacity 0.80` needs one to be transparent. Wayland compositors such as Hyprland (the `hyprland` package) handle it already | https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.background_opacity |

## Verify

```sh
kitty --version                                                        # needs 0.37 or later
command -v zsh >/dev/null && echo "zsh ok" || echo "zsh MISSING"
fc-list : family | grep -q "JetBrainsMono Nerd Font" && echo "font ok" || echo "font MISSING"
```

## After stowing

Running kitty windows pick up changes after a config reload: press `ctrl+shift+F5`, or

```sh
kill -SIGUSR1 $(pgrep -x kitty)
```

To check the config parses and see which options differ from the defaults, press `ctrl+shift+F6` (the `debug_config` action) in a kitty window.
