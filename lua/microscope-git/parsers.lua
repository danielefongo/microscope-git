local highlight = require("microscope.api.highlight")
local utils = require("microscope-git.utils")
local parsers = {}

function parsers.status(data)
  data.file = string.sub(data.text, 4)
  data.highlights = highlight
    .new(data.highlights, data.text)
    :hl_match(highlight.color.color2, "(%w)( )( .*)", 1)
    :hl_match(highlight.color.color2, "(%w)(%w)( .*)", 1)
    :hl_match(highlight.color.color1, "(%w)(%w)( .*)", 2)
    :hl_match(highlight.color.color1, "( )(%w)( .*)", 2)
    :get_highlights()

  return data
end

function parsers.commit(data, request)
  data.file = utils.relative(vim.api.nvim_buf_get_name(request.buf))
  data.hash = vim.split(data.text, ":", {})[1]

  data.highlights =
    highlight.new(data.highlights, data.text):hl_match(highlight.color.color1, "(%w+:)( .*)", 1):get_highlights()

  return data
end

return parsers
