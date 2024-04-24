local utils = require("microscope-git.utils")
local lenses = {}

local function git_buf_relative(buf)
  return utils.relative(vim.api.nvim_buf_get_name(buf))
end

function lenses.status()
  return {
    fun = function(flow, _)
      flow.consume(flow.cmd.shell("git", { "status", "-s" }))
    end,
  }
end

function lenses.file_history()
  return {
    fun = function(flow, request)
      flow.consume(
        flow.cmd
          .fn(git_buf_relative, request.buf)
          :pipe("xargs", { "git", "log", "--follow", "--pretty=format:%h: %s", "--no-patch", "--" })
      )
    end,
  }
end

return lenses
