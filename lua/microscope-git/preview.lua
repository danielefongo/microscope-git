local scope = require("microscope.api.scope")
local highlight = require("microscope.utils.highlight")

local preview = {}

function preview.file_diff(data, window)
  window:clear()
  if preview.scope then
    preview.scope:stop()
  end

  preview.scope = scope.new({
    lens = {
      fun = function(flow)
        flow.spawn({
          cmd = "git",
          args = { "diff", "--color=always", data.file },
        })
      end,
    },
    callback = function(lines, text)
      window:write_term(lines)
    end,
  })

  preview.scope:search(data.file)
end

function preview.file(data, window)
  window:clear()
  if preview.stream then
    preview.stream:stop()
  end

  preview.scope = scope.new({
    lens = {
      fun = function(flow, text)
        flow.spawn({
          cmd = "git",
          args = { "--no-pager", "show", string.format("%s:%s", data.hash, data.file) },
        })
      end,
    },
    callback = function(lines, text)
      window:write(lines)
      highlight(text, window.buf)
    end,
  })

  preview.scope:search(data.file)
end

return preview
