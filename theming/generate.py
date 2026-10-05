#!/usr/bin/env python3
"""Generate app themes from a theme file in themes/.

    python3 theming/generate.py                       # the only theme, if there is one
    python3 theming/generate.py --theme wisteria-dusk
    python3 theming/generate.py --theme path/to/theme.json

A theme file holds a theme's colors and maps them to roles (see palette.py
for the roles every theme has to fill). Each module in targets/ maps the
roles onto one app and adds whatever else that app needs:

    targets/nvim.py      colors/<snake>.lua and the lualine theme
    targets/vscodium.py  the VSCodium color theme extension
    targets/ghostty.py   the Ghostty theme
    targets/quickshell.py  config/colors.json and config/Colors.qml for Quickshell
    targets/vicinae.py   the Vicinae launcher theme
    targets/hyprland.py  modules/colors.lua for Hyprland
    targets/zen.py       userChrome.css, userContent.css and user.js for Zen Browser
    targets/qtct.py      the qt5ct and qt6ct color schemes for Qt apps
    targets/gtk.py       GTK 3 and GTK 4 gtk.css color overrides
    targets/kde.py       the KDE color scheme for KDE apps
    targets/zsh.py       ~/.dircolors and the Oh My Zsh prompt theme
    targets/btop.py      the btop theme

Most outputs are named after the theme (e.g. btop/.../themes/<slug>.theme),
so several themes can sit side by side and each app picks one. A few have a
fixed path (gtk.css, Hyprland colors.lua, Quickshell colors.json, .dircolors)
and hold whichever theme was generated last.

Generated files are overwritten on every run, so edit the theme file or the
target module, never the output.
"""
import argparse
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent
sys.path.insert(0, str(HERE))
sys.dont_write_bytecode = True  # keep __pycache__ out of the repo

import palette  # noqa: E402
from targets import btop, ghostty, gtk, hyprland, kde, nvim, qtct, quickshell, vicinae, vscodium, zen, zsh  # noqa: E402

TARGETS = (nvim, vscodium, ghostty, quickshell, vicinae, hyprland, zen, qtct, gtk, kde, zsh, btop)


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--theme", help="theme slug in themes/ or path to a theme JSON")
    args = parser.parse_args()

    name = args.theme
    if name is None:
        themes = palette.available()
        if len(themes) != 1:
            raise SystemExit(f"several themes in themes/, pick one with --theme: {', '.join(themes)}")
        name = themes[0]

    c = palette.load(palette.find(name))
    for target in TARGETS:
        for path, content in target.build(c).items():
            out = REPO / path
            out.parent.mkdir(parents=True, exist_ok=True)
            out.write_text(content)
            print(f"wrote {path}")


if __name__ == "__main__":
    main()
