"""Load palette.json and the color helpers the targets share."""
import json
from pathlib import Path

PALETTE_FILE = Path(__file__).with_name("palette.json")


class Palette(dict):
    """Color name -> hex, readable as c["text"] or c.text.

    Also carries c.name, c.ansi (16 hex colors) and c.terminal_background.
    """

    def __getattr__(self, name):
        try:
            return self[name]
        except KeyError:
            raise AttributeError(name) from None


def load(path=PALETTE_FILE):
    data = json.loads(Path(path).read_text())
    c = Palette({**data["neutrals"], **data["accents"]})

    # Terminal entries may be a hex value or the name of a palette color.
    def resolve(value):
        return value if value.startswith("#") else c[value]

    c.name = data["name"]
    c.terminal_background = resolve(data["terminal"]["background"])
    c.ansi = [resolve(v) for v in data["terminal"]["ansi"]]
    assert len(c.ansi) == 16, "terminal.ansi needs 16 colors"
    return c


def blend(fg, amount, bg):
    """Mix `fg` into `bg` by `amount` (0 = all bg, 1 = all fg)."""
    def rgb(h):
        return [int(h[i:i + 2], 16) for i in (1, 3, 5)]
    mixed = (int(f * amount + b * (1 - amount) + 0.5) for f, b in zip(rgb(fg), rgb(bg)))
    return "#" + "".join(f"{v:02x}" for v in mixed)


def alpha(color, amount):
    """`color` with an alpha channel, as #rrggbbaa."""
    return color + format(round(amount * 255), "02x")
