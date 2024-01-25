function renderInline(blockBody)
  local html = ""

  if type(blockBody) == "string" then
    return blockBody
  end

  for _, inline in ipairs(blockBody) do
    -- render inline
    if type(inline) == "string" then
      html = html .. inline
    elseif inline.type == "bold" then
      html = html .. "<b>" .. renderInline(inline.body) .. "</b>"
    elseif inline.type == "italic" then
      html = html .. "<i>" .. renderInline(inline.body) .. "</i>"
    elseif inline.type == "strikethrough" then
      html = html .. "<s>" .. renderInline(inline.body) .. "</s>"
    elseif inline.type == "link" then
      html = html .. "<a href=\"" .. inline.href .. "\">" .. renderInline(inline.body) .. "</a>"
    elseif inline.type == "image" then
      html = html .. "<img src=\"" .. inline.src .. "\" alt=\"" .. inline.alt .. "\">"
    elseif inline.type == "code" then
      html = html .. "<code>" .. inline.body .. "</code>"
    end

  end

  return html
end

return function(document)

  local html = ""

  for _, block in ipairs(document) do
    if block.type == "paragraph" then
      html = html .. "<p>" .. renderInline(block.body) .. "</p>"
    elseif block.type == "heading" then
      html = html .. "<h" .. block.level .. ">" .. renderInline(block.body) .. "</h" .. block.level .. ">"
    elseif block.type == "blockquote" then
      html = html .. "<blockquote>" .. renderInline(block.body) .. "</blockquote>"
    elseif block.type == "thematic_break" then
      html = html .. "<hr>"
    end
  end

  return html

end