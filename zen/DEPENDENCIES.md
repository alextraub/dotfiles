# zen dependencies

Stowing this package links the generated Wisteria Dusk browser theme (`userChrome.css`, `userContent.css`) and a `user.js` that turns stylesheet loading on into `~/.config/zen/wisteria-dusk/`. Zen only reads them from inside a profile folder, whose name differs per machine, so the **After stowing** step links them into the active profile. Nothing else in `~/.config/zen` (profiles, history, logins) is touched. Install the following first.

**Always stow this package with `--no-folding`:**

```sh
stow -n -v --no-folding zen   # dry run
stow -v --no-folding zen
stow -R --no-folding zen      # restow
```

Without it, on a machine where `~/.config/zen` doesn't exist yet, stow would link the whole directory into this repo, and Zen would create its profiles (history, cookies, logins) inside the repo.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| Zen Browser | Loads `<profile>/chrome/userChrome.css` and `userContent.css` once `toolkit.legacyUserProfileCustomizations.stylesheets` is set (`user.js`). Its profiles live in `~/.config/zen`. Tested on 1.22.3b | https://zen-browser.app/download |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS (AUR, any helper)
paru -S zen-browser-bin

# Anything else: Flatpak
flatpak install flathub app.zen_browser.zen
```

The Flatpak keeps its profiles under `~/.var/app/app.zen_browser.zen/`, so the **After stowing** step needs that path instead of `~/.config/zen`.

## Optional

| Dependency | Why | Install docs |
|---|---|---|
| Python 3 | Only to regenerate the theme with `python3 theming/generate.py` after editing `theming/palette.json` | https://www.python.org/downloads/ |

## Verify

```sh
command -v zen-browser >/dev/null && echo "zen ok" || echo "zen MISSING"
```

## After stowing

Run Zen once first so it creates a profile. Then link the theme into the profile Zen opens by default (the `Default=` line in `installs.ini`):

```sh
Z=~/.config/zen
P="$Z/$(sed -n 's/^Default=//p' "$Z/installs.ini" | head -n 1)"
mkdir -p "$P/chrome"
ln -sfn "$Z/wisteria-dusk/userChrome.css" "$Z/wisteria-dusk/userContent.css" "$P/chrome/"
[ -e "$P/user.js" ] && [ ! -L "$P/user.js" ] \
  && echo "$P/user.js exists: add the line from $Z/wisteria-dusk/user.js to it by hand" \
  || ln -sfn "$Z/wisteria-dusk/user.js" "$P/user.js"
```

Leave `chrome/zen-themes.css` alone; Zen Mods writes it. Restart Zen to apply. Zen reads `userChrome.css` only at startup, so restart it after regenerating the theme too.

The rules are inside `@media (prefers-color-scheme: dark)`, so Zen has to be in dark mode (Settings → Look and Feel, or the system theme). The theme replaces any workspace color picked in Zen's theme picker, and keeps the sidebar text light even if that color is light.

Check with `ls -la "$P" "$P/chrome"`: `user.js`, `userChrome.css` and `userContent.css` should point into `~/.config/zen/wisteria-dusk/`, which in turn points into `~/dotfiles/zen/`.
