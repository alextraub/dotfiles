# dotfiles

Arch / CachyOS desktop: Hyprland, Ghostty, zsh and Neovim, colored by pywal16. This repo is a [GNU Stow](https://www.gnu.org/software/stow/) superproject; each module is its own git repo, added here as a submodule:

| Module | What it configures | Setup doc |
|---|---|---|
| [`theming`](theming) | pywal16 (`wal`) and its reload hooks, plus the theming of apps with no other config here: Firefox, GTK, Qt (qtengine), Vesktop, Vicinae | [theming/DEPENDENCIES.md](theming/DEPENDENCIES.md) |
| [`zsh`](zsh) | `~/.zshrc` (Oh My Zsh), the starship prompt (`starship.toml`) and `LS_COLORS` | [zsh/DEPENDENCIES.md](zsh/DEPENDENCIES.md) |
| [`ghostty`](ghostty) | The Ghostty terminal and its cursor shader | [ghostty/DEPENDENCIES.md](ghostty/DEPENDENCIES.md) |
| [`nvim`](nvim) | Neovim (lazy.nvim, LSP via Mason, treesitter) | [nvim/DEPENDENCIES.md](nvim/DEPENDENCIES.md) |
| [`hyprland`](hyprland) | Hyprland (Lua config), hypridle, the Vicinae launcher and the session's autostarts | [hyprland/DEPENDENCIES.md](hyprland/DEPENDENCIES.md) |

Every module works on its own. The app modules read pywal16's output in `~/.cache/wal/` when it exists and fall back to default colors when it doesn't, so `theming` is optional.

## Get the repo

The module repos are private, so authenticate first:

```sh
gh auth login && gh auth setup-git
git clone --recurse-submodules https://github.com/alextraub/dotfiles.git ~/dotfiles
cd ~/dotfiles
# Already cloned without --recurse-submodules:
git submodule update --init
```

The docs assume `~/dotfiles`, but nothing in the configs depends on the path; any folder inside `~` works. Stow creates relative links, so moving the repo after stowing breaks them: unstow first (`stow -D`), move it, then stow again.

## Setup steps (for people and agents)

Set up one module at a time, in the order below. For each module:

1. **Read the module's `DEPENDENCIES.md` all the way through** before changing anything. It lists what the module links, what to install, and module-specific steps that must happen before or after stowing.
2. **Install the Required dependencies** from its table, and the Optional ones the user wants. Use the install commands in the doc; the linked upstream docs win if they disagree. AUR packages need an AUR helper (`yay` or `paru`).
3. **Do any "before stowing" step** the doc calls out (for zsh: move any existing `~/.zshrc` aside).
4. **Dry run the stow**, from the right directory (see [Stowing](#stowing)):
   ```sh
   stow -n -v <module>
   ```
   If it reports conflicts, see [Conflicts](#conflicts). Don't continue until the dry run is clean.
5. **Stow for real:** `stow -v <module>`.
6. **Run the doc's Verify commands.** Each one should print `ok`; install whatever prints `MISSING`.
7. **Do the doc's "After stowing" steps**, if it has any.

Order:

1. **`theming`, the `wal` package**, if colors are wanted: install pywal16 and stow `wal`. The per-app theming packages come at the end, once their apps are installed.
2. **`zsh`**: Oh My Zsh and starship must be installed first.
3. **`ghostty`**.
4. **`nvim`**: the first launch downloads plugins, parsers and language servers.
5. **`hyprland`**: its doc's Required table covers the whole session, including the apps the other modules configure. The monitor names in `hyprland.lua` and `modules/roles.lua` belong to the original machine; on another machine, replace them with the output of `hyprctl monitors` (or leave the catch-all rule to handle every monitor).
6. **`theming`, the remaining packages** (`firefox`, `gtk`, `qtengine`, `vesktop`, `vicinae`): stow only those whose app is installed, and do each one's manual step in the table.
7. **Apply a colorscheme**, which every stowed hook then picks up:
   ```sh
   wal --theme wisteria-dusk -o ~/.config/wal/post-wal.sh
   ```

Then log out, choose Hyprland in the login manager, and log back in.

## Stowing

- **App modules** (`zsh`, `ghostty`, `nvim`, `hyprland`): run stow from this directory, e.g. `stow -v zsh`. The `.stowrc` here passes `--target=~ --no-folding --ignore=DEPENDENCIES\.md`.
- **Theming packages**: run stow from `theming/`, e.g. `cd theming && stow -v wal gtk`. Its `.stowrc` passes `--target=~ --no-folding`. The module itself is not a stow package; each folder inside it is.
- `--no-folding` matters: several modules add files to shared directories such as `~/.config/wal/post-wal.d/`. Without it, stow could replace one of those directories with a link into a single repo, and pywal16 would then write into that repo.
- To remove a module: `stow -D <module>` from the same directory. To relink after adding or renaming files: `stow -R <module>`.

## Conflicts

A conflict means a real file already exists where stow wants a link (for example a default `~/.zshrc` or a generated `~/.config/hypr/hyprland.conf`).

- Move the existing file aside, then rerun the dry run:
  ```sh
  mv ~/.config/foo/bar ~/.config/foo/bar.pre-dotfiles
  ```
- Never delete it, and never use `stow --adopt`: `--adopt` moves the local file into the repo, overwriting the tracked version.
- If the existing file has settings worth keeping, tell the user rather than merging them in silently.

## Making changes

Each module is its own repo, so a change is committed twice:

```sh
cd ~/dotfiles/<module>
git add -A && git commit -m "…" && git push        # 1. the module
cd ~/dotfiles
git add <module> && git commit -m "Update <module>" && git push   # 2. the pointer here
```

To pull everything on another machine: `git pull && git submodule update --init --recursive`.

A module's `DEPENDENCIES.md` is its setup contract. Update it in the same commit whenever the module gains, drops or renames a dependency, keybind, linked file or setup step.
