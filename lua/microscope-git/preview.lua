local stream = require("microscope.stream")
local highlight = require("microscope.utils.highlight")

local preview = {}

function preview.file_diff(data, window)
  window:clear()
  if preview.stream then
    preview.stream:stop()
  end
  preview.stream = stream.chain({
    {
      command = "git",
      args = { "diff", "--color=always", data.file },
    },
  }, function(lines)
    window:write_term(lines)
  end)

  preview.stream:start()
end

function preview.file(data, window)
  window:clear()
  if preview.stream then
    preview.stream:stop()
  end
  preview.stream = stream.chain({
    {
      command = "git",
      args = { "--no-pager", "show", string.format("%s:%s", data.hash, data.file) },
    },
  }, function(lines)
    window:write(lines)
    highlight(data.file, window.buf)
  end)

  preview.stream:start()
end

return preview
