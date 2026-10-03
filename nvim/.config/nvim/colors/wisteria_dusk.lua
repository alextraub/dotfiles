--  Wisteria Dusk
-- Usage: :colorscheme wisteria_dusk

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.g.colors_name = "wisteria_dusk"

local c = {
  bg       = "#261d22",
  surface  = "#30262c",
  raised   = "#3b3037",
  fg       = "#e7e2e3",
  bright   = "#fffeff",
  muted    = "#beb5b7",
  dim      = "#68666c",
  border   = "#958595",
  accent   = "#b59fc7",
  urgent   = "#8d0808",
  red      = "#c94f5d",
  bred     = "#ed7882",
  green    = "#86d98d",
  bgreen   = "#9ff8a5",
  yellow   = "#d8bd7a",
  byellow  = "#f0d899",
  blue     = "#829ac7",
  bblue    = "#a8bde3",
  magenta  = "#b59fc7",
  bmagenta = "#d2b9e5",
  cyan     = "#7fc7c2",
  bcyan    = "#a2e3dd",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

hi("Normal",       { fg = c.fg, bg = c.bg })
hi("NormalFloat",  { fg = c.fg, bg = c.surface })
hi("FloatBorder",  { fg = c.border, bg = c.surface })
hi("Cursor",       { fg = c.bg, bg = c.bgreen })
hi("CursorLine",   { bg = c.surface })
hi("CursorLineNr", { fg = c.accent, bold = true })
hi("LineNr",       { fg = c.dim })
hi("Visual",       { fg = c.bg, bg = c.accent })
hi("Search",       { fg = c.bg, bg = c.yellow })
hi("IncSearch",    { fg = c.bg, bg = c.bgreen })
hi("MatchParen",   { fg = c.bright, bg = c.raised, bold = true })
hi("Pmenu",        { fg = c.fg, bg = c.surface })
hi("PmenuSel",     { fg = c.bg, bg = c.accent, bold = true })
hi("StatusLine",   { fg = c.fg, bg = c.surface })
hi("StatusLineNC", { fg = c.dim, bg = c.bg })
hi("WinSeparator", { fg = c.raised })
hi("VertSplit",    { fg = c.raised })
hi("Directory",    { fg = c.bblue })
hi("Title",        { fg = c.accent, bold = true })

hi("Comment",      { fg = c.dim, italic = true })
hi("Constant",     { fg = c.yellow })
hi("String",       { fg = c.bgreen })
hi("Character",    { fg = c.green })
hi("Number",       { fg = c.yellow })
hi("Boolean",      { fg = c.byellow })
hi("Identifier",   { fg = c.fg })
hi("Function",     { fg = c.bblue })
hi("Statement",    { fg = c.accent })
hi("Conditional",  { fg = c.accent })
hi("Repeat",       { fg = c.accent })
hi("Label",        { fg = c.bmagenta })
hi("Operator",     { fg = c.cyan })
hi("Keyword",      { fg = c.accent })
hi("Exception",    { fg = c.bred })
hi("PreProc",      { fg = c.bmagenta })
hi("Type",         { fg = c.bcyan })
hi("Special",      { fg = c.cyan })
hi("Delimiter",    { fg = c.muted })
hi("Underlined",   { fg = c.bblue, underline = true })
hi("Error",        { fg = c.bright, bg = c.urgent })
hi("Todo",         { fg = c.bg, bg = c.byellow, bold = true })

hi("DiagnosticError", { fg = c.bred })
hi("DiagnosticWarn",  { fg = c.byellow })
hi("DiagnosticInfo",  { fg = c.bblue })
hi("DiagnosticHint",  { fg = c.bgreen })

hi("DiffAdd",    { fg = c.bgreen, bg = c.surface })
hi("DiffChange", { fg = c.byellow, bg = c.surface })
hi("DiffDelete", { fg = c.bred, bg = c.surface })
hi("DiffText",   { fg = c.bright, bg = c.raised })

-- Common Treesitter groups
hi("@comment",          { link = "Comment" })
hi("@string",           { link = "String" })
hi("@number",           { link = "Number" })
hi("@boolean",          { link = "Boolean" })
hi("@function",         { link = "Function" })
hi("@function.call",    { fg = c.bblue })
hi("@keyword",          { link = "Keyword" })
hi("@keyword.function", { fg = c.accent })
hi("@type",             { link = "Type" })
hi("@variable",         { fg = c.fg })
hi("@variable.parameter", { fg = c.bmagenta })
hi("@property",         { fg = c.cyan })
hi("@operator",         { link = "Operator" })
hi("@punctuation.delimiter", { fg = c.muted })
hi("@tag",              { fg = c.accent })
hi("@tag.attribute",    { fg = c.bcyan })

vim.g.terminal_color_0  = c.bg
vim.g.terminal_color_1  = c.red
vim.g.terminal_color_2  = c.green
vim.g.terminal_color_3  = c.yellow
vim.g.terminal_color_4  = c.blue
vim.g.terminal_color_5  = c.magenta
vim.g.terminal_color_6  = c.cyan
vim.g.terminal_color_7  = c.fg
vim.g.terminal_color_8  = c.dim
vim.g.terminal_color_9  = c.bred
vim.g.terminal_color_10 = c.bgreen
vim.g.terminal_color_11 = c.byellow
vim.g.terminal_color_12 = c.bblue
vim.g.terminal_color_13 = c.bmagenta
vim.g.terminal_color_14 = c.bcyan
vim.g.terminal_color_15 = c.bright
