local chromatic = require 'fluoromachine.chromatic'

local M = {}

M.highlights = {}
M.colors = {
  bg = '#262335',
  fg = '#8BA7A7',
  comment = '#495495',
  alt_bg = '#241b2f',
  selection = '#463465',
  blue = '#61E2FF',
  purple = '#AF6DF9',
  pink = '#FC199A',
  green = '#59CE8F',
  orange = '#F99417',
  yellow = '#FFCC00',
  red = '#F44747',
  gray = '#73817D',
  info = '#6796E6',
  warn = '#CD9731',
  hint = '#61E2FF',
  error = '#F44747',
  add = '#59CE8F',
  changed = '#F99417',
  deleted = '#f44747',
  removed = '#F44747',
}
M.config = {
  transparent = false,
  brightness = 0.15,
  glow = false,
}

function M:new()
  local t = {}

  self.__index = self
  setmetatable(t, self)

  return t
end

function M:setup(t)
  local user_config = t or {}

  self:load()

  if not vim.tbl_isempty(user_config) then
    self:set_user_config(user_config.config)
    self:set_user_colors(user_config.colors)
    self:set_glow()
  end

  if vim.tbl_isempty(self.highlights) then
    self:set_hl()
    self:set_user_hl(user_config.highlights)
  end

  self:apply_hl()
end

function M:load()
  if vim.g.colors_name then
    vim.cmd 'hi clear'
  end

  if vim.fn.exists 'syntax_on' then
    vim.cmd 'syntax reset'
  end

  vim.o.termguicolors = true
  vim.g.colors_name = 'fluoromachine'
end

function M:set_user_colors(new_colors)
  if new_colors then
    if type(new_colors) == 'function' then
      self.colors = vim.tbl_extend(
        'force',
        self.colors,
        new_colors(self.colors, chromatic.darken, chromatic.lighten, chromatic.blend)
      )
    elseif type(new_colors) == 'table' then
      self.colors = vim.tbl_extend('force', self.colors, new_colors)
    else
      vim.api.nvim_err_writeln 'Error: invalid colors'
    end
  end
end

function M:set_user_hl(user_hl)
  if user_hl then
    if type(user_hl) == 'function' then
      self.highlights = vim.tbl_extend(
        'force',
        self.highlights,
        user_hl(self.colors, chromatic.darken, chromatic.lighten, chromatic.blend)
      )
    elseif type(user_hl) == 'table' then
      self.highlights = vim.tbl_extend('force', self.highlights, user_hl)
    else
      vim.api.nvim_err_writeln 'Error: invalid highlights'
    end
  end
end

function M:set_user_config(user_config)
  if user_config then
    self.config = vim.tbl_extend('force', self.config, user_config)
  end
end

function M:is_transparent(color)
  if self.config.transparent then
    return 'NONE'
  end

  return color
end

function M:is_not_transparent(color)
  if not self.config.transparent then
    return 'NONE'
  end

  return color
end

function M:apply_hl()
  for group_name, group_config in pairs(self.highlights) do
    local val = {
      fg = 'NONE',
      bg = 'NONE',
    }

    val = vim.tbl_extend('force', val, group_config)

    vim.api.nvim_set_hl(0, group_name, val or {})
  end
end

function M:set_glow()
  if self.config.glow and self.config.brightness ~= 0.15 then
    local blend = function(hex_color)
      return chromatic.blend(hex_color, '#200933', self.config.brightness)
    end

    self.colors.fg = '#E8F9FD'
    self.colors.bg = '#200933'
    self.colors.alt_bg = '#190728'
    self.colors.blue_bg = blend(self.colors.blue)
    self.colors.purple_bg = blend(self.colors.purple)
    self.colors.pink_bg = blend(self.colors.pink)
    self.colors.green_bg = blend(self.colors.green)
    self.colors.orange_bg = blend(self.colors.orange)
    self.colors.yellow_bg = blend(self.colors.yellow)
    self.colors.red_bg = blend(self.colors.red)
    self.colors.info_bg = blend(self.colors.info)
    self.colors.warn_bg = blend(self.colors.warn)
    self.colors.hint_bg = blend(self.colors.hint)
    self.colors.error_bg = blend(self.colors.error)
    self.colors.add_bg = blend(self.colors.add)
    self.colors.changed_bg = blend(self.colors.changed)
    self.colors.deleted_bg = blend(self.colors.deleted)
    self.colors.removed_bg = blend(self.colors.removed)
  elseif self.config.glow then
    self.colors.fg = '#E8F9FD'
    self.colors.bg = '#200933'
    self.colors.alt_bg = '#190728'
    self.colors.blue_bg = '#2A2A52'
    self.colors.purple_bg = '#351851'
    self.colors.pink_bg = '#410B42'
    self.colors.green_bg = '#222D30'
    self.colors.orange_bg = '#411C2C'
    self.colors.yellow_bg = '#41262B'
    self.colors.red_bg = '#401236'
    self.colors.info_bg = '#2B1F4E'
    self.colors.warn_bg = '#3A1E33'
    self.colors.hint_bg = '#2A2A52'
    self.colors.error_bg = '#401236'
    self.colors.add_bg = '#222D30'
    self.colors.changed_bg = '#411C2C'
    self.colors.deleted_bg = '#401236'
    self.colors.removed_bg = '#401236'
  end
