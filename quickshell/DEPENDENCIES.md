# quickshell dependencies

Stowing this package links `~/.config/quickshell` as a single folded symlink to the repo folder, so new or renamed files need no restow. It holds one Quickshell config, `caelestia/`, in its own subfolder. There must be no `shell.qml` at the top level: if one exists, `qs` treats the whole folder as its single "default" config and ignores the subfolders, which breaks `qs -c caelestia` and the `caelestia shell` commands.

`caelestia/` is a git submodule of https://github.com/alextraub/caelestia-shell: the desktop shell, started at login as `shellCmd` from the `hyprland` package's `variables.lua` (run by its `hyprland/execs.lua`). Run it by hand with `caelestia shell -d` or `qs -c caelestia -n -d`. It is empty until submodules are initialised (see below).

Install the following first.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| Quickshell (git) | Runs the config. caelestia's `shell.qml` uses `//@ pragma DefaultEnv`, which tagged releases and forks like noctalia-qs reject ("Unrecognized pragma"), and its README requires `quickshell-git` | https://quickshell.org/docs/guide/install-setup/ |

Install commands (copied from the linked docs for convenience; if they disagree, the linked docs win):

```sh
# Arch / CachyOS (quickshell-git is in the AUR and replaces quickshell or noctalia-qs).
# Keep the aur/ prefix: cachyos's noctalia-qs "provides" quickshell-git, and without it yay installs that instead.
yay -S aur/quickshell-git

# Fedora
sudo dnf copr enable errornointernet/quickshell
sudo dnf install quickshell

# Debian / Ubuntu: no official package. Build from source:
# https://git.outfoxxed.me/outfoxxed/quickshell
```

## Optional

| Dependency | Why | Install docs |
|---|---|---|
| qmlls | QML language server for editing `shell.qml`; run it as `qmlls -E`. Quickshell writes a machine-specific `.qmlls.ini` next to the config's `shell.qml` for it, which lands in the submodule and is kept out of git by its `.gitignore` | https://quickshell.org/docs/guide/install-setup/ |

## Before stowing

`caelestia/` is a git submodule. Clone the repo with `git clone --recurse-submodules`, or in an existing clone run:

```sh
git submodule update --init
```

To pull changes from the fork into it, run `git submodule update --remote quickshell/.config/quickshell/caelestia` and commit the new pointer.

## caelestia shell (submodule)

`caelestia/` is a fork of [caelestia-dots/shell](https://github.com/caelestia-dots/shell), run as its own Quickshell config with `caelestia shell -d` or `qs -c caelestia -n -d`. Its runtime and build dependencies are listed in the [manual installation section](https://github.com/caelestia-dots/shell#manual-installation) of its README. That README is the source of truth.

The QML lives in the submodule and reaches `~/.config/quickshell/caelestia` through the folded stow link, so editing it in the repo takes effect live. Only the compiled parts get installed to the system: the `Caelestia` QML plugin goes to `/usr/lib/qt6/qml` and the `version` helper to `/usr/lib/caelestia`. The upstream README suggests pointing `INSTALL_QSCONFDIR` at the clone instead. Don't: it would copy the QML onto itself as root and rewrite `shell.qml` to `watchFiles: false`, which leaves the submodule dirty. `ENABLE_MODULES="extras;plugin"` skips that install step.

`CMakeLists.txt` takes `VERSION` from `git describe --tags`, but the fork has no tags. Add the upstream remote once per clone to get them:

```sh
cd ~/dotfiles/quickshell/.config/quickshell/caelestia
git remote add upstream https://github.com/caelestia-dots/shell.git
git fetch upstream --tags
```

Build and install. Rerun this after every submodule update, because the plugin must match the QML:

```sh
cd ~/dotfiles/quickshell/.config/quickshell/caelestia
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_MODULES="extras;plugin"
cmake --build build
sudo cmake --install build
```

`build/` is gitignored by the submodule.

## Verify

```sh
qs --version 2>/dev/null | grep -qi "^quickshell" && echo "quickshell ok" || echo "quickshell MISSING (or a fork like noctalia-qs, see qs --version)"
[ -e ~/dotfiles/quickshell/.config/quickshell/caelestia/.git ] && echo "caelestia submodule ok" || echo "caelestia submodule MISSING (git submodule update --init)"
```

## After stowing

`~/.config/quickshell` must be a symlink (`ls -ld ~/.config/quickshell`). If it is a real directory holding per-file links (e.g. because Quickshell had already written `.qmlls.ini` there), new files will not appear. Refold it:

```sh
rm -f ~/.config/quickshell/*/.qmlls.ini
stow -D quickshell && rmdir ~/.config/quickshell && stow -v quickshell
```
