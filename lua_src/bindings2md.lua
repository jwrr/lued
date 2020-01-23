

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
  print "<table>"
  print "<tr><th>Key Binding</th><th>Description</th></tr>"
  
  local section_count = 0
  for i=1,#line_array do
    local l = line_array[i]
    if line_starts_with(l,"--#") then
      l = string.sub(l, 3, #l) -- remove first two char (start of comment)
      if section_count > 0 then
        print("<\table>")
      end
      section_count = section_count + 1
      print(l)
      print("<table>")
    elseif line_starts_with(l, "ctrl") or line_starts_with(l, "alt") then
      l = string.gsub(l, "ctrl_", "`K'Ctrl+")
      l = string.gsub(l, "alt_", "`K'Alt+")
      l = string.gsub(l, "%s*=[^-]*[-][-]%s*", "</td><td>")
      print("<tr><td>"..l.."</td></tr>")
    end
  end
  
  print "</table>"
end



filename = "lued_bindings.lua"
print ("hello")

local line_array = slurp_file_into_array(filename)

format_lines(line_array)

