local files = require("microscope-files")
local steps = require("microscope.steps")
local git_steps = require("microscope-git.steps")
local preview = require("microscope-git.preview")

return {
  git_file_history = {
    preview = preview.file,
    chain = function(text, _, buf)
      local filename = vim.api.nvim_buf_get_name(buf)
      return { git_steps.file_history(filename), steps.fzf(text), steps.head(100) }
    end,
  },
  git_status = {
    open = files.open,
    preview = preview.file_diff,
    chain = function(text)
      return { git_steps.status(), steps.fzf(text), steps.head(100) }
    end,
  },
}
