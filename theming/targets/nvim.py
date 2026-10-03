"""Neovim colorscheme and lualine theme.

Highlight groups follow Catppuccin Mocha's mapping. Every color is resolved
here, so the generated Lua has no runtime dependencies.
"""
import re

from palette import blend as mix

COLORS_OUT = "nvim/.config/nvim/colors/wisteria_dusk.lua"
LUALINE_OUT = "nvim/.config/nvim/lua/lualine/themes/wisteria_dusk.lua"


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
      "FloatBorder":      { "fg": c.lavender, "bg": c.mantle },
      "FloatTitle":       { "fg": c.subtext0, "bg": c.mantle },
      "Cursor":           { "fg": c.base, "bg": c.mint },
      "lCursor":          { "link": "Cursor" },
      "CursorIM":         { "link": "Cursor" },
      "TermCursor":       { "fg": c.base, "bg": c.mint },
      "CursorLine":       { "bg": cursorline },
      "CursorColumn":     { "bg": c.mantle },
      "ColorColumn":      { "bg": c.surface0 },
      "CursorLineNr":     { "fg": c.lavender },
      "LineNr":           { "fg": c.surface2 },
      "SignColumn":       { "fg": c.surface1 },
      "FoldColumn":       { "fg": c.overlay0 },
      "Folded":           { "fg": c.blue, "bg": c.surface0 },
      "Conceal":          { "fg": c.overlay1 },
      "NonText":          { "fg": c.overlay0 },
      "EndOfBuffer":      { "fg": c.surface1 },
      "Whitespace":       { "fg": c.surface1 },
      "SpecialKey":       { "link": "NonText" },
      "Visual":           { "bg": c.surface1, "bold": True },
      "VisualNOS":        { "link": "Visual" },
      "Search":           { "fg": c.text, "bg": blend(c.sky, 0.30) },
      "IncSearch":        { "fg": c.mantle, "bg": blend(c.sky, 0.90) },
      "CurSearch":        { "fg": c.mantle, "bg": c.maroon },
      "Substitute":       { "fg": c.pink, "bg": c.surface1 },
      "MatchParen":       { "fg": c.peach, "bg": blend(c.surface1, 0.70), "bold": True },
      "Pmenu":            { "fg": c.overlay2, "bg": c.mantle },
      "PmenuSel":         { "bg": c.surface0, "bold": True },
      "PmenuMatch":       { "fg": c.text, "bold": True },
      "PmenuMatchSel":    { "bold": True },
      "PmenuKind":        { "fg": c.blue, "bg": c.mantle },
      "PmenuKindSel":     { "fg": c.blue, "bg": c.surface0, "bold": True },
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
      "WinBar":           { "fg": c.flamingo },
      "WinBarNC":         { "link": "WinBar" },
      "WinSeparator":     { "fg": c.surface1 },
      "VertSplit":        { "link": "WinSeparator" },
      "Directory":        { "fg": c.blue },
      "Title":            { "fg": c.blue, "bold": True },
      "ModeMsg":          { "fg": c.text, "bold": True },
      "MoreMsg":          { "fg": c.blue },
      "Question":         { "fg": c.blue },
      "ErrorMsg":         { "fg": c.red, "bold": True, "italic": True },
      "WarningMsg":       { "fg": c.yellow },
      "OkMsg":            { "fg": c.green },
      "QuickFixLine":     { "bg": blend(c.surface1, 0.70), "bold": True },
      "SpellBad":         { "sp": c.red, "undercurl": True },
      "SpellCap":         { "sp": c.yellow, "undercurl": True },
      "SpellLocal":       { "sp": c.blue, "undercurl": True },
      "SpellRare":        { "sp": c.green, "undercurl": True },
        },
        "Syntax": {
      "Comment":          { "fg": c.overlay2, "italic": True },
      "SpecialComment":   { "link": "Special" },
      "Constant":         { "fg": c.peach },
      "String":           { "fg": c.green },
      "Character":        { "fg": c.teal },
      "Number":           { "fg": c.peach },
      "Float":            { "link": "Number" },
      "Boolean":          { "fg": c.peach },
      "Identifier":       { "fg": c.flamingo },
      "Function":         { "fg": c.blue },
      "Statement":        { "fg": c.lavender },
      "Conditional":      { "fg": c.lavender },
      "Repeat":           { "fg": c.lavender },
      "Label":            { "fg": c.sapphire },
      "Operator":         { "fg": c.sky },
      "Keyword":          { "fg": c.lavender },
      "Exception":        { "fg": c.lavender },
      "PreProc":          { "fg": c.pink },
      "Include":          { "fg": c.lavender },
      "Define":           { "link": "PreProc" },
      "Macro":            { "fg": c.lavender },
      "PreCondit":        { "link": "PreProc" },
      "Type":             { "fg": c.yellow },
      "StorageClass":     { "fg": c.yellow },
      "Structure":        { "fg": c.yellow },
      "Typedef":          { "link": "Type" },
      "Special":          { "fg": c.pink },
      "SpecialChar":      { "link": "Special" },
      "Tag":              { "fg": c.lilac, "bold": True },
      "Delimiter":        { "fg": c.overlay2 },
      "Debug":            { "link": "Special" },
      "Underlined":       { "underline": True },
      "Bold":             { "bold": True },
      "Italic":           { "italic": True },
      "Error":            { "fg": c.red },
      "Todo":             { "fg": c.base, "bg": c.flamingo, "bold": True },
        },
        # Diffs use tinted backgrounds so the text keeps its syntax color.
        "Diffs": {
      "Added":            { "fg": c.green },
      "Changed":          { "fg": c.blue },
      "Removed":          { "fg": c.red },
      "DiffAdd":          { "bg": blend(c.green, 0.18) },
      "DiffChange":       { "bg": blend(c.blue, 0.07) },
      "DiffDelete":       { "bg": blend(c.red, 0.18) },
      "DiffText":         { "bg": blend(c.blue, 0.30) },
      "diffAdded":        { "fg": c.green },
      "diffRemoved":      { "fg": c.red },
      "diffChanged":      { "fg": c.blue },
      "diffOldFile":      { "fg": c.yellow },
      "diffNewFile":      { "fg": c.peach },
      "diffFile":         { "fg": c.blue },
      "diffLine":         { "fg": c.overlay0 },
      "diffIndexLine":    { "fg": c.teal },
        },
        "Diagnostics": {
      "DiagnosticError":            { "fg": c.red },
      "DiagnosticWarn":             { "fg": c.yellow },
      "DiagnosticInfo":             { "fg": c.sky },
      "DiagnosticHint":             { "fg": c.teal },
      "DiagnosticOk":               { "fg": c.green },
      "DiagnosticVirtualTextError": { "fg": c.red, "bg": blend(c.red, 0.095) },
      "DiagnosticVirtualTextWarn":  { "fg": c.yellow, "bg": blend(c.yellow, 0.095) },
      "DiagnosticVirtualTextInfo":  { "fg": c.sky, "bg": blend(c.sky, 0.095) },
      "DiagnosticVirtualTextHint":  { "fg": c.teal, "bg": blend(c.teal, 0.095) },
      "DiagnosticVirtualTextOk":    { "fg": c.green, "bg": blend(c.green, 0.095) },
      "DiagnosticUnderlineError":   { "sp": c.red, "undercurl": True },
      "DiagnosticUnderlineWarn":    { "sp": c.yellow, "undercurl": True },
      "DiagnosticUnderlineInfo":    { "sp": c.sky, "undercurl": True },
      "DiagnosticUnderlineHint":    { "sp": c.teal, "undercurl": True },
      "DiagnosticUnderlineOk":      { "sp": c.green, "undercurl": True },
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
      "@variable.builtin":            { "fg": c.red },
      "@variable.parameter":          { "fg": c.maroon, "italic": True },
      "@variable.parameter.builtin":  { "fg": c.red, "italic": True },
      "@variable.member":             { "fg": c.lilac },
      "@constant":                    { "link": "Constant" },
      "@constant.builtin":            { "fg": c.peach },
      "@constant.macro":              { "link": "Macro" },
      "@module":                      { "fg": c.ochre, "italic": True },
      "@label":                       { "link": "Label" },
      "@string":                      { "link": "String" },
      "@string.documentation":        { "fg": c.teal },
      "@string.regexp":               { "fg": c.pink },
      "@string.escape":               { "fg": c.pink },
      "@string.special":              { "link": "Special" },
      "@string.special.symbol":       { "fg": c.flamingo },
      "@string.special.url":          { "fg": c.blue, "italic": True, "underline": True },
      "@character":                   { "link": "Character" },
      "@character.special":           { "link": "SpecialChar" },
      "@boolean":                     { "link": "Boolean" },
      "@number":                      { "link": "Number" },
      "@number.float":                { "link": "Float" },
      "@type":                        { "link": "Type" },
      "@type.builtin":                { "fg": c.lavender },
      "@type.definition":             { "link": "Type" },
      "@attribute":                   { "link": "Constant" },
      "@property":                    { "fg": c.lilac },
      "@function":                    { "link": "Function" },
      "@function.builtin":            { "fg": c.peach },
      "@function.call":               { "link": "Function" },
      "@function.macro":              { "fg": c.pink },
      "@function.method":             { "link": "Function" },
      "@function.method.call":        { "link": "Function" },
      "@constructor":                 { "fg": c.yellow },
      "@operator":                    { "link": "Operator" },
      "@keyword":                     { "link": "Keyword" },
      "@keyword.function":            { "fg": c.lavender },
      "@keyword.operator":            { "fg": c.lavender },
      "@keyword.return":              { "fg": c.lavender },
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
      "@comment.error":               { "fg": c.base, "bg": c.red },
      "@comment.warning":             { "fg": c.base, "bg": c.yellow },
      "@comment.hint":                { "fg": c.base, "bg": c.blue },
      "@comment.note":                { "fg": c.base, "bg": c.blue },
      "@comment.todo":                { "fg": c.base, "bg": c.flamingo },
      "@markup":                      { "fg": c.text },
      "@markup.strong":               { "fg": c.maroon, "bold": True },
      "@markup.italic":               { "fg": c.maroon, "italic": True },
      "@markup.strikethrough":        { "strikethrough": True },
      "@markup.underline":            { "link": "Underlined" },
      "@markup.heading":              { "fg": c.blue, "bold": True },
      "@markup.heading.1":            { "fg": c.red, "bold": True },
      "@markup.heading.2":            { "fg": c.peach, "bold": True },
      "@markup.heading.3":            { "fg": c.yellow, "bold": True },
      "@markup.heading.4":            { "fg": c.green, "bold": True },
      "@markup.heading.5":            { "fg": c.sapphire, "bold": True },
      "@markup.heading.6":            { "fg": c.lilac, "bold": True },
      "@markup.math":                 { "fg": c.blue },
      "@markup.quote":                { "fg": c.pink },
      "@markup.link":                 { "fg": c.lilac },
      "@markup.link.label":           { "fg": c.lilac },
      "@markup.link.url":             { "fg": c.blue, "italic": True, "underline": True },
      "@markup.raw":                  { "fg": c.green },
      "@markup.list":                 { "fg": c.teal },
      "@markup.list.checked":         { "fg": c.green },
      "@markup.list.unchecked":       { "fg": c.overlay1 },
      "@diff.plus":                   { "link": "diffAdded" },
      "@diff.minus":                  { "link": "diffRemoved" },
      "@diff.delta":                  { "link": "diffChanged" },
      "@tag":                         { "fg": c.blue },
      "@tag.builtin":                 { "fg": c.blue },
      "@tag.attribute":               { "fg": c.ochre, "italic": True },
      "@tag.delimiter":               { "fg": c.teal },
      "@property.css":                { "fg": c.blue },
      "@type.css":                    { "fg": c.lilac },
      "@constructor.lua":             { "link": "@punctuation.bracket" },
        },
        "LSP semantic tokens": {
      "@lsp.type.enumMember":                 { "fg": c.teal },
      "@lsp.type.variable":                   {},
      "@lsp.type.namespace":                  { "link": "@module" },
      "@lsp.type.typeParameter":              { "fg": c.maroon, "italic": True },
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
      "TelescopeSelection":       { "fg": c.flamingo, "bg": c.surface0, "bold": True },
      "TelescopeSelectionCaret":  { "fg": c.flamingo, "bg": c.surface0 },
      "TelescopeMatching":        { "fg": c.blue },
      "TelescopePromptPrefix":    { "fg": c.flamingo },
        },
        "Harpoon": {
      "HarpoonWindow":            { "fg": c.text, "bg": c.base },
      "HarpoonBorder":            { "fg": c.blue },
        },
        "Mason": {
      "MasonHeader":                      { "fg": c.base, "bg": c.lavender, "bold": True },
      "MasonHeaderSecondary":             { "fg": c.base, "bg": c.blue, "bold": True },
      "MasonHighlight":                   { "fg": c.green },
      "MasonHighlightBlock":              { "fg": c.base, "bg": c.green },
      "MasonHighlightBlockBold":          { "fg": c.base, "bg": c.blue, "bold": True },
      "MasonHighlightSecondary":          { "fg": c.lavender },
      "MasonHighlightBlockSecondary":     { "fg": c.base, "bg": c.blue },
      "MasonHighlightBlockBoldSecondary": { "fg": c.base, "bg": c.lavender, "bold": True },
      "MasonMuted":                       { "fg": c.overlay0 },
      "MasonMutedBlock":                  { "fg": c.base, "bg": c.overlay0 },
      "MasonMutedBlockBold":              { "fg": c.base, "bg": c.yellow, "bold": True },
      "MasonError":                       { "fg": c.red },
      "MasonHeading":                     { "fg": c.lilac, "bold": True },
        },
        "Gitsigns": {
      "GitSignsAdd":              { "fg": c.green },
      "GitSignsChange":           { "fg": c.ochre },
      "GitSignsDelete":           { "fg": c.red },
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
        "normal": mode(c.lavender),
        "insert": mode(c.green),
        "terminal": mode(c.green),
        "command": mode(c.peach),
        "visual": mode(c.blue),
        "replace": mode(c.red),
        "inactive": {
            "a": {"bg": c.mantle, "fg": c.lavender},
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
-- Generated by theming/generate.py from theming/palette.json.
-- Edit those, not this file.
"""


def build(c):
    out = [
        HEADER.format(name=c.name) + "-- Usage: :colorscheme wisteria_dusk",
        "",
        'vim.cmd("highlight clear")',
        'if vim.fn.exists("syntax_on") == 1 then',
        '  vim.cmd("syntax reset")',
        "end",
        "",
        'vim.o.background = "dark"',
        'vim.g.colors_name = "wisteria_dusk"',
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

    line = HEADER.format(name=c.name + " lualine theme")
    line += "-- lualine's \"auto\" theme loads this whenever the colorscheme is wisteria_dusk.\n"
    line += "return {\n"
    for mode, parts in lualine(c).items():
        line += f"  {mode} = {{\n"
        line += "".join(f"    {p} = {lua(v)},\n" for p, v in parts.items())
        line += "  },\n"
    line += "}\n"

    return {COLORS_OUT: "\n".join(out) + "\n", LUALINE_OUT: line}
