-- html.lua

snips['html'] = {}

-- snips["html"]["tags"] = "a b c d"
snips.html.tags = string.gsub([[
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

-- dbg_prompt("tags=".. snips['html']['tags'] )


snips.html.html5_template = [[
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Document</title>
</head>
<body>
    
</body>
</html>
]]

find = function(haystack, plain_text)
  return string.find(" "..haystack.." ", " "..plain_text.." ", 1, plain)
end

snips.html.main = function(ss) -- ss = snippet string

  
--   start_pos end_pos = string.find(ss, "^[%w:])
  
  
  if find("html html:5 !", ss) then
    ins_str(snips.html.html5_template)
    move_to_first_line()
    find_forward("Document")
  elseif find("br hr" , ss) then
    ins_str('<'..ss.."/>")
  elseif find("a", ss) then
    ins_str('<a href="#">text</a>')
    move_to_sol()
    find_forward('#')
  elseif find( snips.html.tags, ss) then
    ins_str('<'..ss.."></"..ss..">")
    move_left_n_char( ss:len()+3)
  else
    ins_str(ss)
  end
  return true
end



