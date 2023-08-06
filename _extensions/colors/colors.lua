local colors = {}
local bgColors = {}

local function setupColors(meta)
  if meta['colors'] then
    colors = meta['colors']
    
    if quarto.doc.is_format("pdf") then
      quarto.doc.use_latex_package("xcolor", "")
      
      for key, tbl in pairs(colors) do
        quarto.doc.include_text("in-header", "\\definecolor{" .. key ..
          "}{HTML}{" .. string.sub(pandoc.utils.stringify(tbl), 2) .. "}")
      end
    end
  end
  
  if meta['bg-colors'] then
    bgColors = meta['bg-colors']
    
    if quarto.doc.is_format("pdf") then
      quarto.doc.use_latex_package("xcolor", "")
      
      for key, tbl in pairs(bgColors) do
        quarto.doc.include_text("in-header", "\\definecolor{" .. key ..
          "}{HTML}{" .. string.sub(pandoc.utils.stringify(tbl), 2) .. "}")
      end
    end
  end
end

local function writeColors(el)
  local colorHead = ""
  local colorTail = ""
  local bgColorHead = ""
  local bgColorTail = ""
  
  for key, tbl in pairs(colors) do
    if el.attr.classes:includes(key) then
      if quarto.doc.is_format("html") then
        colorHead = pandoc.RawInline('html', '<span style="color:' .. pandoc.utils.stringify(tbl) .. '">')
        colorTail = pandoc.RawInline('html', '</span>')
      end
      
      if quarto.doc.is_format("pdf") then
        colorHead = pandoc.RawInline('latex', '\\textcolor{' .. pandoc.utils.stringify(key) .. '}{')
        colorTail = pandoc.RawInline('latex', '}')
      end
    end
  end
  
  for key, tbl in pairs(bgColors) do
    if el.attr.classes:includes(key) then
      if quarto.doc.is_format("html") then
        bgColorHead = pandoc.RawInline('html', '<span style="color:' .. pandoc.utils.stringify(tbl) .. '">')
        bgColorTail = pandoc.RawInline('html', '</span>')
      end
      
      if quarto.doc.is_format("pdf") then
        bgColorHead = pandoc.RawInline('latex', '\\colorbox{' .. pandoc.utils.stringify(key) .. '}{')
        bgColorTail = pandoc.RawInline('latex', '}')
      end
    end
  end
  
  return pandoc.Inlines{bgColorHead, colorHead, pandoc.Span(el.content), colorTail, bgColorTail}
end

return {
  {Meta = setupColors},
  {Span = writeColors}
}