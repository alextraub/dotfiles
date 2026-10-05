"""Neovim colorscheme and lualine theme.

Highlight groups follow Catppuccin Mocha's mapping. Every color is resolved
here, so the generated Lua has no runtime dependencies.
"""
import re

from palette import blend as mix

COLORS_OUT = "nvim/.config/nvim/colors/{}.lua"
LUALINE_OUT = "nvim/.config/nvim/lua/lualine/themes/{}.lua"


def groups(c):
    def blend(fg, amount):
        return mix(fg, amount, c.base)

    cursorline = blend(c.surface0, 0.64)

    return {
        "Editor": {
      "Normal":           { "fg": c.text, "bg": c.base },
      "NormalNC":         { "fg": c.text, "bg": c.base },
      "NormalSB":         { "fg": c.text, "bg": c.crust },
      "NormalFloat":      { "fg": c.text, "bg": c.mantle },
      "FloatBorder":      { "fg": c.accent, "bg": c.mantle },
      "FloatTitle":       { "fg": c.subtext0, "bg": c.mantle },
      "Cursor":           { "fg": c.base, "bg": c.marker },
      "lCursor":          { "link": "Cursor" },
      "CursorIM":         { "link": "Cursor" },
      "TermCursor":       { "fg": c.base, "bg": c.marker },
      "CursorLine":       { "bg": cursorline },
      "CursorColumn":     { "bg": c.mantle },
      "ColorColumn":      { "bg": c.surface0 },
      "CursorLineNr":     { "fg": c.marker },
      "LineNr":           { "fg": c.surface2 },
      "SignColumn":       { "fg": c.surface1 },
      "FoldColumn":       { "fg": c.overlay0 },
      "Folded":           { "fg": c.secondary, "bg": c.surface0 },
      "Conceal":          { "fg": c.overlay1 },
      "NonText":          { "fg": c.overlay0 },
      "EndOfBuffer":      { "fg": c.surface1 },
      "Whitespace":       { "fg": c.surface1 },
      "SpecialKey":       { "link": "NonText" },
      "Visual":           { "bg": c.surface1, "bold": True },
      "VisualNOS":        { "link": "Visual" },
      "Search":           { "fg": c.text, "bg": blend(c.search, 0.30) },
      "IncSearch":        { "fg": c.mantle, "bg": blend(c.search, 0.90) },
      "CurSearch":        { "fg": c.mantle, "bg": c.parameter },
      "Substitute":       { "fg": c.special, "bg": c.surface1 },
      "MatchParen":       { "fg": c.hue.orange, "bg": blend(c.surface1, 0.70), "bold": True },
      "Pmenu":            { "fg": c.overlay2, "bg": c.mantle },
      "PmenuSel":         { "bg": c.surface0, "bold": True },
      "PmenuMatch":       { "fg": c.text, "bold": True },
      "PmenuMatchSel":    { "bold": True },
      "PmenuKind":        { "fg": c.function, "bg": c.mantle },
      "PmenuKindSel":     { "fg": c.function, "bg": c.surface0, "bold": True },
      "PmenuExtra":       { "fg": c.overlay0 },
      "PmenuExtraSel":    { "fg": c.overlay0, "bg": c.surface0, "bold": True },
      "PmenuSbar":        { "bg": c.surface0 },
      "PmenuThumb":       { "bg": c.overlay0 },
      "WildMenu":         { "bg": c.overlay0 },
      "StatusLine":       { "fg": c.text, "bg": c.mantle },
      "StatusLineNC":     { "fg": c.surface2, "bg": c.mantle },
      "TabLine":          { "fg": c.overlay0, "bg": c.crust },
      "TabLineFill":      { "bg": c.mantle },
      "TabLineSel":       { "fg": c.text, "bg": c.base },
      "WinBar":           { "fg": c.identifier },
      "WinBarNC":         { "link": "WinBar" },
      "WinSeparator":     { "fg": c.surface1 },
      "VertSplit":        { "link": "WinSeparator" },
      "Directory":        { "fg": c.secondary },
      "Title":            { "fg": c.secondary, "bold": True },
      "ModeMsg":          { "fg": c.text, "bold": True },
      "MoreMsg":          { "fg": c.secondary },
      "Question":         { "fg": c.secondary },
      "ErrorMsg":         { "fg": c.error, "bold": True, "italic": True },
      "WarningMsg":       { "fg": c.warning },
      "OkMsg":            { "fg": c.success },
      "QuickFixLine":     { "bg": blend(c.surface1, 0.70), "bold": True },
      "SpellBad":         { "sp": c.error, "undercurl": True },
      "SpellCap":         { "sp": c.warning, "undercurl": True },
      "SpellLocal":       { "sp": c.secondary, "undercurl": True },
      "SpellRare":        { "sp": c.hue.green, "undercurl": True },
        },
        "Syntax": {
      "Comment":          { "fg": c.overlay2, "italic": True },
      "SpecialComment":   { "link": "Special" },
      "Constant":         { "fg": c.constant },
      "String":           { "fg": c.string },
      "Character":        { "fg": c.character },
      "Number":           { "fg": c.constant },
      "Float":            { "link": "Number" },
      "Boolean":          { "fg": c.constant },
      "Identifier":       { "fg": c.identifier },
      "Function":         { "fg": c.function },
      "Statement":        { "fg": c.keyword },
      "Conditional":      { "fg": c.keyword },
      "Repeat":           { "fg": c.keyword },
      "Label":            { "fg": c.label },
      "Operator":         { "fg": c.operator },
      "Keyword":          { "fg": c.keyword },
      "Exception":        { "fg": c.keyword },
      "PreProc":          { "fg": c.special },
      "Include":          { "fg": c.keyword },
      "Define":           { "link": "PreProc" },
      "Macro":            { "fg": c.keyword },
      "PreCondit":        { "link": "PreProc" },
      "Type":             { "fg": c.type },
      "StorageClass":     { "fg": c.type },
      "Structure":        { "fg": c.type },
      "Typedef":          { "link": "Type" },
      "Special":          { "fg": c.special },
      "SpecialChar":      { "link": "Special" },
      "Tag":              { "fg": c.property, "bold": True },
      "Delimiter":        { "fg": c.overlay2 },
      "Debug":            { "link": "Special" },
      "Underlined":       { "underline": True },
      "Bold":             { "bold": True },
      "Italic":           { "italic": True },
      "Error":            { "fg": c.error },
      "Todo":             { "fg": c.base, "bg": c.identifier, "bold": True },
        },
        # Diffs use tinted backgrounds so the text keeps its syntax color.
        "Diffs": {
      "Added":            { "fg": c.added },
      "Changed":          { "fg": c.changed },
      "Removed":          { "fg": c.removed },
      "DiffAdd":          { "bg": blend(c.added, 0.18) },
      "DiffChange":       { "bg": blend(c.changed, 0.07) },
      "DiffDelete":       { "bg": blend(c.removed, 0.18) },
      "DiffText":         { "bg": blend(c.changed, 0.30) },
      "diffAdded":        { "fg": c.added },
      "diffRemoved":      { "fg": c.removed },
      "diffChanged":      { "fg": c.changed },
      "diffOldFile":      { "fg": c.hue.yellow },
      "diffNewFile":      { "fg": c.hue.orange },
      "diffFile":         { "fg": c.secondary },
      "diffLine":         { "fg": c.overlay0 },
      "diffIndexLine":    { "fg": c.hue.teal },
        },
        "Diagnostics": {
      "DiagnosticError":            { "fg": c.error },
      "DiagnosticWarn":             { "fg": c.warning },
      "DiagnosticInfo":             { "fg": c.info },
      "DiagnosticHint":             { "fg": c.hint },
      "DiagnosticOk":               { "fg": c.success },
      "DiagnosticVirtualTextError": { "fg": c.error, "bg": blend(c.error, 0.095) },
      "DiagnosticVirtualTextWarn":  { "fg": c.warning, "bg": blend(c.warning, 0.095) },
      "DiagnosticVirtualTextInfo":  { "fg": c.info, "bg": blend(c.info, 0.095) },
      "DiagnosticVirtualTextHint":  { "fg": c.hint, "bg": blend(c.hint, 0.095) },
      "DiagnosticVirtualTextOk":    { "fg": c.success, "bg": blend(c.success, 0.095) },
      "DiagnosticUnderlineError":   { "sp": c.error, "undercurl": True },
      "DiagnosticUnderlineWarn":    { "sp": c.warning, "undercurl": True },
      "DiagnosticUnderlineInfo":    { "sp": c.info, "undercurl": True },
      "DiagnosticUnderlineHint":    { "sp": c.hint, "undercurl": True },
      "DiagnosticUnderlineOk":      { "sp": c.success, "undercurl": True },
      "DiagnosticUnnecessary":      { "fg": c.overlay1 },
      "DiagnosticDeprecated":       { "sp": c.overlay1, "strikethrough": True },
        },
        "LSP": {
      "LspReferenceText":            { "bg": c.surface1 },
      "LspReferenceRead":            { "bg": c.surface1 },
      "LspReferenceWrite":           { "bg": c.surface1 },
      "LspSignatureActiveParameter": { "bg": c.surface0, "bold": True },
      "LspCodeLens":                 { "fg": c.overlay0 },
      "LspCodeLensSeparator":        { "link": "LspCodeLens" },
      "LspInlayHint":                { "fg": c.overlay0, "bg": cursorline },
      "LspInfoBorder":               { "link": "FloatBorder" },
        },
        "Treesitter": {
      "@variable":                    { "fg": c.text },
      "@variable.builtin":            { "fg": c.builtin },
      "@variable.parameter":          { "fg": c.parameter, "italic": True },
      "@variable.parameter.builtin":  { "fg": c.builtin, "italic": True },
      "@variable.member":             { "fg": c.property },
      "@constant":                    { "link": "Constant" },
      "@constant.builtin":            { "fg": c.constant },
      "@constant.macro":              { "link": "Macro" },
      "@module":                      { "fg": c.module, "italic": True },
      "@label":                       { "link": "Label" },
      "@string":                      { "link": "String" },
      "@string.documentation":        { "fg": c.character },
      "@string.regexp":               { "fg": c.special },
      "@string.escape":               { "fg": c.special },
      "@string.special":              { "link": "Special" },
      "@string.special.symbol":       { "fg": c.identifier },
      "@string.special.url":          { "fg": c.link, "italic": True, "underline": True },
      "@character":                   { "link": "Character" },
      "@character.special":           { "link": "SpecialChar" },
      "@boolean":                     { "link": "Boolean" },
      "@number":                      { "link": "Number" },
      "@number.float":                { "link": "Float" },
      "@type":                        { "link": "Type" },
      "@type.builtin":                { "fg": c.keyword },
      "@type.definition":             { "link": "Type" },
      "@attribute":                   { "link": "Constant" },
      "@property":                    { "fg": c.property },
      "@function":                    { "link": "Function" },
      "@function.builtin":            { "fg": c.constant },
      "@function.call":               { "link": "Function" },
      "@function.macro":              { "fg": c.special },
      "@function.method":             { "link": "Function" },
      "@function.method.call":        { "link": "Function" },
      "@constructor":                 { "fg": c.type },
      "@operator":                    { "link": "Operator" },
      "@keyword":                     { "link": "Keyword" },
      "@keyword.function":            { "fg": c.keyword },
      "@keyword.operator":            { "fg": c.keyword },
      "@keyword.return":              { "fg": c.keyword },
      "@keyword.import":              { "link": "Include" },
      "@keyword.repeat":              { "link": "Repeat" },
      "@keyword.exception":           { "link": "Exception" },
      "@keyword.conditional":         { "link": "Conditional" },
      "@keyword.conditional.ternary": { "link": "Operator" },
      "@keyword.directive":           { "link": "PreProc" },
      "@punctuation.delimiter":       { "link": "Delimiter" },
      "@punctuation.bracket":         { "fg": c.overlay2 },
      "@punctuation.special":         { "link": "Special" },
      "@comment":                     { "link": "Comment" },
      "@comment.error":               { "fg": c.base, "bg": c.error },
      "@comment.warning":             { "fg": c.base, "bg": c.warning },
      "@comment.hint":                { "fg": c.base, "bg": c.secondary },
      "@comment.note":                { "fg": c.base, "bg": c.secondary },
      "@comment.todo":                { "fg": c.base, "bg": c.identifier },
      "@markup":                      { "fg": c.text },
      "@markup.strong":               { "fg": c.parameter, "bold": True },
      "@markup.italic":               { "fg": c.parameter, "italic": True },
      "@markup.strikethrough":        { "strikethrough": True },
      "@markup.underline":            { "link": "Underlined" },
      "@markup.heading":              { "fg": c.secondary, "bold": True },
      "@markup.heading.1":            { "fg": c.hue.red, "bold": True },
      "@markup.heading.2":            { "fg": c.hue.orange, "bold": True },
      "@markup.heading.3":            { "fg": c.hue.yellow, "bold": True },
      "@markup.heading.4":            { "fg": c.hue.green, "bold": True },
      "@markup.heading.5":            { "fg": c.label, "bold": True },
      "@markup.heading.6":            { "fg": c.property, "bold": True },
      "@markup.math":                 { "fg": c.function },
      "@markup.quote":                { "fg": c.special },
      "@markup.link":                 { "fg": c.property },
      "@markup.link.label":           { "fg": c.property },
      "@markup.link.url":             { "fg": c.link, "italic": True, "underline": True },
      "@markup.raw":                  { "fg": c.string },
      "@markup.list":                 { "fg": c.character },
      "@markup.list.checked":         { "fg": c.success },
      "@markup.list.unchecked":       { "fg": c.overlay1 },
      "@diff.plus":                   { "link": "diffAdded" },
      "@diff.minus":                  { "link": "diffRemoved" },
      "@diff.delta":                  { "link": "diffChanged" },
      "@tag":                         { "fg": c.function },
      "@tag.builtin":                 { "fg": c.function },
      "@tag.attribute":               { "fg": c.module, "italic": True },
      "@tag.delimiter":               { "fg": c.character },
      "@property.css":                { "fg": c.function },
      "@type.css":                    { "fg": c.property },
      "@constructor.lua":             { "link": "@punctuation.bracket" },
        },
        "LSP semantic tokens": {
      "@lsp.type.enumMember":                 { "fg": c.character },
      "@lsp.type.variable":                   {},
      "@lsp.type.namespace":                  { "link": "@module" },
      "@lsp.type.typeParameter":              { "fg": c.parameter, "italic": True },
      "@lsp.type.macro":                      { "link": "@function.macro" },
      "@lsp.type.decorator":                  { "link": "@attribute" },
      "@lsp.mod.deprecated":                  { "strikethrough": True },
      "@lsp.typemod.function.defaultLibrary": { "link": "@function.builtin" },
      "@lsp.typemod.method.defaultLibrary":   { "link": "@function.builtin" },
      "@lsp.typemod.variable.defaultLibrary": { "link": "@variable.builtin" },
        },
        "Telescope": {
      "TelescopeNormal":          { "link": "NormalFloat" },
      "TelescopeBorder":          { "link": "FloatBorder" },
      "TelescopeTitle":           { "link": "FloatTitle" },
      "TelescopeSelection":       { "fg": c.identifier, "bg": c.surface0, "bold": True },
      "TelescopeSelectionCaret":  { "fg": c.identifier, "bg": c.surface0 },
      "TelescopeMatching":        { "fg": c.secondary },
      "TelescopePromptPrefix":    { "fg": c.identifier },
        },
        "Harpoon": {
      "HarpoonWindow":            { "fg": c.text, "bg": c.base },
      "HarpoonBorder":            { "fg": c.secondary },
        },
        "Mason": {
      "MasonHeader":                      { "fg": c.base, "bg": c.accent, "bold": True },
      "MasonHeaderSecondary":             { "fg": c.base, "bg": c.secondary, "bold": True },
      "MasonHighlight":                   { "fg": c.success },
      "MasonHighlightBlock":              { "fg": c.base, "bg": c.success },
      "MasonHighlightBlockBold":          { "fg": c.base, "bg": c.secondary, "bold": True },
      "MasonHighlightSecondary":          { "fg": c.accent },
      "MasonHighlightBlockSecondary":     { "fg": c.base, "bg": c.secondary },
      "MasonHighlightBlockBoldSecondary": { "fg": c.base, "bg": c.accent, "bold": True },
      "MasonMuted":                       { "fg": c.overlay0 },
      "MasonMutedBlock":                  { "fg": c.base, "bg": c.overlay0 },
      "MasonMutedBlockBold":              { "fg": c.base, "bg": c.warning, "bold": True },
      "MasonError":                       { "fg": c.error },
      "MasonHeading":                     { "fg": c.property, "bold": True },
        },
        "Gitsigns": {
      "GitSignsAdd":              { "fg": c.added },
      "GitSignsChange":           { "fg": c.modified },
      "GitSignsDelete":           { "fg": c.removed },
        },
    }


