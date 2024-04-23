local utils = require("microscope-git.utils")
local lenses = {}

function lenses.status()
  return {
    fun = function(flow, _)
      flow.cmd.shell("git", { "status", "-s" }):into(flow)
    end,
  }
end

function lenses.file_history()
  return {
    fun = function(flow, request)
      local filename = flow.cmd.fn(vim.api.nvim_buf_get_name, request.buf):collect(flow)
      local relative_filename = flow.cmd.fn(utils.relative, filename):collect(flow)

      flow.cmd
        .shell("git", { "log", "--follow", "--pretty=format:%h: %s", "--no-patch", "--", relative_filename })
        :into(flow)
    end,
  }
end

return lenses
