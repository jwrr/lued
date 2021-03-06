

function slurp_file_into_array(filename)
  local file = io.open(filename, "r")
  local line_array = {}
  for line in file:lines() do
    line_array[#line_array+1] = line
  end
  file:close()
  return line_array
end


function line_starts_with(line,str)
  return string.sub(line,1,#str) == str
end


function format_lines(line_array)

  print [[
---
layout: page
title: Lued Key Bindings 
permalink: /bindings/
---

Key bindings are defined in <code>lued/lua_src/bindings/lued_bindings.lua</code>.
This is fairly straight-forward, easily understandable Lua code.  You are 
encouraged to modify the bindings to suite your style. You don't need Lua 
knowledge to figure out what to do.

Do not edit this file.  It is auto-generated from the `lued_bindings.lua` file by 
the `PUBLISH_BINDINGS` script.

* TOC
{:toc}

  ]]
  
  local section_count = 0
  for i=1,#line_array do
    local l = line_array[i]
    if line_starts_with(l,"--#") then
      l = string.sub(l, 3, #l) -- remove first two char (start of comment)
      if section_count > 0 then
        print("</table>")
      end
      section_count = section_count + 1
      print(l)
      print("<table>")
    elseif line_starts_with(l, "ctrl") or line_starts_with(l, "alt") then
      l = string.gsub(l, "^ctrl_", "<kbd>Ctrl+")
      l = string.gsub(l, "^alt_", "<kbd>Alt+")
      l = string.gsub(l, "_period_", ".")
      l = string.gsub(l, "_at_", "@")
      l = string.gsub(l, "_equal_", "=")
      l = string.gsub(l, "_plus_", "+")
      l = string.gsub(l, "_gt_", ">")
      l = string.gsub(l, "_lt_", "<")
      l = string.gsub(l, "_caret_", "^")
      l = string.gsub(l, "_dollar_", "$")
      l = string.gsub(l, "_slash_", "//")
      l = string.gsub(l, "_colon_", ":")
      l = string.gsub(l, "_plus_", "+")
      l = string.gsub(l, "%s*=.*[-][-]%s*", "</kbd></td><td>")
      print("<tr><td>"..l.." </td></tr>")
    end
  end
  
  print "</table>"
end



filename = "lued_bindings.lua"

local line_array = slurp_file_into_array(filename)

format_lines(line_array)

