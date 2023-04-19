local utils = require("microscope-git.utils")
local lenses = {}

function lenses.status()
  return {
    fun = function(flow, _)
      flow.spawn({
        cmd = "git",
        args = { "status", "-s" },
      })
    end,
  }
end

function lenses.file_history()
  return {
    fun = function(flow, request)
      local filename = flow.fn(vim.api.nvim_buf_get_name, request.buf)
      local relative_filename = flow.fn(utils.relative, filename)

      flow.spawn({
        cmd = "git",
        args = { "log", "--follow", "--pretty=format:%h: %s", "--no-patch", "--", relative_filename },
      })
    end,
  }
end

return lenses
