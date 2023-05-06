local files = require("microscope-files")
local lenses = require("microscope.builtin.lenses")
local git_lenses = require("microscope-git.lenses")
local parsers = require("microscope.builtin.parsers")
local git_parsers = require("microscope-git.parsers")
local preview = require("microscope-git.preview")

return {
  git_file_history = {
    lens = lenses.head(100, lenses.fzf(lenses.cache(git_lenses.file_history()))),
    parsers = { git_parsers.commit, parsers.fuzzy },
    preview = preview.file,
  },
  git_status = {
    lens = lenses.head(100, lenses.fzf(lenses.cache(git_lenses.status()))),
    parsers = { git_parsers.status, parsers.fuzzy },
    open = files.open,
    preview = preview.file_diff,
  },
}
