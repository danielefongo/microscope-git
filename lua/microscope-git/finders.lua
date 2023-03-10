local files = require("microscope-files")
local lists = require("microscope.lists")
local git_lists = require("microscope-git.lists")
local preview = require("microscope-git.preview")

return {
  git_file_history = {
    preview = preview.file,
    chain = function(text, _, buf)
      local filename = vim.api.nvim_buf_get_name(buf)
      return { git_lists.file_history(filename), lists.fzf(text), lists.head(100) }
    end,
  },
  git_status = {
    open = files.open,
    preview = preview.file_diff,
    chain = function(text)
      return { git_lists.status(), lists.fzf(text), lists.head(100) }
    end,
  },
}
