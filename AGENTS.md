# Agent guide

This repo holds dotfiles managed by **GNU Stow**. Each top-level directory is a stow package whose contents mirror their paths relative to `$HOME`. Read [README.md](README.md) for the human-facing overview.

## Key facts

- Repo lives at `~/dotfiles`. Always run `stow` **from the repo root**, `.stowrc` there sets `--target=~` and ignores `DEPENDENCIES.md` and `.qmlls.ini`.
- Every package **must** contain a `DEPENDENCIES.md`. It is documentation only and is never linked into `$HOME`.
- Top-level files (`README.md`, `AGENTS.md`, `CLAUDE.md`, `.stowrc`) are not packages. Never run `stow .`.
- `theming/` is not a package either. `theming/palette.json` is the single source of truth for the Wisteria Dusk colors, and `python3 theming/generate.py` writes the Neovim colorscheme and lualine theme, the VSCodium theme, the Ghostty theme, the Vicinae theme, the Zen `userChrome.css` and `userContent.css`, the Hyprland `modules/colors.lua` and the Quickshell `config/colors.json` and `config/Colors.qml` from it (per-app mappings live in `theming/targets/`). Edit the palette or a target and rerun; never edit the generated files by hand.
- If a package's `DEPENDENCIES.md` gives stow flags (e.g. `vscodium` needs `--no-folding`), use them for every stow command on that package, including dry runs and restows.

## Setting up a machine

When asked to set up (or install) one or more packages:

1. Confirm `stow` is installed (`command -v stow`). If not, install it with the system package manager.
2. Detect the OS / package manager (`/etc/os-release`, `uname`, `command -v pacman apt dnf brew`).
3. For each requested package, read `<pkg>/DEPENDENCIES.md` and:
   - Run the **Verify** commands first; skip anything already installed.
   - Install missing **Required** deps using the command for this OS. The linked install docs are the source of truth; if an inline command is missing or disagrees with them, follow the docs.
   - Ask the user before installing **Optional** deps.
   - Ask before any command that needs `sudo`, changes the login shell (`chsh`), or pipes a remote script to a shell.
4. Dry run: `stow -n -v <pkg>`.
5. If the dry run reports conflicts ("existing target ... neither a link nor a directory"), **stop and ask the user**:
   - back up the existing file (`mv <file> <file>.bak`) and use the repo version, or
   - `stow --adopt -v <pkg>` to pull the machine's version into the repo, then show `git diff` so they can review it.
   Never delete or overwrite an existing config without confirmation.
6. Run `stow -v <pkg>` and verify links (`ls -la ~/<path>` should point into `~/dotfiles/<pkg>/`).
7. Run the **After stowing** section of `DEPENDENCIES.md`, if there is one.
8. Re-run the Verify commands and report what was installed, linked, and skipped.

Installers that write their own config (e.g. Oh My Zsh writing `~/.zshrc`) must be run in a mode that keeps the existing file; `DEPENDENCIES.md` notes the flags.

## Adding a new package

1. `mkdir <pkg>` and move files in at their `$HOME`-relative paths, e.g. `~/.config/nvim` → `nvim/.config/nvim`.
2. `stow -v <pkg>` to create the symlinks back.
3. Scan the config for what it depends on (sourced files, plugins, binaries on `PATH`, fonts, language runtimes) and write `<pkg>/DEPENDENCIES.md` using the template below.
4. Add the package to the Packages table in `README.md`.
5. Do not commit secrets, tokens, machine-specific history files, or caches (e.g. `.zsh_history`, anything under `~/.cache`).

### DEPENDENCIES.md template

~~~markdown
# <pkg> dependencies

Stowing this package links `<target paths>`. Install the following first.

## Required

| Dependency | Why | Install docs |
|---|---|---|
| <name> | <what in the config needs it> | <official install URL> |

Install commands:

```sh
# per package manager / OS where it differs
```

## Optional

| Dependency | Why | Install docs |
|---|---|---|

## Verify

```sh
# commands that exit 0 / print "ok" when each required dep is present
```

## After stowing (only if needed)

```sh
# one-time steps after linking, e.g. installing plugins
```
~~~

Link to official install docs, not blog posts. The linked doc is the source of truth: inline commands are a convenience copy, and agents should follow the link if they conflict. Keep the "Why" column tied to a specific line or setting in the config so stale deps are easy to spot. When a plugin manager pulls in plugins (e.g. lazy.nvim), list the system tools those plugins need, taking minimum versions from each plugin's own requirements.

## Editing configs

Files in `$HOME` are symlinks into this repo, so editing either path edits the same file. Commit changes from the repo. After adding or removing files in a package, run `stow -R <pkg>`.
