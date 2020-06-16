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


function lued.cut(dd)
  if is_sel_off()==1 then
    lued.disp(dd)
  else
    set_paste()
    lued.del_sel(dd)
  end
end


function lued.copy(dd)
  if is_sel_off()==1 then
    g_ctrl_c_count = g_ctrl_c_count or 0
    g_ctrl_c_count = g_ctrl_c_count+1
    if (g_ctrl_c_count >= g_ctrl_c_max) then
      local force = true
      lued.quit_all(force,1)
    end
    lued.disp(dd)
  else
    g_ctrl_c_count = 0
    set_sel_end()
    set_paste()
    set_sel_off()
    lued.disp(dd)
  end
end


function lued.set_paste_buffer(str,dd)
  set_paste(str)
  lued.disp(dd)
end


function lued.paste(dd)
  local dd2 = 1
  local auto_indent_save = g_auto_indent
  g_auto_indent = false
  lued.del_sel(dd2)
  local pb = get_paste()
  ins_str(pb, dd)
  g_auto_indent = auto_indent_save
end


function lued.global_cut(dd)
  lued.cut(dd)
  lued.g_buffer = get_paste()
  lued.disp(dd)
end


function lued.global_cut_append(dd)
  lued.cut(dd)
  lued.g_buffer = lued.g_buffer .. get_paste()
  lued.disp(dd)
end


function lued.global_copy(dd)
  local dd2 = 1
  lued.copy(dd2)
  lued.g_buffer = get_paste()
  lued.disp(dd)
end


function lued.global_paste(dd)
  local dd2 = 1
  if string.find(lued.g_buffer,"\n") then
    lued.move_to_sol_classic(dd2)
--     local spaces = string.match(lued.g_buffer, "^%w*")
--     spaces = spaces or ""
--     lued.g_buffer = string.gsub(lued.g_buffer,"^%s*","")
--     lued.g_buffer = string.gsub(lued.g_buffer,"\n"..spaces,"\n")
  end
  set_paste(lued.g_buffer)
  lued.paste(dd2)
  lued.disp(dd)
end


function lued.copy_word(dd)
  local dd2 = 1
  lued.sel_word(dd2)
  lued.global_copy(dd)
end


function lued.copy_sol(dd)
  local dd2 = 1
  local r1,c1 = get_cur_pos()
  lued.move_to_sol(dd2)
  set_sel_start()
  set_cur_pos(r1,c1)
  lued.global_copy(dd)
end


function lued.copy_eol(dd)
  local dd2 = 1
  local r1,c1 = get_cur_pos()
  set_sel_start()
  lued.move_to_eol(dd2)
  lued.global_copy(dd2)
  set_cur_pos(r1,c1)
  lued.disp(dd)
end


function lued.copy_line(n,dd)
  n = n or 1
  local dd2 = 1
  if is_sel_off()==1 then
    lued.move_to_sol_classic(dd2)
    local r1,c1 = get_cur_pos()
    set_sel_start()
    lued.move_down_n_lines(n,dd)
    local r2,c2 = get_cur_pos()
--    set_sel_end()
    lued.global_copy(dd)
--    lued.move_to_sol_classic(dd)
  else
    lued.global_copy(dd)
  end
end


function lued.del_n_lines(n,dd)
  n = n or 1
  local dd2 = 1
  if is_sel_off()==1 then
    lued.del_line(n,dd)
  else
    lued.del_sel(dd)
  end
end


function lued.cut_n_lines(n,dd)
  n = n or 1
  local dd2 = 1
  if is_sel_off()==1 then
    lued.del_line(n,dd)
  else
    lued.global_cut(dd)
  end
end


function lued.cut_line(dd)
  return lued.cut_n_lines(1,dd)
end


function lued.duplicate_n_lines(n,dd)
  local dd2 = 1
  lued.cut_n_lines(n,dd2)
  lued.global_paste(dd2)
  lued.global_paste(dd2)
  lued.move_up_n_lines(n,dd)
end


function lued.duplicate_line(dd)
  return lued.duplicate_n_lines(dd)
end

function lued.paste_line_before(dd)
  local dd2 = 1
  lued.move_to_sol_classic(dd2)
  lued.global_paste(dd)
end


function lued.paste_line_after(dd)
  local dd2 = 1
  lued.move_down_n_lines(dd2)
  lued.paste_line_before(dd2)
  lued.move_up_n_lines(dd)
end





