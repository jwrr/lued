--[[
MIT License

Copyright (c) 2018 JWRR.COM

git clone https://github.com/jwrr/lued.git

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]


function lued.clr_sb_files(dd)
  g_show_sb_files = false
  set_show_line_numbers(0)
  lued.disp(dd)
end


function lued.set_sb_files(dd)
  g_show_sb_files = true
  set_show_line_numbers(0)
  lued.disp(dd)
end


function lued.sidebar(lines)
  local found, files = lued.select_tab_menu(nil,true) 
  local files_str = files[ii] or ""
  local sb_file_width = 20
  files_str = string.sub(files_str, 1, sb_file_width)
  files_str = files_str .. string.rep(" ",sb_file_width-#files_str) .. " | "
  local styles = styles or {}
  local style = styles.sb_files or ""
  local rst = styles.reset or ""
  lines[ii] = style .. files_str .. rst .. lines[ii]
  return lines
end


