-- Pure monochrome colorscheme, hand-rolled to match the ghostty studio1804 ramp.
-- No hue anywhere: tokens differ by brightness + italic/bold only. Transparent bg
-- so ghostty's blur shows through (bg = NONE everywhere except subtle UI fills).

local M = {}

-- grey ramp (mirrors ghostty palette: 000 / 404040 / 808080 / a0a0a0 / d0d0d0 / f0f0f0 / fff)
local c = {
  none = "NONE",
  fg = "#e8e8e8",
  black = "#000000",
  g1 = "#141414", -- subtle fill (pmenu/cursorline)
  g2 = "#1a1a1a",
  g3 = "#2a2a2a", -- borders / separators
  g4 = "#3a3a3a", -- visual selection
  g5 = "#4a4a4a",
  g6 = "#606060", -- comments / linenr-dim
  g7 = "#808080", -- punctuation / muted
  g8 = "#a0a0a0", -- operator / string-ish
  g9 = "#c0c0c0", -- constants
  g10 = "#d0d0d0", -- variables
  g11 = "#e0e0e0", -- types
  g12 = "#f2f2f2", -- functions
  white = "#ffffff",
}

function M.setup()
  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "mono"

  local set = vim.api.nvim_set_hl
  local function hl(group, opts)
    set(0, group, opts)
  end

  -- editor chrome (transparent)
  hl("Normal", { fg = c.fg, bg = c.none })
  hl("NormalNC", { fg = c.fg, bg = c.none })
  hl("NormalFloat", { fg = c.fg, bg = c.none })
  hl("FloatBorder", { fg = c.g5, bg = c.none })
  hl("FloatTitle", { fg = c.white, bg = c.none, bold = true })
  hl("EndOfBuffer", { fg = c.g2 })
  hl("SignColumn", { bg = c.none })
  hl("LineNr", { fg = c.g5 })
  hl("CursorLineNr", { fg = c.g11, bold = true })
  hl("CursorLine", { bg = c.g1 })
  hl("CursorColumn", { bg = c.g1 })
  hl("ColorColumn", { bg = c.g1 })
  hl("Cursor", { fg = c.black, bg = c.white })
  hl("Visual", { bg = c.g4 })
  hl("VisualNOS", { bg = c.g4 })
  hl("Search", { fg = c.white, bg = c.g5 })
  hl("IncSearch", { fg = c.black, bg = c.white })
  hl("CurSearch", { fg = c.black, bg = c.white })
  hl("MatchParen", { fg = c.white, bold = true, underline = true })
  hl("WinSeparator", { fg = c.g3, bg = c.none })
  hl("VertSplit", { fg = c.g3, bg = c.none })
  hl("Folded", { fg = c.g7, bg = c.g1 })
  hl("FoldColumn", { fg = c.g5, bg = c.none })
  hl("NonText", { fg = c.g3 })
  hl("Whitespace", { fg = c.g3 })
  hl("SpecialKey", { fg = c.g4 })
  hl("Directory", { fg = c.g11 })
  hl("Title", { fg = c.white, bold = true })
  hl("Conceal", { fg = c.g6 })
  hl("QuickFixLine", { bg = c.g2 })
  hl("WinBar", { fg = c.g8, bg = c.none })
  hl("WinBarNC", { fg = c.g6, bg = c.none })

  -- statusline / tabline / popup
  hl("StatusLine", { fg = c.g8, bg = c.none })
  hl("StatusLineNC", { fg = c.g6, bg = c.none })
  hl("TabLine", { fg = c.g6, bg = c.none })
  hl("TabLineFill", { bg = c.none })
  hl("TabLineSel", { fg = c.white, bg = c.none, bold = true })
  hl("Pmenu", { fg = c.g9, bg = c.g1 })
  hl("PmenuSel", { fg = c.white, bg = c.g3, bold = true })
  hl("PmenuSbar", { bg = c.g2 })
  hl("PmenuThumb", { bg = c.g5 })
  hl("WildMenu", { fg = c.white, bg = c.g3 })
  hl("MsgArea", { fg = c.fg })
  hl("ModeMsg", { fg = c.g9, bold = true })
  hl("MoreMsg", { fg = c.g9 })
  hl("Question", { fg = c.g10 })
  hl("ErrorMsg", { fg = c.white, bold = true })
  hl("WarningMsg", { fg = c.g10 })

  -- syntax (brightness-coded, no hue)
  hl("Comment", { fg = c.g6, italic = true })
  hl("Constant", { fg = c.g9 })
  hl("String", { fg = c.g8 })
  hl("Character", { fg = c.g8 })
  hl("Number", { fg = c.g9 })
  hl("Boolean", { fg = c.g9 })
  hl("Float", { fg = c.g9 })
  hl("Identifier", { fg = c.g10 })
  hl("Function", { fg = c.g12, bold = true })
  hl("Statement", { fg = c.white, italic = true })
  hl("Conditional", { fg = c.white, italic = true })
  hl("Repeat", { fg = c.white, italic = true })
  hl("Label", { fg = c.g10 })
  hl("Operator", { fg = c.g8 })
  hl("Keyword", { fg = c.white, italic = true })
  hl("Exception", { fg = c.white, italic = true })
  hl("PreProc", { fg = c.g10 })
  hl("Include", { fg = c.g10 })
  hl("Define", { fg = c.g10 })
  hl("Macro", { fg = c.g10 })
  hl("PreCondit", { fg = c.g10 })
  hl("Type", { fg = c.g11 })
  hl("StorageClass", { fg = c.g11 })
  hl("Structure", { fg = c.g11 })
  hl("Typedef", { fg = c.g11 })
  hl("Special", { fg = c.g7 })
  hl("SpecialChar", { fg = c.g9 })
  hl("Tag", { fg = c.g11 })
  hl("Delimiter", { fg = c.g7 })
  hl("SpecialComment", { fg = c.g7, italic = true })
  hl("Debug", { fg = c.g9 })
  hl("Underlined", { underline = true })
  hl("Ignore", { fg = c.g4 })
  hl("Error", { fg = c.white, bold = true })
  hl("Todo", { fg = c.black, bg = c.g10, bold = true })

  -- treesitter (explicit where defaults would fall through to fg)
  hl("@variable", { fg = c.g10 })
  hl("@variable.builtin", { fg = c.g11, italic = true })
  hl("@variable.parameter", { fg = c.g10 })
  hl("@variable.member", { fg = c.g9 })
  hl("@property", { fg = c.g9 })
  hl("@field", { fg = c.g9 })
  hl("@constant", { fg = c.g9 })
  hl("@constant.builtin", { fg = c.g10 })
  hl("@constant.macro", { fg = c.g10 })
  hl("@module", { fg = c.g11 })
  hl("@namespace", { fg = c.g11 })
  hl("@string", { fg = c.g8 })
  hl("@string.escape", { fg = c.g10 })
  hl("@string.regexp", { fg = c.g9 })
  hl("@string.special", { fg = c.g9 })
  hl("@character", { fg = c.g8 })
  hl("@number", { fg = c.g9 })
  hl("@boolean", { fg = c.g9 })
  hl("@float", { fg = c.g9 })
  hl("@function", { fg = c.g12, bold = true })
  hl("@function.builtin", { fg = c.g12 })
  hl("@function.method", { fg = c.g12, bold = true })
  hl("@function.macro", { fg = c.g11 })
  hl("@constructor", { fg = c.g11 })
  hl("@keyword", { fg = c.white, italic = true })
  hl("@keyword.function", { fg = c.white, italic = true })
  hl("@keyword.operator", { fg = c.g8, italic = true })
  hl("@keyword.return", { fg = c.white, italic = true })
  hl("@keyword.import", { fg = c.g10, italic = true })
  hl("@operator", { fg = c.g8 })
  hl("@punctuation.delimiter", { fg = c.g7 })
  hl("@punctuation.bracket", { fg = c.g7 })
  hl("@punctuation.special", { fg = c.g8 })
  hl("@type", { fg = c.g11 })
  hl("@type.builtin", { fg = c.g11, italic = true })
  hl("@type.definition", { fg = c.g11 })
  hl("@attribute", { fg = c.g10 })
  hl("@tag", { fg = c.g11 })
  hl("@tag.attribute", { fg = c.g9 })
  hl("@tag.delimiter", { fg = c.g7 })
  hl("@label", { fg = c.g10 })
  hl("@comment", { fg = c.g6, italic = true })
  hl("@comment.error", { fg = c.white, bold = true })
  hl("@comment.warning", { fg = c.g10 })
  hl("@comment.todo", { fg = c.black, bg = c.g10, bold = true })
  hl("@comment.note", { fg = c.g8 })
  hl("@markup.heading", { fg = c.white, bold = true })
  hl("@markup.strong", { fg = c.white, bold = true })
  hl("@markup.italic", { fg = c.fg, italic = true })
  hl("@markup.raw", { fg = c.g8 })
  hl("@markup.link", { fg = c.g10, underline = true })
  hl("@markup.link.url", { fg = c.g8, italic = true })
  hl("@markup.list", { fg = c.g9 })
  hl("@diff.plus", { fg = c.g11 })
  hl("@diff.minus", { fg = c.g6 })
  hl("@diff.delta", { fg = c.g9 })

  -- LSP semantic tokens follow treesitter
  hl("@lsp.type.variable", { link = "@variable" })
  hl("@lsp.type.parameter", { link = "@variable.parameter" })
  hl("@lsp.type.property", { link = "@property" })
  hl("@lsp.type.function", { link = "@function" })
  hl("@lsp.type.method", { link = "@function.method" })
  hl("@lsp.type.keyword", { link = "@keyword" })
  hl("@lsp.type.class", { link = "@type" })
  hl("@lsp.type.interface", { link = "@type" })
  hl("@lsp.type.namespace", { link = "@namespace" })

  -- diagnostics (brightness, not color)
  hl("DiagnosticError", { fg = c.white })
  hl("DiagnosticWarn", { fg = c.g10 })
  hl("DiagnosticInfo", { fg = c.g8 })
  hl("DiagnosticHint", { fg = c.g7 })
  hl("DiagnosticOk", { fg = c.g11 })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = c.white })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.g10 })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.g8 })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.g7 })
  hl("DiagnosticVirtualTextError", { fg = c.g8 })
  hl("DiagnosticVirtualTextWarn", { fg = c.g7 })
  hl("DiagnosticVirtualTextInfo", { fg = c.g6 })
  hl("DiagnosticVirtualTextHint", { fg = c.g6 })

  -- git / gitsigns (brightness-coded)
  hl("DiffAdd", { bg = "#1c1c1c" })
  hl("DiffChange", { bg = "#181818" })
  hl("DiffDelete", { fg = c.g6, bg = "#141414" })
  hl("DiffText", { bg = c.g4 })
  hl("Added", { fg = c.g11 })
  hl("Changed", { fg = c.g9 })
  hl("Removed", { fg = c.g6 })
  hl("GitSignsAdd", { fg = c.g10 })
  hl("GitSignsChange", { fg = c.g8 })
  hl("GitSignsDelete", { fg = c.g6 })

  -- common plugins
  hl("TelescopeNormal", { fg = c.fg, bg = c.none })
  hl("TelescopeBorder", { fg = c.g5, bg = c.none })
  hl("TelescopePromptBorder", { fg = c.g5, bg = c.none })
  hl("TelescopeSelection", { fg = c.white, bg = c.g2, bold = true })
  hl("TelescopeMatching", { fg = c.white, bold = true })
  hl("TelescopeTitle", { fg = c.white, bold = true })
  hl("NeoTreeNormal", { fg = c.g9, bg = c.none })
  hl("NeoTreeNormalNC", { fg = c.g9, bg = c.none })
  hl("NvimTreeNormal", { fg = c.g9, bg = c.none })
  hl("WhichKey", { fg = c.g10 })
  hl("WhichKeyGroup", { fg = c.g8 })
  hl("WhichKeyDesc", { fg = c.fg })
  hl("WhichKeySeparator", { fg = c.g6 })
  hl("WhichKeyFloat", { bg = c.none })
  hl("IndentBlanklineChar", { fg = c.g2 })
  hl("IblIndent", { fg = c.g2 })
  hl("IblScope", { fg = c.g4 })
  hl("CmpItemAbbr", { fg = c.g9 })
  hl("CmpItemAbbrMatch", { fg = c.white, bold = true })
  hl("CmpItemKind", { fg = c.g7 })
  hl("CmpItemMenu", { fg = c.g6 })
  hl("BlinkCmpLabel", { fg = c.g9 })
  hl("BlinkCmpLabelMatch", { fg = c.white, bold = true })
  hl("BlinkCmpKind", { fg = c.g7 })
end

-- lualine theme: modes differ by brightness only (still readable in pure mono)
function M.lualine()
  local b = { fg = c.g9, bg = c.g2 }
  local mid = { fg = c.g7, bg = c.none }
  local function mode(bg)
    return { a = { fg = c.black, bg = bg, gui = "bold" }, b = b, c = mid }
  end
  return {
    normal = mode(c.g11),
    insert = mode(c.white),
    visual = mode(c.g8),
    replace = mode(c.g6),
    command = mode(c.g9),
    terminal = mode(c.g7),
    inactive = { a = { fg = c.g6, bg = c.none }, b = { fg = c.g6, bg = c.none }, c = { fg = c.g5, bg = c.none } },
  }
end

return M
