# zsh dependencies

Stowing this package links `~/.zshrc`. Install the following first.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| zsh | The shell itself | https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH |
| Oh My Zsh | Framework sourced from `$HOME/.oh-my-zsh` | https://github.com/ohmyzsh/ohmyzsh#basic-installation |
| zsh-autosuggestions | Listed in `plugins=(...)`; must be cloned into `$ZSH_CUSTOM/plugins` | https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md (source of truth; use the "Oh My Zsh" section) |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# zsh (pick the one for your package manager)
sudo pacman -S zsh          # Arch / CachyOS
sudo apt install zsh        # Debian / Ubuntu
brew install zsh            # macOS

# Oh My Zsh: use --unattended and --keep-zshrc so it does not overwrite the stowed ~/.zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

# zsh-autosuggestions plugin, Oh My Zsh method from INSTALL.md.
# Already enabled in plugins=(...) in .zshrc, so only the clone is needed.
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Make zsh the login shell (optional)
chsh -s "$(command -v zsh)"
```

## Optional

| Dependency | Why | Install docs |
|---|---|---|
| Bun | `~/.bun/bin` is prepended to `PATH`; harmless if absent | https://bun.sh/docs/installation |

## Verify

```sh
zsh --version
test -f ~/.oh-my-zsh/oh-my-zsh.sh && echo "oh-my-zsh ok"
test -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" && echo "autosuggestions ok"
```
