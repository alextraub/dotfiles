# dotfiles

Personal configuration files, version controlled and symlinked into `$HOME` with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a **stow package**. Its contents mirror the paths they should have relative to `$HOME`:

```
dotfiles/
├── .stowrc                 # default stow options (target ~, ignore DEPENDENCIES.md)
├── zsh/
│   ├── DEPENDENCIES.md     # what to install before stowing this package
│   └── .zshrc              # -> ~/.zshrc
└── nvim/
    ├── DEPENDENCIES.md
    └── .config/nvim/       # -> ~/.config/nvim
```

Every package has a `DEPENDENCIES.md` listing the prerequisites, with links to their install docs. `DEPENDENCIES.md` is never symlinked into `$HOME`.

## Packages

| Package | Links | Dependencies |
|---|---|---|
| `zsh` | `~/.zshrc` | [zsh/DEPENDENCIES.md](zsh/DEPENDENCIES.md) |
| `nvim` | `~/.config/nvim` | [nvim/DEPENDENCIES.md](nvim/DEPENDENCIES.md) |

## Setup on a new machine

1. Install Stow: <https://www.gnu.org/software/stow/> (`pacman -S stow`, `apt install stow`, `brew install stow`).
2. Clone this repo to `~/dotfiles`:
   ```sh
   git clone <repo-url> ~/dotfiles && cd ~/dotfiles
   ```
3. For each package you want, install everything in `<package>/DEPENDENCIES.md`.
4. Preview, then stow:
   ```sh
   stow -n -v zsh   # dry run: shows the links it would create
   stow -v zsh
   ```
5. Run any steps in the package's **After stowing** section (e.g. nvim installs its plugins on first launch).

Always run `stow` from the repo root so `.stowrc` is picked up.

### Conflicts with existing files

If a real file already exists at the target (e.g. a `~/.zshrc` created by an installer), stow aborts. Either:

- **Keep the repo version**: back up and remove the existing file, then stow:
  ```sh
  mv ~/.zshrc ~/.zshrc.bak && stow -v zsh
  ```
- **Keep the machine's version**: pull it into the repo, then review with `git diff`:
  ```sh
  stow --adopt -v zsh && git diff
  ```

## Common commands

| Task | Command |
|---|---|
| Link a package | `stow <pkg>` |
| Unlink a package | `stow -D <pkg>` |
| Re-link after adding/removing files | `stow -R <pkg>` |
| Dry run anything | add `-n -v` |

## Adding a new config

1. Create `<pkg>/` and place files at their `$HOME`-relative paths (e.g. `nvim/.config/nvim/init.lua`).
2. Move the live config into it, then `stow -v <pkg>` (or `stow --adopt -v <pkg>` to adopt in place).
3. Write `<pkg>/DEPENDENCIES.md`, see [AGENTS.md](AGENTS.md) for the template.
4. Add it to the Packages table above.
5. Commit.