end

function M:set_hl()
  local colors = self.colors
  local alpha = self.config.brightness
  local blend = chromatic.blend
  local darken = chromatic.darken

  self.colors.darker_purple = darken(colors.purple, 40)
  self.colors.darker_pink = darken(colors.pink, 40)

  self.highlights = {
    -- BASE
    Comment = { fg = colors.comment, italic = vim.g.fluoromachine_italic_comments and true },
    ColorColumn = { bg = colors.bg },
    Conceal = { fg = colors.blue },
    Cursor = { fg = colors.bg, bg = colors.purple },
    CursorColumn = { bg = colors.bg },
    CursorLineNr = { fg = colors.pink, bg = colors.pink_bg, sp = colors.fg },
    CursorLine = { bg = colors.selection, sp = colors.fg },
    lCursor = { link = 'Cursor' },
    -- CursorIM = { fg = colors.bg, bg = colors.fg },
    MatchWord = { bold = true },
    MatchParen = { fg = colors.pink, bg = colors.pink_bg, bold = true },
    MatchWordCur = { bold = true },
    MatchParenCur = { bold = true },
    Normal = { fg = colors.fg, bg = self:is_transparent(colors.bg) },
    NormalNC = { link = 'Normal' },
    NormalFloat = { fg = colors.fg, bg = self:is_transparent(colors.alt_bg) },
    Pmenu = { fg = colors.fg, bg = self:is_transparent(colors.alt_bg), bold = true },
    PmenuSel = { bg = colors.selection, bold = true },
    PmenuSbar = { bg = colors.bg, bold = true },
    PmenuThumb = { bg = colors.pink, bold = true },
    TabLine = { fg = colors.fg, bg = colors.bg, sp = colors.fg },
    TabLineSel = { fg = colors.fg, bg = colors.selection, sp = colors.fg, reverse = true },
    TabLineFill = { fg = colors.fg, bg = colors.bg, sp = colors.fg },
    StatusLine = { fg = colors.pink, bg = colors.selection },
    StatusLineNC = { fg = colors.purple, bg = colors.selection },
    FloatBorder = {
      fg = colors.pink,
      bg = self:is_transparent(colors.pink_bg),
      sp = colors.pink,
    },
    SignColumn = { fg = colors.red },
    MsgArea = { fg = colors.fg, bg = self:is_transparent(colors.bg) },
    ModeMsg = { fg = colors.blue },
    MsgSeparator = { fg = colors.fg, bg = colors.bg },
    MoreMsg = { fg = colors.blue },
    NonText = { fg = colors.purple },
    SpellBad = { sp = colors.error, undercurl = true },
    SpellCap = { sp = colors.purple, undercurl = true },
    SpellLocal = { sp = colors.warn, undercurl = true },
    SpellRare = { sp = colors.blue, undercurl = true },
    WildMenu = { fg = colors.bg, bg = colors.bg, reverse = true, bold = true },
    Folded = { fg = colors.fg, bg = colors.bg, sp = colors.bg },
    FoldColumn = { fg = colors.fg, bg = colors.bg },
    LineNr = { fg = colors.darker_purple, bg = self:is_transparent(colors.bg) },
    Whitespace = { fg = colors.bg },
    WinSeparator = { fg = colors.darker_purple },
    VertSplit = { link = 'WinSeparator' },
    Visual = { bg = colors.selection },
    VisualNOS = { bg = colors.bg, reverse = true, bold = true },
    DiffAdd = { fg = colors.add, bg = colors.add_bg },
    DiffChange = { fg = colors.changed, bg = colors.changed_bg, sp = colors.changed },
    DiffDelete = { fg = colors.deleted, reverse = true },
    DiffText = { fg = colors.blue, bg = colors.blue_bg, sp = colors.blue },
    DiffAdded = { fg = colors.add, bg = colors.add_bg },
    DiffChanged = { fg = colors.changed, bg = colors.changed_bg },
    DiffRemoved = { fg = colors.removed, bg = colors.removed_bg },
    DiffFile = { fg = colors.comment },
    DiffIndexLine = { fg = colors.purple },
    QuickFixLine = { bg = colors.bg },
    TermCursor = { bg = colors.purple },
    TermCursorNC = { bg = colors.purple },
    Directory = { fg = colors.yellow, bg = colors.yellow_bg },
    SpecialKey = { fg = colors.red },
    Title = { fg = colors.yellow, bg = colors.yellow_bg, bold = true },
    Search = { fg = colors.orange },
    IncSearch = { fg = colors.yellow, bg = colors.yellow_bg },
    Substitute = { fg = colors.orange, reverse = true },
    Question = { fg = colors.blue, bold = true },
    EndOfBuffer = { fg = colors.bg },
    Constant = { fg = colors.purple },
    --       *Constant        any constant
    --        String          a string constant: "this is a string"
    --        Character       a character constant: 'c', '\n'
    --        Number          a number constant: 234, 0xff
    --        Boolean         a boolean constant: TRUE, false
    --        Float           a floating point constant: 2.3e10
    String = { fg = colors.purple },
    -- Character = { fg = colors.purple },
    -- Number = { fg = colors.purple },
    -- Boolean = { fg = colors.purple },
    -- Float = { fg = colors.purple },
    Identifier = { fg = colors.pink, bg = colors.pink_bg },
    --       *Identifier      any variable name
    -- Function        function name (also: methods for classes)
    -- Variable = { fg = colors.blue },
    Function = {
      fg = colors.yellow,
      bg = colors.yellow_bg,
      italic = vim.g.fluoromachine_italic_functions or false,
    },
    Statement = { fg = colors.pink },
    --       *Statement       any statement
    --        Conditional     if, then, else, endif, switch, etc.
    --        Repeat          for, do, while, etc.
    --        Label           case, default, etc.
    --        Operator        "sizeof", "+", "*", etc.
    --        Keyword         any other keyword
    --        Exception       try, catch, throw
    -- Conditional = { fg = colors.pink },
    -- Repeat = { fg = colors.pink },
    -- Label = { fg = colors.pink },
    -- Operator = { fg = colors.pink },
    Keyword = {
      fg = colors.pink,
      bg = colors.pink_bg,
      italic = vim.g.fluoromachine_italic_keywords or false,
    },
    -- Exception = { fg = colors.pink },
    PreProc = { fg = colors.purple, bg = colors.purple_bg },
    --       *PreProc         generic Preprocessor
    --        Include         preprocessor #include
    --        Define          preprocessor #define
    --        Macro           same as Define
    --        PreCondit       preprocessor #if, #else, #endif, etc.
    Include = { fg = colors.pink },
    -- Define = { fg = colors.orange },
    -- Macro = { fg = colors.orange },
    -- PreCondit = { fg = colors.orange },
    Type = { fg = colors.purple, bg = colors.purple_bg },
    --       *Type            int, long, char, etc.
    --        StorageClass    static, register, volatile, etc.
    --        Structure       struct, union, enum, etc.
    --        Typedef         A typedef
    -- StorageClass = { fg = colors.yellow },
    -- Structure = { fg = colors.yellow },
    -- Typedef = { fg = colors.yellow },
    Special = { fg = colors.yellow, bg = colors.yellow_bg },
    --       *Special         any special symbol
    --        SpecialChar     special character in a constant
    --        Tag             you can use CTRL-] on this
    --        Delimiter       character that needs attention
    --        SpecialComment  special things inside a comment
    --        Debug           debugging statements
    -- SpecialChar = { fg = colors.red },
    -- Tag = { fg = colors.red },
    -- Delimiter = { fg = colors.red },
    -- SpecialComment = { fg = colors.red },
    -- Debug = { fg = colors.red },
    Underlined = { fg = colors.purple, underline = true },
    Bold = { bold = true },
    Italic = { italic = true },
    Ignore = { fg = colors.blue, bg = colors.bg, bold = true },
    Todo = { link = 'Title' },
    Error = { fg = colors.error },
    ErrorMsg = { fg = colors.error, bg = colors.error_bg },
    WarningMsg = { fg = colors.warn, bg = colors.warn_bg },
    -- Treesitter - Misc
    ['@comment'] = { link = 'Comment' },
    ['@error'] = { link = 'Error' },
    ['@preproc'] = { link = 'PreProc' },
    ['@define'] = { link = 'Define' },
    ['@operator'] = { fg = colors.pink, bg = colors.pink_bg },
    -- Treesitter - Punctuation
    ['@punctuation.delimiter'] = { fg = colors.fg },
    ['@punctuation.bracket'] = { fg = colors.purple },
    ['@punctuation.special'] = { fg = colors.pink },
    -- Treesitter - Literals
    ['@string'] = { link = 'String' },
    ['@string.regex'] = { link = '@operator' },
    ['@character'] = { link = 'Character' },
    ['@boolean'] = { link = '@constant' },
    ['@number'] = { link = '@constant' },
    ['@float'] = { link = '@constant' },
    -- Treesitter - Functions
    ['@function.call'] = { link = 'Function' },
    ['@function.builtin'] = { link = 'Function' },
    ['@method'] = { link = 'Function' },
    ['@method.call'] = { link = 'Function' },
    ['@constructor'] = { fg = colors.purple, bg = self.config.glow and '#270E3D' or nil },
    ['@parameter'] = { fg = colors.blue, italic = true },
    -- Treesitter - Keywords
    ['@keyword'] = { link = 'Keyword' },
    ['@keyword.function'] = { link = 'Keyword' },
    ['@keyword.return'] = { link = 'Keyword' },
    ['@conditional'] = { link = 'Keyword' },
    ['@conditional.ternary'] = { link = 'Keyword' },
    ['@repeat'] = { link = 'Keyword' },
    ['@label'] = { fg = colors.pink, bg = colors.pink_bg },
    ['@include'] = { link = 'Include' },
    ['@exception'] = { link = 'Include' },
    -- Treesitter - Types
    ['@type'] = { fg = colors.purple },
    ['@type.qualifier'] = { fg = colors.pink },
    ['@type.builtin'] = { fg = colors.pink },
    ['@field'] = { fg = colors.pink },
    ['@property'] = { fg = colors.blue },
    -- Treesitter - Identifiers
    ['@variable'] = { fg = colors.blue, italic = vim.g.fluoromachine_italic_variables or false },
    ['@variable.builtin'] = { fg = colors.purple },
    ['@constant'] = { fg = colors.purple },
    ['@constant.builtin'] = { link = '@constant' },
    ['@constant.macro'] = { link = '@constant' },
    -- Treesitter - Text
    ['@text'] = { fg = colors.fg },
    ['@text.strong'] = { link = 'Bold' },
    ['@text.strike'] = { fg = colors.comment },
    ['@text.title'] = { link = 'Title' },
    ['@text.literal'] = { link = '@text' },
    ['@text.reference'] = { fg = colors.purple },
    ['@text.uri'] = { fg = colors.pink, bg = colors.pink_bg },
    ['@text.todo'] = { link = 'Title' },
    ['@text.warning'] = { link = 'WarningMsg' },
    ['@text.danger'] = { link = 'ErrorMsg' },
    ['@text.diff.add'] = { link = 'DiffAdd' },
    ['@text.diff.delete'] = { link = 'DiffDelete' },
    -- Treesitter - Tags
    ['@tag'] = { fg = colors.yellow, bg = colors.yellow_bg },
    ['@tag.attribute'] = { fg = colors.pink, bg = colors.pink_bg },
    ['@tag.delimiter'] = { fg = colors.blue, bg = colors.blue_bg },
    -- DIAGNOSTIC
    DiagnosticError = { fg = colors.error },
    DiagnosticWarn = { fg = colors.warn },
    DiagnosticInfo = { fg = colors.info },
    DiagnosticHint = { fg = colors.hint },
    DiagnosticOther = { fg = colors.purple },
    DiagnosticSignHint = { link = 'DiagnosticHint' },
    DiagnosticSignInfo = { link = 'DiagnosticInfo' },
    DiagnosticSignWarn = { link = 'DiagnosticWarn' },
    DiagnosticSignError = { link = 'DiagnosticError' },
    DiagnosticSignOther = { link = 'DiagnosticOther' },
    DiagnosticSignWarning = { link = 'DiagnosticWarn' },
    DiagnosticFloatingHint = { link = 'DiagnosticHint' },
    DiagnosticFloatingInfo = { link = 'DiagnosticInfo' },
    DiagnosticFloatingWarn = { link = 'DiagnosticWarn' },
    DiagnosticFloatingError = { link = 'DiagnosticError' },
    DiagnosticUnderlineHint = { fg = colors.hint, undercurl = true, sp = colors.hint },
    DiagnosticUnderlineInfo = { fg = colors.info, undercurl = true, sp = colors.info },
    DiagnosticUnderlineWarn = { fg = colors.warn, undercurl = true, sp = colors.warning },
    DiagnosticUnderlineError = { fg = colors.error, undercurl = true, sp = colors.error },
    DiagnosticSignInformation = { link = 'DiagnosticInfo' },
    DiagnosticVirtualTextHint = { fg = colors.hint, bg = colors.hint_bg },
    DiagnosticVirtualTextInfo = { fg = colors.info, bg = colors.info_bg },
    DiagnosticVirtualTextWarn = { fg = colors.warning, bg = colors.warning_bg },
    DiagnosticVirtualTextError = { fg = colors.error, bg = colors.error_bg },
    LspDiagnosticsError = { link = 'DiagnosticError' },
    LspDiagnosticsWarning = { link = 'DiagnosticWarn' },
    LspDiagnosticsInfo = { link = 'DiagnosticInfo' },
    LspDiagnosticsInformation = { link = 'LspDiagnosticsInfo' },
    LspDiagnosticsHint = { link = 'DiagnosticHint' },
    LspDiagnosticsDefaultError = { link = 'LspDiagnosticsError' },
    LspDiagnosticsDefaultWarning = { link = 'LspDiagnosticsWarning' },
    LspDiagnosticsDefaultInformation = { link = 'LspDiagnosticsInfo' },
    LspDiagnosticsDefaultInfo = { link = 'LspDiagnosticsInfo' },
    LspDiagnosticsDefaultHint = { link = 'LspDiagnosticsHint' },
    LspDiagnosticsVirtualTextError = { link = 'DiagnosticVirtualTextError' },
    LspDiagnosticsVirtualTextWarning = { link = 'DiagnosticVirtualTextWarn' },
    LspDiagnosticsVirtualTextInformation = { link = 'DiagnosticVirtualTextInfo' },
    LspDiagnosticsVirtualTextInfo = { link = 'DiagnosticVirtualTextInfo' },
    LspDiagnosticsVirtualTextHint = { link = 'DiagnosticVirtualTextHint' },
    LspDiagnosticsFloatingError = { link = 'LspDiagnosticsError' },
    LspDiagnosticsFloatingWarning = { link = 'LspDiagnosticsWarning' },
    LspDiagnosticsFloatingInformation = { link = 'LspDiagnosticsInfo' },
    LspDiagnosticsFloatingInfo = { link = 'LspDiagnosticsInfo' },
    LspDiagnosticsFloatingHint = { link = 'LspDiagnosticsHint' },
    LspDiagnosticsSignError = { link = 'LspDiagnosticsError' },
    LspDiagnosticsSignWarning = { link = 'LspDiagnosticsWarning' },
    LspDiagnosticsSignInformation = { link = 'LspDiagnosticsInfo' },
    LspDiagnosticsSignInfo = { link = 'LspDiagnosticsInfo' },
    LspDiagnosticsSignHint = { link = 'LspDiagnosticsHint' },
    NvimTreeLspDiagnosticsError = { link = 'LspDiagnosticsError' },
    NvimTreeLspDiagnosticsWarning = { link = 'LspDiagnosticsWarning' },
    NvimTreeLspDiagnosticsInformation = { link = 'LspDiagnosticsInfo' },
    NvimTreeLspDiagnosticsInfo = { link = 'LspDiagnosticsInfo' },
    NvimTreeLspDiagnosticsHint = { link = 'LspDiagnosticsHint' },
    LspDiagnosticsUnderlineError = { link = 'DiagnosticUnderlineError' },
    LspDiagnosticsUnderlineWarning = { link = 'DiagnosticUnderlineWarn' },
    LspDiagnosticsUnderlineInformation = { link = 'DiagnosticUnderlineInfo' },
    LspDiagnosticsUnderlineInfo = { link = 'DiagnosticUnderlineInfo' },
    LspDiagnosticsUnderlineHint = { link = 'DiagnosticUnderlineHint' },
    LspReferenceText = { bg = colors.bg_alt },
    LspReferenceRead = { bg = colors.bg_alt },
    LspReferenceWrite = { bg = colors.bg_alt },
    LspCodeLens = { fg = colors.comment, italic = true },
    LspCodeLensSeparator = { fg = colors.comment, italic = true },
    -- Lspsaga
    TitleString = { link = 'Title' },
    TitleIcon = { fg = colors.yellow, bg = colors.yellow_bg },
    SagaNormal = { link = 'Normal' },
    SagaBorder = { link = 'FloatBorder' },
    SagaExpand = { fg = colors.red },
    SagaCollapse = { fg = colors.red },
    SagaBeacon = { bg = colors.pink },
    -- LSPSAGA - code action
    ActionPreviewNormal = { link = 'SagaNormal' },
    ActionPreviewBorder = { link = 'SagaBorder' },
    ActionPreviewTitle = { fg = colors.purple, bg = colors.bg_alt },
    CodeActionNormal = { link = 'SagaNormal' },
    CodeActionBorder = { link = 'SagaBorder' },
    CodeActionText = { link = 'String' },
    CodeActionNumber = { link = 'Number' },
    -- LSPSAGA - finder
    FinderSelection = { link = 'PmenuSel' },
    FinderFileName = { fg = colors.fg },
    FinderCount = { link = 'Label' },
    FinderIcon = { fg = colors.red, bg = colors.red_bg },
    FinderType = { fg = colors.purple },
    -- lSPSAGA - finder spinner
    FinderSpinnerTitle = { link = 'Title' },
    FinderSpinner = { fg = colors.green, bold = true },
    FinderPreviewSearch = { link = 'Search' },
    FinderVirtText = { fg = colors.red },
    FinderNormal = { link = 'SagaNormal' },
    FinderBorder = { link = 'SagaBorder' },
    FinderPreviewBorder = { link = 'SagaBorder' },
    -- LSPSAGA - definition
    DefinitionBorder = { link = 'SagaBorder' },
    DefinitionNormal = { link = 'SagaNormal' },
    DefinitionSearch = { link = 'Search' },
    -- LSPSAGA - hover
    HoverNormal = { link = 'SagaNormal' },
    HoverBorder = { link = 'SagaBorder' },
    -- LSPSAGA - rename
    RenameBorder = { link = 'SagaBorder' },
    RenameNormal = { fg = colors.orange, bg = colors.bg_alt },
    RenameMatch = { link = 'Search' },
    -- LSPSAGA - diagnostic
    DiagnosticBorder = { link = 'SagaBorder' },
    DiagnosticSource = { fg = 'gray' },
    DiagnosticNormal = { link = 'SagaNormal' },
    DiagnosticPos = { fg = colors.gray },
    DiagnosticWord = { fg = colors.fg },
    --  LSPSAGA - Call Hierachry
    CallHierarchyNormal = { link = 'SagaNormal' },
    CallHierarchyBorder = { link = 'SagaBorder' },
    CallHierarchyIcon = { fg = colors.purple },
    CallHierarchyTitle = { fg = colors.red },
    -- LSPSAGA - lightbulb
    LspSagaLightBulb = { link = 'DiagnosticSignHint' },
    -- LSPSAGA - shadow
    SagaShadow = { bg = colors.bg_alt },
    -- LSPSAGA- Outline
    OutlineIndent = { fg = colors.magenta },
    OutlinePreviewBorder = { link = 'SagaNormal' },
    OutlinePreviewNormal = { link = 'SagaBorder' },
    -- LSPSAGA - Float term
    TerminalBorder = { link = 'SagaBorder' },
    TerminalNormal = { link = 'SagaNormal' },
    -- CMP KIND
    CmpItemAbbrDeprecated = { fg = colors.gray, strikethrough = true },
    CmpItemAbbrMatch = { link = 'IncSearch' },
    CmpItemAbbrMatchFuzzy = { fg = colors.yellow, reverse = true },
    CmpItemKindFunction = { link = '@function' },
    CmpItemKindMethod = { link = '@method' },
    CmpItemKindConstructor = { link = '@constructor' },
    CmpItemKindClass = { link = '@type' },
    CmpItemKindEnum = { link = '@constant' },
    CmpItemKindEvent = { fg = colors.yellow },
    CmpItemKindInterface = { link = '@constructor' },
    CmpItemKindStruct = { link = '@type' },
    CmpItemKindVariable = { link = '@variable.builtin' },
    CmpItemKindField = { link = '@property' },
    CmpItemKindProperty = { link = '@property' },
    CmpItemKindEnumMember = { link = '@constant.builtin' },
    CmpItemKindConstant = { link = '@contant.builtin' },
    CmpItemKindKeyword = { link = '@keyword' },
    CmpItemKindModule = { link = '@function' },
    CmpItemKindValue = { fg = colors.fg },
    CmpItemKindUnit = { link = '@number' },
    CmpItemKindText = { link = '@string' },
    CmpItemKindSnippet = { fg = colors.fg },
    CmpItemKindFile = { fg = colors.fg },
    CmpItemKindFolder = { fg = colors.fg },
    CmpItemKindColor = { fg = colors.fg },
    CmpItemKindReference = { fg = colors.fg },
    CmpItemKindOperator = { link = '@operator' },
    CmpItemKindTypeParameter = { fg = colors.purple },
    CmpItemKindTabnine = { fg = colors.pink },
    CmpItemKindEmoji = { fg = colors.yellow },
    -- NvimTree
    NvimTreeFolderIcon = { link = 'Directory' },
    NvimTreeIndentMarker = { fg = colors.fg },
    NvimTreeNormal = { link = 'Normal' },
    NvimTreeNormalNC = { link = 'NormalNC' },
    NvimTreeWinSeparator = { link = 'WinSeparator' },
    NvimTreeFolderName = { fg = colors.fg },
    NvimTreeOpenedFolderName = { fg = colors.yellow, bg = colors.yellow_bg, italic = true },
    NvimTreeEmptyFolderName = { link = 'Comment' },
    NvimTreeOpenedFile = { bg = colors.bg_alt },
    NvimTreeGitIgnored = { link = 'Comment' },
    NvimTreeImageFile = { fg = colors.fg },
    NvimTreeSpecialFile = { fg = colors.purple, underline = true },
    NvimTreeEndOfBuffer = { fg = colors.bg },
    NvimTreeCursorLine = { link = 'CursorLine' },
    NvimTreeGitStaged = { fg = colors.add },
    NvimTreeGitNew = { fg = colors.add },
    NvimTreeGitRenamed = { fg = colors.add },
    NvimTreeGitDeleted = { fg = colors.deleted },
    NvimTreeGitMerge = { fg = colors.changed },
    NvimTreeGitDirty = { fg = colors.changed },
    NvimTreeSymlink = { fg = colors.purple },
    NvimTreeRootFolder = { fg = colors.yellow, bg = colors.yellow_bg, bold = true },
    -- NeoTree
    NeoTreeNormal = { link = 'NvimTreeNormal' },
    NeoTreeDirectoryIcon = { link = 'NvimTreeFolderIcon' },
    NeoTreeIndentMarker = { link = 'NvimTreeIndentMarker' },
    NeoTreeNormalNC = { link = 'NvimTreeNormalNC' },
    NeoTreeWinSeparator = { link = 'NvimTreeWinSeparator' },
    NeoTreeDirectoryName = { link = 'NvimTreeFolderName' },
    NeoTreeOpenedDirectoryName = { link = 'NvimTreeOpenedFolderName' },
    NeoTreeOpenedFile = { link = 'NvimTreeOpenedFile' },
    NeoTreeGitIgnored = { link = 'NvimTreeGitIgnored' },
    NeoTreeImageFile = { link = 'NvimTreeImageFile' },
    NeoTreeSpecialFile = { link = 'NvimTreeSpecialFile' },
    NeoTreeEndOfBuffer = { link = 'NvimTreeEndOfBuffer' },
    NeoTreeCursorLine = { link = 'NvimTreeCursorLine' },
    NeoTreeGitAdded = { link = 'NvimTreeGitStaged' },
    NeoTreeGitConflict = { fg = colors.red },
    NeoTreeGitDeleted = { link = 'NvimTreeGitDeleted' },
    NeoTreeGitModified = { link = 'NvimTreeGitDirty' },
    NeoTreeGitUnstaged = { link = 'NvimTreeGitUnstaged' },
    NeoTreeGitUntracked = { link = 'NvimTreeGitNew' },
    NeoTreeHiddenByName = { link = 'NvimTreeEmptyFolderName' },
    NeoTreeExpander = { fg = colors.fg },
    NeoTreeStatusLine = { link = 'NvimTreeCursorLine' },
    NeoTreeStatusLineNC = { link = 'NvimTreeStatusLineNC' },
    NeoTreeSymbolicLinkTarget = { link = 'NvimTreeSymlink' },
    NeoTreeRootName = { link = 'NvimTreeRootFolder' },
    -- Lir
    LirDir = { fg = colors.blue },
    -- TELESCOPE
    TelescopeNormal = { bg = self:is_transparent(colors.alt_bg) },
    TelescopeBorder = { fg = colors.pink, bg = colors.pink_bg },
    TelescopePreviewTitle = { fg = colors.pink },
    TelescopeResultsTitle = { fg = colors.pink },
    TelescopePromptTitle = { fg = colors.pink },
    TelescopeSelection = { fg = colors.yellow },
    TelescopeMatching = { link = 'IncSearch' },
    -- DASHBOARD
    DashboardHeader = { fg = colors.pink },
    DashboardCenter = { fg = colors.yellow },
    DashboardFooter = { fg = colors.purple },
    -- GIT
    SignAdd = { fg = colors.add },
    SignChange = { fg = colors.changed },
    SignDelete = { fg = colors.deleted },
    GitSignsAdd = { fg = colors.add },
    GitSignsChange = { fg = colors.changed },
    GitSignsDelete = { fg = colors.deleted },
    GitGutterAdd = { fg = colors.add },
    GitGutterChange = { fg = colors.changed },
    GitGutterDelete = { fg = colors.deleted },
    -- HOP
    HopPreview = { fg = colors.yellow, bg = colors.yellow_bg, bold = true },
    HopNextKey = { fg = colors.pink, bg = colors.pink_bg, bold = true },
    HopNextKey1 = { fg = colors.blue, bg = colors.blue_bg, bold = true },
    HopNextKey2 = { fg = darken(colors.blue, 15) },
    HopUnmatched = { fg = colors.comment },
    -- TWILIGHT
    Twilight = { fg = colors.darker_purple, bg = self:is_transparent(colors.bg) },
    -- INDENT_BLANKLINE
    IndentBlanklineChar = {
      fg = colors.darker_purple,
      bg = blend(colors.darker_purple, colors.bg, alpha),
    },
    IndentBlanklineContextChar = {
      fg = colors.darker_pink,
      bg = blend(colors.darker_pink, colors.bg, alpha),
    },
    IndentBlanklineSpaceChar = { fg = colors.purple, bg = self.config.glow and '#270E3D' or nil },
    IndentBlanklineContextSpaceChar = { fg = colors.pink, bg = self.config.glow and '#270E3D' or nil },
    -- Whichkey
    WhichKey = { fg = colors.pink, bg = colors.pink_bg },
    WhichKeySeperator = { link = 'Comment' },
    WhichKeyGroup = { fg = colors.yellow },
    WhichKeyDesc = { fg = colors.purple },
    WhichKeyFloat = { link = '@float' },
    WhichKeyValue = { link = '@number' },
    WhichKeyBorder = { link = 'FloatBorder' },
    -- Navic
    NavicIconsFile = { fg = colors.yellow, bg = colors.yellow_bg },
    NavicIconsModule = { link = '@namespace' },
    NavicIconsNamespace = { link = '@namespace' },
    NavicIconsPackage = { fg = colors.yellow, bg = colors.yellow_bg },
    NavicIconsClass = { link = '@type' },
    NavicIconsMethod = { link = '@method' },
    NavicIconsProperty = { link = '@property' },
    NavicIconsField = { link = '@field' },
    NavicIconsConstructor = { link = '@constructor' },
    NavicIconsEnum = { link = '@keyword' },
    NavicIconsInterface = { link = '@type' },
    NavicIconsFunction = { link = '@function' },
    NavicIconsVariable = { link = '@variable' },
    NavicIconsConstant = { link = '@constant' },
    NavicIconsString = { link = '@string' },
    NavicIconsNumber = { link = '@number' },
    NavicIconsBoolean = { link = '@boolean' },
    NavicIconsArray = { link = 'punctuation.bracket' },
    NavicIconsObject = { link = '@property' },
    NavicIconsKey = { link = '@keyword' },
    NavicIconsKeyword = { link = 'Keyword' },
    NavicIconsNull = { link = '@constant' },
    NavicIconsEnumMember = { link = '@constant' },
    NavicIconsStruct = { link = '@keyword' },
    NavicIconsEvent = { link = 'Special' },
    NavicIconsOperator = { link = '@operator' },
    NavicIconsTypeParameter = { link = '@parameter' },
    NavicText = { link = '@text' },
    NavicSeparator = { fg = colors.purple, bg = colors.purple_bg },
    -- NEORG
    ['@neorg.headings.1.title'] = { fg = colors.yellow, bg = colors.yellow_bg },
    ['@neorg.headings.2.title'] = { fg = colors.blue, bg = colors.blue_bg },
    ['@neorg.headings.3.title'] = { fg = colors.orange, bg = colors.orange_bg },
    ['@neorg.headings.4.title'] = { fg = colors.green, bg = colors.green_bg },
    ['@neorg.headings.5.title'] = { fg = colors.pink, bg = colors.pink_bg },
    ['@neorg.headings.6.title'] = { fg = colors.purple, bg = colors.purple_bg },
    ['@neorg.headings.1.prefix'] = { link = '@neorg.headings.1.title' },
    ['@neorg.headings.2.prefix'] = { link = '@neorg.headings.2.title' },
    ['@neorg.headings.3.prefix'] = { link = '@neorg.headings.3.title' },
    ['@neorg.headings.4.prefix'] = { link = '@neorg.headings.4.title' },
    ['@neorg.headings.5.prefix'] = { link = '@neorg.headings.5.title' },
    ['@neorg.headings.6.prefix'] = { link = '@neorg.headings.6.title' },
    ['@neorg.lists.ordered.1.prefix'] = { link = '@neorg.headings.1.title' },
    ['@neorg.lists.ordered.2.prefix'] = { link = '@neorg.headings.2.title' },
    ['@neorg.lists.ordered.3.prefix'] = { link = '@neorg.headings.3.title' },
    ['@neorg.lists.ordered.4.prefix'] = { link = '@neorg.headings.4.title' },
    ['@neorg.lists.ordered.5.prefix'] = { link = '@neorg.headings.5.title' },
    ['@neorg.lists.ordered.6.prefix'] = { link = '@neorg.headings.5.title' },
    ['@neorg.lists.ordered.1.content'] = { link = '@neorg.lists.ordered.1.prefix' },
    ['@neorg.lists.ordered.2.content'] = { link = '@neorg.lists.ordered.2.prefix' },
    ['@neorg.lists.ordered.3.content'] = { link = '@neorg.lists.ordered.3.prefix' },
    ['@neorg.lists.ordered.4.content'] = { link = '@neorg.lists.ordered.4.prefix' },
    ['@neorg.lists.ordered.5.content'] = { link = '@neorg.lists.ordered.5.prefix' },
    ['@neorg.lists.ordered.6.content'] = { link = '@neorg.lists.ordered.6.prefix' },
    ['@neorg.lists.unordered.1.prefix'] = { link = '@neorg.lists.ordered.1.prefix' },
    ['@neorg.lists.unordered.2.prefix'] = { link = '@neorg.lists.ordered.2.prefix' },
    ['@neorg.lists.unordered.3.prefix'] = { link = '@neorg.lists.ordered.3.prefix' },
    ['@neorg.lists.unordered.4.prefix'] = { link = '@neorg.lists.ordered.4.prefix' },
    ['@neorg.lists.unordered.5.prefix'] = { link = '@neorg.lists.ordered.5.prefix' },
    ['@neorg.lists.unordered.6.prefix'] = { link = '@neorg.lists.ordered.6.prefix' },
    ['@neorg.lists.unordered.1.content'] = { link = '@neorg.lists.ordered.1.content' },
    ['@neorg.lists.unordered.2.content'] = { link = '@neorg.lists.ordered.2.content' },
    ['@neorg.lists.unordered.3.content'] = { link = '@neorg.lists.ordered.3.content' },
    ['@neorg.lists.unordered.4.content'] = { link = '@neorg.lists.ordered.4.content' },
    ['@neorg.lists.unordered.5.content'] = { link = '@neorg.lists.ordered.5.content' },
    ['@neorg.lists.unordered.6.content'] = { link = '@neorg.lists.ordered.6.content' },
    ['@neorg.links.file'] = { link = '@text.uri' },
  }
end

return M:new()
