# vicinae dependencies

Stowing this package links one file, the generated Wisteria Dusk launcher theme at `~/.local/share/vicinae/themes/wisteria-dusk.toml`. Nothing else in `~/.local/share/vicinae` (clipboard history, databases, snippets) or `~/.config/vicinae` is touched. Install the following first.

**Always stow this package with `--no-folding`:**

```sh
stow -n -v --no-folding vicinae   # dry run
stow -v --no-folding vicinae
stow -R --no-folding vicinae      # restow
```

Without it, on a machine where `~/.local/share/vicinae` doesn't exist yet, stow would link the whole directory into this repo, and Vicinae would write its clipboard history and databases into the repo. With it, stow creates real directories and links only the theme file.

`~/.config/vicinae/settings.json` is deliberately not in this package: Vicinae rewrites it whenever a setting changes in the GUI.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| Vicinae | Loads custom themes from `~/.local/share/vicinae/themes/`; the theme uses the `[meta]` / `[colors.*]` format printed by `vicinae theme template`. Tested on 0.29.1 | https://docs.vicinae.com/install/linux |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS (AUR, any helper; the docs use yay)
paru -S vicinae-bin

# Fedora (COPR)
sudo dnf copr enable quadratech188/vicinae
sudo dnf install vicinae

# Anything else: the install docs offer a universal script,
# `curl -fsSL https://vicinae.com/install | bash`. Ask before running it.
```

## Optional

| Dependency | Why | Install docs |
|---|---|---|
| Python 3 | Only to regenerate the theme with `python3 theming/generate.py` after editing a theme in `theming/themes/` | https://www.python.org/downloads/ |

## Verify

```sh
command -v vicinae >/dev/null && echo "vicinae ok" || echo "vicinae MISSING"
```

## After stowing

Vicinae only scans its themes directory when the server starts, so a newly stowed theme doesn't show up in "Set Theme" until the server restarts:

```sh
vicinae server --replace
```

Then select the theme (this writes `"theme": { "dark": { "name": "wisteria-dusk" } }` into `~/.config/vicinae/settings.json`):

```sh
vicinae theme set wisteria-dusk
```

Or search "Set Theme" in the launcher. Theme file edits are picked up live.

Check the link with `ls -la ~/.local/share/vicinae/themes/`: `wisteria-dusk.toml` should point into `~/dotfiles/vicinae/`, and the directories should be real directories.
