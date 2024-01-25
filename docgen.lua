local lfs = require "lfs"
local md = require "markdown.markdown".default()
local html = require "markdown.renderer.html_renderer"

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

if not lfs.attributes(input .. "/template.html") then
  print("Input directory '" .. input .. "' does not contain a template.html")
  return
end

local template_content = io.open(input .. "/template.html"):read("*a")

if lfs.attributes(output) then
  -- remove all files in the output directory
  for file in lfs.dir(output) do
    if file ~= "." and file ~= ".." then
      os.remove(output .. "/" .. file)
    end
  end
end
lfs.mkdir(output)

local function template(source, key, value)
  -- replace all instances of {{key}} with value
  return source:gsub("{{" .. key .. "}}", value)
end

local function saveFile(path, content)
  -- create the directory if it doesn't exist
  local dir = path:match("(.+)/[^/]*%.%w+$")
  if dir then
    lfs.mkdir(dir)
  end

  local file = io.open(path, "w")
  file:write(content)
  file:close()
end

local function processDirectory(dir)
  for file in lfs.dir(dir) do
    local path = dir .. "/" .. file
    if file == "." or file == ".." then
      -- skip these files
    elseif lfs.attributes(path, "mode") == "directory" then
      -- directory, go inside
      processDirectory(path)
    else
      -- only process .md files
      if file:sub(-3) == ".md" then

        local out_path = output .. path:gsub(input, ""):sub(1, -4) .. ".html"

        local parsed = md:parse(io.open(path):read("*a"))
        local html_text = html(parsed)
        local out_text = template(template_content, "content", html_text)
        saveFile(out_path, out_text)
      else
        -- just copy the file
        if file == "template.html" then
          -- don't copy the template
          goto continue
        end

        local out_path = output .. path:gsub(input, "")
        local file = io.open(path)
        local content = file:read("*a")
        file:close()
        saveFile(out_path, content)
      end
    end
    ::continue::
  end
end

-- start processing from the input directory
processDirectory(input)