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


function lued.clr_abs_line_numbers(dd)
  local dd2 = 1
  if g_show_rel_line_numbers then
    lued.clr_rel_line_numbers(dd2)
  end
  g_show_abs_line_numbers = false
  set_show_line_numbers(0)
  lued.disp(dd)
end

function lued.set_abs_line_numbers(dd)
  local dd2 = 1
  if g_show_abs_line_numbers then
    lued.clr_abs_line_numbers(dd2)
    lued.set_rel_line_numbers(dd)
    return
  end
  g_show_abs_line_numbers = true
  set_show_line_numbers(0)
  lued.disp(dd)
end


function lued.clr_rel_line_numbers(dd)
  g_show_rel_line_numbers = false
  set_show_line_numbers(0)
  lued.disp(dd)
end


function lued.set_rel_line_numbers(dd)
  local dd2 = 1
  lued.clr_abs_line_numbers(dd2)
  g_show_rel_line_numbers = true
  set_show_line_numbers(0)
  lued.disp(dd)
end


function lued.insert_line_numbers_orig(text)
  linenum,col = get_cur_pos()

  -- replace every newline except for the last
  return  string.gsub (text, "\n.", function (str)
           g_lnum = g_lnum + 1
           local linenum = get_cur_pos()
           local esc_bold = ""
           if g_bold_current_line then
             esc_bold = lued.make_line_bold_orig(linenum,g_lnum)
           end
           local esc_normal = string.char(27).."[0m"
           if g_show_abs_line_numbers then
             return string.format(esc_normal .. str .. esc_bold .. "%4d: ", g_lnum)
           else
             return string.format(esc_normal .. str .. esc_bold)
           end
         end )
end




