#!/usr/bin/env python3
"""Generate the Wisteria Dusk themes from palette.json.

    python3 theming/generate.py

palette.json holds the colors. Each module in targets/ maps them onto one
app and adds whatever else that app needs:

    targets/nvim.py      colors/wisteria_dusk.lua and the lualine theme
    targets/vscodium.py  the VSCodium color theme JSON
    targets/ghostty.py   the Ghostty theme
    targets/quickshell.py  config/colors.json and config/Colors.qml for Quickshell

Generated files are overwritten on every run, so edit the palette or the
target module, never the output.
"""
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent
sys.path.insert(0, str(HERE))
sys.dont_write_bytecode = True  # keep __pycache__ out of the repo

import palette  # noqa: E402
from targets import ghostty, nvim, quickshell, vscodium  # noqa: E402


def main():
    c = palette.load()
    for target in (nvim, vscodium, ghostty, quickshell):
        for path, content in target.build(c).items():
            out = REPO / path
            out.parent.mkdir(parents=True, exist_ok=True)
            out.write_text(content)
            print(f"wrote {path}")


if __name__ == "__main__":
    main()
