local utils = {}

local quotepattern = "([" .. ("%^$().[]*+-?"):gsub("(.)", "%%%1") .. "])"

local function quoted(str)
  return str:gsub(quotepattern, "%%%1")
end

function utils.relative(filename)
  return string.gsub(filename, quoted(vim.fn.getcwd() .. "/"), "")
end

return utils
