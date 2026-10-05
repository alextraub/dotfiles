# gtk dependencies

Stowing this package links two generated files, `~/.config/gtk-3.0/gtk.css` and `~/.config/gtk-4.0/gtk.css`, which recolor GTK apps with Wisteria Dusk by overriding libadwaita's named colors. `settings.ini`, `colors.css`, `assets/` and `gtk-dark.css` in those directories are deliberately not in this package: nwg-look and KDE's GTK config module write them. Install the following first.

**Always stow this package with `--no-folding`:**

```sh
stow -n -v --no-folding gtk   # dry run
stow -v --no-folding gtk
stow -R --no-folding gtk      # restow
```

Without it, on a machine where `~/.config/gtk-3.0` or `~/.config/gtk-4.0` doesn't exist yet, stow would link the whole directory into this repo, and nwg-look would write `settings.ini` into the repo.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| adw-gtk3 (`adw-gtk3-dark`) | GTK 3 apps only read the `@define-color` overrides in `gtk-3.0/gtk.css` when the theme uses libadwaita's color names, which adw-gtk3 does. Set `gtk-theme-name=adw-gtk3-dark` (e.g. with nwg-look). Tested on 6.5 | https://github.com/lassekongo83/adw-gtk3 |
| libadwaita >= 1.6 | `gtk-4.0/gtk.css` sets the `:root { --window-bg-color: ... }` variables that libadwaita 1.6 introduced. Tested on 1.9 | https://gnome.pages.gitlab.gnome.org/libadwaita/doc/main/css-variables.html |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS
sudo pacman -S --needed adw-gtk-theme libadwaita

# Fedora
sudo dnf install adw-gtk3-theme libadwaita

# Debian / Ubuntu: adw-gtk3 isn't packaged everywhere; download the release
# tarball from the GitHub page and extract it into ~/.local/share/themes.
sudo apt install libadwaita-1-0
```

## Optional

| Dependency | Why | Install docs |
|---|---|---|
| nwg-look | GUI for setting `gtk-theme-name` and the prefer-dark option outside GNOME/KDE | https://github.com/nwg-piotr/nwg-look |

## Verify

```sh
[ -d /usr/share/themes/adw-gtk3-dark ] || [ -d ~/.local/share/themes/adw-gtk3-dark ] && echo "adw-gtk3 ok" || echo "adw-gtk3 MISSING"
pkg-config --modversion libadwaita-1 2>/dev/null || pacman -Q libadwaita   # needs 1.6 or later
gsettings get org.gnome.desktop.interface gtk-theme                         # should be 'adw-gtk3-dark'
```

## After stowing

Restart GTK apps to pick up the colors.

Two tools may replace these links: nwg-look rewrites `~/.config/gtk-4.0/gtk.css` as a symlink into the theme when it applies a theme with its libadwaita option on, and KDE Plasma's GTK config module may rewrite `~/.config/gtk-3.0/gtk.css` when the Plasma color scheme changes. If either happens, restow with `stow -R --no-folding gtk` (move the replaced file aside first).
