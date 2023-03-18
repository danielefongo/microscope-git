local highlight = require("microscope.highlight")
local constants = require("microscope.constants")
local steps = {}

local function relative_path(filename)
  return string.gsub(filename, vim.fn.getcwd() .. "/", "")
end

function steps.status()
  return {
    command = "git",
    args = { "status", "-s" },
    parser = function(data)
      local file = string.sub(data.text, 4)

      local highlights = highlight
        .new(data.highlights, data.text)
        :hl_match(constants.color.color2, "(%w)( )( .*)", 1)
        :hl_match(constants.color.color2, "(%w)(%w)( .*)", 1)
        :hl_match(constants.color.color1, "(%w)(%w)( .*)", 2)
        :hl_match(constants.color.color1, "( )(%w)( .*)", 2)
        :get_highlights()

      return {
        text = data.text,
        highlights = highlights,
        file = file,
      }
    end,
  }
end

function steps.file_history(filename)
  filename = relative_path(filename)
  return {
    command = "git",
    args = { "log", "--follow", "--pretty=format:%h: %s", "--no-patch", "--", filename },
    parser = function(data)
      local hash = vim.split(data.text, ":", {})[1]

      local highlights =
        highlight.new(data.highlights, data.text):hl_match(constants.color.color1, "(%w+:)( .*)", 1):get_highlights()

      return {
        text = data.text,
        highlights = highlights,
        hash = hash,
        file = filename,
      }
    end,
  }
end

return steps
