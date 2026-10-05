"""Load a theme JSON from themes/ and the color helpers the targets share.

A theme names its colors however it likes and maps them to roles, the jobs the
targets ask for. Targets only see the neutrals, the roles and the terminal
colors, never the theme's own color names, so any theme with every role filled
in works with every target. See themes/wisteria-dusk.json for an example.
"""
import json
import re
from pathlib import Path

THEMES_DIR = Path(__file__).with_name("themes")

# Background-to-foreground ladder every theme provides, darkest first (for a
# dark theme). Targets use these for surfaces, borders and text.
NEUTRALS = [
    "crust", "mantle", "base",            # backgrounds behind, around and of the main area
    "surface0", "surface1", "surface2",   # raised surfaces: inputs, selections, borders
    "overlay0", "overlay1", "overlay2",   # muted text: disabled, comments, punctuation
    "subtext0", "subtext1", "text",       # secondary and main text
    "bright",                             # emphasized text
]

# Role -> what targets use it for. Several roles may name the same color.
ROLES = {
    # Interface
    "accent": "main accent: focus, active items, primary buttons, keyword-like UI",
    "secondary": "second accent next to accent: gradients, titles, directories",
    "marker": "sparing 'you are here' highlight: cursor, current line number, active "
              "tab marker, insert mode, active workspace, loading, success highlights",
    "link": "links",
    "visited": "visited links",
    "search": "search matches",
    "urgent": "background for urgent or critical items, under bright text",
    # Status
    "error": "errors",
    "warning": "warnings",
    "info": "informational messages",
    "hint": "hints",
    "success": "success and OK messages",
    "added": "added lines and files",
    "changed": "changed lines in diffs",
    "removed": "removed lines and files",
    "modified": "modified files in version control",
    # Syntax
    "keyword": "keywords, built-in types",
    "property": "properties, fields",
    "function": "functions, methods",
    "label": "labels",
    "operator": "operators",
    "character": "characters, enum members, docstrings",
    "string": "strings",
    "type": "types, classes, constructors",
    "module": "modules, namespaces, attributes",
    "constant": "numbers, constants, built-in functions",
    "parameter": "parameters, emphasis in markup",
    "builtin": "built-in variables like self and this",
    "special": "escapes, regexes, macros, preprocessor",
    "identifier": "symbols, todo markers",
}

# Hue slots for apps that label their colors by hue (container colors,
# launcher accents, status bar palettes): the theme's closest color to each.
HUES = ["red", "orange", "yellow", "green", "teal", "cyan", "blue", "purple", "pink"]

HEX = re.compile(r"#[0-9a-fA-F]{6}")


class Theme(dict):
    """Neutral or role name -> hex, readable as c["text"] or c.text.

    Also carries:
      c.hue.<slot>          hue slots, see HUES
      c.ansi                the 16 terminal colors
      c.terminal_background
      c.name                display name, e.g. "Wisteria Dusk"
      c.slug, c.snake, c.pascal   file-name forms: wisteria-dusk, wisteria_dusk, WisteriaDusk
      c.variant             "dark" or "light"
      c.source              theme file path relative to the repo, for generated headers
    """

    def __getattr__(self, name):
        try:
            return self[name]
        except KeyError:
            raise AttributeError(name) from None

    def pick(self, name):
        """A color by name as targets write it in tables: "accent", "base" or "hue.red"."""
        if name.startswith("hue."):
            return self.hue[name[4:]]
        return self[name]


class Hues(Theme):
    pass


def available():
    return sorted(p.stem for p in THEMES_DIR.glob("*.json"))


def find(name):
    """A theme file from a slug (wisteria-dusk) or a path."""
    path = Path(name)
    if path.suffix == ".json" and path.exists():
        return path.resolve()
    path = THEMES_DIR / f"{name}.json"
    if not path.exists():
        raise SystemExit(f"no theme {name!r}; available: {', '.join(available()) or 'none'}")
    return path


def load(path):
    path = Path(path)
    data = json.loads(path.read_text())
    errors = []

    neutrals = data.get("neutrals", {})
    colors = data.get("colors", {})
    roles = dict(data.get("roles", {}))
    hues = roles.pop("hue", {})

    def check_hex(where, value):
        if not HEX.fullmatch(value):
            errors.append(f"{where}: {value!r} is not a #rrggbb color")
        return value

    for name in NEUTRALS:
        if name not in neutrals:
            errors.append(f"neutrals.{name} is missing")
        else:
            check_hex(f"neutrals.{name}", neutrals[name])
    for name, value in colors.items():
        check_hex(f"colors.{name}", value)

    # Role and terminal entries may be a hex value or the name of a color or neutral
    def resolve(where, value):
        if isinstance(value, str) and value.startswith("#"):
            return check_hex(where, value)
        if value in colors:
            return colors[value]
        if value in neutrals:
            return neutrals[value]
        errors.append(f"{where}: {value!r} is not a color or neutral in this theme")
        return "#000000"

    def resolve_all(wanted, given, label):
        missing = [k for k in wanted if k not in given]
        unknown = [k for k in given if k not in wanted]
        errors.extend(f"{label}.{k} is missing" for k in missing)
        errors.extend(f"{label}.{k} is not a known role" for k in unknown)
        return {k: resolve(f"{label}.{k}", given[k]) for k in wanted if k in given}

    resolved_roles = resolve_all(ROLES, roles, "roles")
    resolved_hues = resolve_all(HUES, hues, "roles.hue")

    terminal = data.get("terminal", {})
    ansi = [resolve(f"terminal.ansi[{i}]", v) for i, v in enumerate(terminal.get("ansi", []))]
    if len(ansi) != 16:
        errors.append(f"terminal.ansi needs 16 colors, has {len(ansi)}")
    background = resolve("terminal.background", terminal.get("background", "base"))

    variant = data.get("variant", "dark")
    if variant not in ("dark", "light"):
        errors.append(f"variant: {variant!r} is not dark or light")
    if "name" not in data:
        errors.append("name is missing")

    if errors:
        raise SystemExit(f"{path}:\n  " + "\n  ".join(errors))

    c = Theme({**{k: neutrals[k] for k in NEUTRALS}, **resolved_roles})
    c.hue = Hues(resolved_hues)
    c.ansi = ansi
    c.terminal_background = background
    c.name = data["name"]
    c.variant = variant
    c.slug = path.stem
    c.snake = c.slug.replace("-", "_")
    c.pascal = "".join(part.capitalize() for part in c.slug.split("-"))
    try:
        c.source = str(path.relative_to(THEMES_DIR.parent.parent))
    except ValueError:
        c.source = str(path)
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