def lualine(c):
    def mode(color):
        return {
            "a": {"bg": color, "fg": c.mantle, "gui": "bold"},
            "b": {"bg": c.surface0, "fg": color},
            "c": {"bg": c.mantle, "fg": c.text},
        }

    return {
        "normal": mode(c.accent),
        "insert": mode(c.marker),
        "terminal": mode(c.marker),
        "command": mode(c.hue.orange),
        "visual": mode(c.secondary),
        "replace": mode(c.hue.red),
        "inactive": {
            "a": {"bg": c.mantle, "fg": c.accent},
            "b": {"bg": c.mantle, "fg": c.surface2, "gui": "bold"},
            "c": {"bg": c.mantle, "fg": c.overlay0},
        },
    }


def lua(value):
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, str):
        return f'"{value}"'
    if not value:
        return "{}"
    return "{ " + ", ".join(f"{key(k)} = {lua(v)}" for k, v in value.items()) + " }"


def key(name):
    return name if re.fullmatch(r"[A-Za-z_]\w*", name) else f'["{name}"]'


HEADER = """-- {name}
-- Generated by theming/generate.py from {source}.
-- Edit those, not this file.
"""


def build(c):
    out = [
        HEADER.format(name=c.name, source=c.source) + f"-- Usage: :colorscheme {c.snake}",
        "",
        'vim.cmd("highlight clear")',
        'if vim.fn.exists("syntax_on") == 1 then',
        '  vim.cmd("syntax reset")',
        "end",
        "",
        f'vim.o.background = "{c.variant}"',
        f'vim.g.colors_name = "{c.snake}"',
        "",
        "local groups = {",
    ]
    for section, entries in groups(c).items():
        out.append(f"  -- {section}")
        width = max(len(key(g)) for g in entries)
        out += [f"  {key(g):<{width}} = {lua(opts)}," for g, opts in entries.items()]
        out.append("")
    out[-1] = "}"
    out += [
        "",
        "for group, opts in pairs(groups) do",
        "  vim.api.nvim_set_hl(0, group, opts)",
        "end",
        "",
    ]
    out += [f'vim.g.terminal_color_{i:<2} = "{color}"' for i, color in enumerate(c.ansi)]

    line = HEADER.format(name=c.name + " lualine theme", source=c.source)
    line += f"-- lualine's \"auto\" theme loads this whenever the colorscheme is {c.snake}.\n"
    line += "return {\n"
    for mode, parts in lualine(c).items():
        line += f"  {mode} = {{\n"
        line += "".join(f"    {p} = {lua(v)},\n" for p, v in parts.items())
        line += "  },\n"
    line += "}\n"

    return {COLORS_OUT.format(c.snake): "\n".join(out) + "\n", LUALINE_OUT.format(c.snake): line}
