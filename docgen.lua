local lfs = require "lfs"
local md = require "markdown.markdown".default()
local toHtml = require "markdown.renderer.html_renderer"

local args = {...}

local function printUsage()
  print("Usage: docgen <input> <output>")
end

if #args < 2 then
  printUsage()
  return
end

local input = args[1]
local output = args[2]

if not lfs.attributes(input) then
  print("Input directory '" .. input .. "' does not exist")
  return
end

if lfs.attributes(output) then
  -- remove all files in the output directory
  for file in lfs.dir(output) do
    if file ~= "." and file ~= ".." then
      os.remove(output .. "/" .. file)
    end
  end
end
lfs.mkdir(output)

-- loop through all files in the input directory
for file in lfs.dir(input) do
  -- only process .md files
  if file:sub(-3) ~= ".md" then
    goto continue
  end
  print(file)

  local parsed = md:parse(io.open(input .. "/" .. file):read("*a"))
  local html = toHtml(parsed)
  io.open(output .. "/" .. file:sub(1, -4) .. ".html", "w"):write(html)


  ::continue::
end