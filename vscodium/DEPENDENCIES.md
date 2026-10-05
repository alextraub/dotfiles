# vscodium dependencies

Stowing this package links the two files of the local Wisteria Dusk color theme extension, `~/.vscode-oss/extensions/local.wisteria-dusk-1.0.0/package.json` and `.../themes/wisteria-dusk-color-theme.json`. Nothing else in `~/.vscode-oss` (settings, other extensions, `extensions.json`) is touched. Install the following first.

**Always stow this package with `--no-folding`:**

```sh
stow -n -v --no-folding vscodium   # dry run
stow -v --no-folding vscodium
stow -R --no-folding vscodium      # restow
```

Without it, on a machine where `~/.vscode-oss` doesn't exist yet, stow would link the whole `~/.vscode-oss` directory into this repo, and VSCodium would install every extension into the repo. With it, stow creates real directories and links only the two theme files, so uninstalling the theme from VSCodium can't delete repo files either.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| VSCodium >= 1.80 | `"engines": { "vscode": "^1.80.0" }` in `package.json`. Loads extensions from `~/.vscode-oss/extensions` | https://vscodium.com/#install |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS (AUR, or the CachyOS repo)
paru -S vscodium-bin

# macOS
brew install --cask vscodium

# Debian / Ubuntu: add the VSCodium apt repo as described on
# https://vscodium.com/#install, then:
sudo apt install codium
```

## Optional

| Dependency | Why | Install docs |
|---|---|---|
| Python 3 | Only to regenerate the theme with `python3 theming/generate.py` after editing a theme in `theming/themes/` | https://www.python.org/downloads/ |

## Verify

```sh
command -v codium >/dev/null && echo "codium ok" || echo "codium MISSING"
```

## After stowing

Restart VSCodium (or run "Developer: Reload Window"), then pick **Wisteria Dusk** with "Preferences: Color Theme". To make it the default, set `"workbench.colorTheme": "Wisteria Dusk"` in `~/.config/VSCodium/User/settings.json`.

Check the links with `ls -la ~/.vscode-oss/extensions/local.wisteria-dusk-1.0.0/{,themes/}`: the two files should point into `~/dotfiles/vscodium/`, and the directories should be real directories.
