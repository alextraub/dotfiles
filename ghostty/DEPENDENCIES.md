# ghostty dependencies

Stowing this package links `~/.config/ghostty` (`config` and `shaders/cursor-pulse.glsl`). Install the following first.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| Ghostty >= 1.3 | `custom-shader = shaders/cursor-pulse.glsl` reads `iCursorVisible` and `iBackgroundColor`, which are listed in the 1.3 custom-shader docs. Older versions fail to compile the shader and show no cursor, because `cursor-opacity = 0` hides the built-in one. Tested on 1.3.1 | https://ghostty.org/docs/install/binary |
| zsh | `command = zsh` in `config` launches it instead of the login shell. See the `zsh` package | https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH |
| JetBrainsMono Nerd Font (>= 3.0) | `font-family = JetBrainsMono Nerd Font`. Also supplies the icons the `nvim` package expects | https://www.nerdfonts.com/font-downloads · https://github.com/ryanoasis/nerd-fonts#font-installation |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS
sudo pacman -S --needed ghostty zsh ttf-jetbrains-mono-nerd

# macOS
brew install --cask ghostty font-jetbrains-mono-nerd-font
brew install zsh

# Debian / Ubuntu: no official package yet. Use one of the community packages
# listed on the binary install page, or build from source:
# https://ghostty.org/docs/install/build
sudo apt install zsh fontconfig
# Font: download JetBrainsMono.zip from nerdfonts.com, unzip into
# ~/.local/share/fonts, then run `fc-cache -f`.
```

## Optional

None.

## Verify

```sh
ghostty --version | head -1                                            # needs 1.3 or later
command -v zsh >/dev/null && echo "zsh ok" || echo "zsh MISSING"
fc-list : family | grep -q "JetBrainsMono Nerd Font" && echo "font ok" || echo "font MISSING"
ghostty +validate-config && echo "config ok"
```

## After stowing

Running Ghostty windows pick up config and shader changes after a reload: press `ctrl+shift+,`.

Shader compile errors are not reported as config errors. If the cursor disappears, run `GHOSTTY_LOG=stderr ghostty` and look for `shadertoy` lines. Removing the `custom-shader` line and setting `cursor-opacity = 1` brings back the normal cursor.
