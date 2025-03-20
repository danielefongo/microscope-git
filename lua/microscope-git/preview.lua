local scope = require("microscope.api.scope")
local treesitter = require("microscope.api.treesitter")

local preview = {}

function preview.file_diff(data, window)
  window:clear()
  if preview.scope then
    preview.scope:stop()
  end

  preview.scope = scope.new({
    lens = {
      fun = function(flow)
        flow.consume(flow.cmd.shell("git", {
          "diff",
          "--color=always",
          data.file,
        }))
      end,
    },
    callback = function(lines)
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
      fun = function(flow)
        flow.consume(flow.cmd.shell("git", {
          "--no-pager",
          "show",
          string.format("%s:%s", data.hash, data.file),
        }))
      end,
    },
    callback = function(lines, text)
      window:write(lines)
      local hls = treesitter.for_buffer(window.buf, vim.filetype.match({ filename = data.file, buf = window.buf }))
      window:clear_buf_hls()
      window:set_buf_hls(hls)
    end,
  })

  preview.scope:search(data.file)
end

return preview
