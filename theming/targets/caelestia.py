"""caelestia-cli color scheme. `caelestia scheme set -n <slug>` turns it into
~/.local/state/caelestia/scheme.json and the files rendered from it (Hyprland's
scheme/current.lua, gtk.css, ...). Keys follow the schemes shipped in
caelestia/data/schemes: Material 3 roles, terminal colors, Catppuccin-style
names and KDE link/status colors. caelestia only looks for schemes in its own
data dir, so caelestia/DEPENDENCIES.md links this folder in there.

Container and dimmed colors are the role blended over crust."""
from palette import blend

OUT = "caelestia/.local/share/caelestia/schemes/{slug}/default/{variant}.txt"

# Accent roles caelestia builds container, fixed and selection colors for
ACCENTS = {"primary": "accent", "secondary": "secondary", "tertiary": "hue.pink"}


def build(c):
    def over(name, amount):
        return blend(c.pick(name), amount, c.crust)

    keys = {
        "primary_paletteKeyColor": c.accent,
        "secondary_paletteKeyColor": c.secondary,
        "tertiary_paletteKeyColor": c.hue.pink,
        "neutral_paletteKeyColor": c.overlay1,
        "neutral_variant_paletteKeyColor": c.overlay0,
        "background": c.crust,
        "onBackground": c.text,
        "surface": c.crust,
        "surfaceDim": c.crust,
        "surfaceBright": c.surface2,
        "surfaceContainerLowest": c.crust,
        "surfaceContainerLow": c.mantle,
        "surfaceContainer": c.base,
        "surfaceContainerHigh": c.surface0,
        "surfaceContainerHighest": c.surface1,
        "onSurface": c.text,
        "surfaceVariant": c.surface2,
        "onSurfaceVariant": c.subtext0,
        "inverseSurface": c.text,
        "inverseOnSurface": c.base,
        "outline": c.overlay1,
        "outlineVariant": c.surface2,
        "shadow": "#000000",
        "scrim": "#000000",
        "surfaceTint": c.accent,
    }
    for key, role in ACCENTS.items():
        Key = key.capitalize()
        keys.update({
            key: c.pick(role),
            f"on{Key}": c.base,
            f"{key}Container": over(role, 0.35),
            f"on{Key}Container": c.bright,
        })
        if key == "primary":
            keys["inversePrimary"] = over(role, 0.6)
    keys.update({
        "error": c.error,
        "onError": c.base,
        "errorContainer": over("error", 0.35),
        "onErrorContainer": c.bright,
    })
    for key, role in ACCENTS.items():
        Key = key.capitalize()
        keys.update({
            f"{key}Fixed": c.pick(role),
            f"{key}FixedDim": over(role, 0.8),
            f"on{Key}Fixed": c.crust,
            f"on{Key}FixedVariant": over(role, 0.3),
        })
    keys.update({f"term{i}": color for i, color in enumerate(c.ansi)})
    keys.update({
        "rosewater": c.identifier,
        "flamingo": c.identifier,
        "pink": c.hue.pink,
        "mauve": c.accent,
        "red": c.hue.red,
        "maroon": c.parameter,
        "peach": c.hue.orange,
        "yellow": c.hue.yellow,
        "green": c.hue.green,
        "teal": c.hue.teal,
        "sky": c.hue.cyan,
        "sapphire": c.label,
        "blue": c.hue.blue,
        "lavender": c.property,
    })
    for key, role in {"link": "link", "visited": "visited", "negative": "error",
                      "neutral": "warning", "positive": "success"}.items():
        keys[f"k{key}"] = c.pick(role)
        keys[f"k{key}Selection"] = over(role, 0.3)
    keys.update({name: c[name] for name in (
        "text", "subtext1", "subtext0", "overlay2", "overlay1", "overlay0",
        "surface2", "surface1", "surface0", "base", "mantle", "crust")})
    keys.update({
        "success": c.success,
        "onSuccess": c.base,
        "successContainer": over("success", 0.35),
        "onSuccessContainer": c.bright,
    })

    # caelestia reads every line as "<key> <hex>", so no header comment
    lines = (f"{key} {value.lstrip('#').lower()}" for key, value in keys.items())
    return {OUT.format(slug=c.slug, variant=c.variant): "\n".join(lines) + "\n"}
