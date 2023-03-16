local lists = {}

local function relative_path(filename)
  return string.gsub(filename, vim.fn.getcwd() .. "/", "")
end

function lists.status()
  return {
    command = "git",
    args = { "status", "-s" },
    parser = function(data)
      local file = string.sub(data.text, 4)

      return {
        text = data.text,
        file = file,
      }
    end,
  }
end

function lists.file_history(filename)
  filename = relative_path(filename)
  return {
    command = "git",
    args = { "log", "--follow", "--pretty=format:%h: %s", "--no-patch", "--", filename },
    parser = function(data)
      local hash = vim.split(data.text, ":", {})[1]
      return {
        text = data.text,
        hash = hash,
        file = filename,
      }
    end,
  }
end

return lists
