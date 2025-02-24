---@type fm.highlights
local M = {}

M.load = function(opts)
  local hl = opts.utils.set_hl
  ---@type fm.colors
  local c = opts.colors
  local config = opts.config

  -- :h treesitter-highlight
  hl('@variable', { link = 'Identifier' })
  hl('@variable.builtin', { fg = c.purple })
  hl('@variable.parameter', { fg = c.orange }, { styles = config.styles.parameters })
  hl('@variable.member', { fg = c.cyan })
  hl('@constant', { link = 'Constant' })
  hl('@constant.html', { fg = c.yellow, bold = config.glow }, { glow = config.glow })
  hl('@constant.builtin', { link = 'Constant' })
  hl('@constant.macro', { link = 'Constant' })
  hl('@module', { fg = c.cyan })
  hl('@module.builtin', { fg = c.purple })
  hl('@label', { link = 'Keyword' })
  hl('@string', { link = 'String' })
  hl('@string.documentation', { link = 'Keyword' })
  hl('@string.regexp', { fg = c.red })
  hl('@string.escape', { link = 'Keyword' })
  hl('@string.special', { link = 'Constant' })
  hl('@string.special.symbol', { link = 'Constant' })
  hl('@string.special.url', { link = 'Underlined' })
  hl('@character', { link = 'String' })
  hl('@character.special', { link = 'Constant' })
  hl('@character.printf', { link = 'Keyword' })
  hl('@type', { link = 'Type' })
  hl('@type.builtin', { link = 'Keyword' })
  hl('@type.definition', { link = 'Type' })
  hl('@type.qualifier', { link = 'Keyword' })
  hl('@function', { link = 'Function' })
  hl('@function.builtin', { link = 'Function' })
  hl('@function.call', { link = 'Function' })
  hl('@function.macro', { link = 'Function' })
  hl('@function.method', { link = 'Function' })
  hl('@function.method.call', { link = 'Function' })
  hl('@constructor', { fg = c.pink })
  hl('@operator', { link = 'Keyword' })
  hl('@keyword', { link = 'Keyword' })
  hl('@keyword.coroutine', { link = 'Keyword' })
  hl('@keyword.function', { link = 'Keyword' })
  hl('@keyword.operator', { link = 'Keyword' })
  hl('@keyword.import', { link = 'Keyword' })
  hl('@keyword.repeat', { link = 'Keyword' })
  hl('@keyword.return', { link = 'Keyword' })
  hl('@keyword.debug', { link = 'Keyword' })
  hl('@keyword.exception', { link = 'Keyword' })
  hl('@keyword.conditional', { link = 'Keyword' })
  hl('@keyword.conditional.ternary', { link = 'Keyword' })
  hl('@keyword.directive', { link = 'Keyword' })
  hl('@keyword.directive.define', { link = 'Keyword' })
  hl('@punctuation.delimiter', { link = 'Delimiter' })
  hl('@punctuation.bracket', { fg = c.purple })
  hl('@punctuation.special', { fg = c.pink })
  hl('@comment', { link = 'Comment' })
  hl('@comment.documentation', { link = 'Comment' })
  hl('@comment.error', { fg = c.diag.error })
  hl('@comment.warning', { fg = c.diag.warning })
  hl('@comment.todo', { fg = c.yellow })
  hl('@comment.note', { fg = c.cyan })
  hl('@markup.strong', { fg = c.orange, bold = true })
  hl('@markup.italic', { fg = c.yellow, italic = true })
  hl('@markup.strikethrough', { fg = c.comment })
  hl('@markup.underline', { fg = c.cyan, underline = true })
  hl('@markup.heading', { fg = c.cyan, bold = true })
  hl('@markup.quote', { fg = c.comment })
  hl('@markup.math', { fg = c.purple })
  hl('@markup.environment', { fg = c.comment })
  hl('@markup.link', { fg = c.orange, bold = true })
  hl('@markup.link.label', { fg = c.cyan, underline = true })
  hl('@markup.link.url', { fg = c.cyan, underline = true })
  hl('@markup.raw', { fg = c.comment })
  hl('@markup.raw.block', { fg = c.fg })
  hl('@markup.list', { fg = c.purple })
  hl('@markup.list.checked', { fg = c.git.add })
  hl('@markup.list.unchecked', { fg = c.git.change })
  hl('@diff.plus', { fg = c.git.add })
  hl('@diff.minus', { fg = c.git.delete })
  hl('@diff.delta', { fg = c.git.change })
  hl('@tag', { fg = c.yellow, bold = config.glow }, { glow = config.glow })
  hl('@tag.builtin', { link = '@tag' })
  hl('@tag.attribute', { fg = c.pink, bold = config.glow }, { glow = config.glow })
  hl('@tag.delimiter', { fg = c.yellow }, { glow = config.glow })
  hl('@property', { fg = c.cyan })
  -- hl('@property.json', { fg = c.pink })
  -- hl('@property.css', { fg = c.pink })
  -- hl('@property.scss', { fg = c.pink })
end

return M
