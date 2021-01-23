-- html.lua

lued.html = lued.html or {}

local keyword_str = string.gsub([[
 a abbr acronym address applet area article aside audio b  
 base basefont bb bdo big blockquote body button canvas 
 caption center  cite code col colgroup command datagrid 
 datalist dd del details dfn dialog dir div dl dt  em 
 embed eventsource fieldset figcaption figure font footer 
 form frame frameset h1 h2 h3 h4 h5 h6 head header  
 hgroup html i iframe img input ins isindex kbd keygen 
 label legend li link map mark menu meta meter nav 
 noframes noscript object ol optgroup option output p 
 param pre progress q rp rt ruby s samp script section 
 select small source span strike strong style sub sup 
 table tbody td textarea tfoot th thead time title tr 
 track tt u ul var video wbr 
]] , "%s+", " ")

lued.keywords.html = lued.explode_keys(keyword_str, " ")


function lued.html.html5()
str = [[
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>NAME</title>
  <link rel="stylesheet" type="text/css" href="SSS.css">
</head>
<body>
  HI
</body>
</html>
]]
lued.ins_str_after(str, "NAME" , 0, 1)

end -- lued.html.html5


function lued.html.self_closing(tag)
  lued.ins_str('<'..tag.."/>")  
end

function lued.html.anchor(tag)
  local link = "#"
  if tag == "ah" then
    link = "http://"
  elseif tag == "as" or tag == "ahs" then
    link = "https://"
  end
  lued.ins_str_after('<a href="' .. link .. '">hi</a>', link)
end

function lued.html.tag(t)
  lued.ins_str_after('<'..t..">TEXT</"..t..">", "TEXT")
end


-- ============================================================================

lued.filetypes.html = "html"
lued.filetypes.htm  = "html"
lued.filetypes.markdown  = "html"
lued.filetypes.md   = "html"

lued.def_snippet(lued.snippets.html, keyword_str  , lued.html.tag)
lued.def_snippet(lued.snippets.html, "html html5 !"  , lued.html.html5)
lued.def_snippet(lued.snippets.html, "br hr"         , lued.html.self_closing)
lued.def_snippet(lued.snippets.html, "a"             , lued.html.anchor)
lued.def_snippet(lued.snippets.html, "ah"            , lued.html.anchor)
lued.def_snippet(lued.snippets.html, "ahs as"        , lued.html.anchor)

