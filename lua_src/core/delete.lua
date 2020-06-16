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


function lued.del_sel(dd)
  delete_selected()
  lued.disp(dd)
end


function lued.del_sof(dd)
  local dd2 = 1
  lued.sel_sof(dd2)
  set_sel_end()
  lued.del_sel(dd)
end


function lued.cut_sof(dd)
  local dd2 = 1
  lued.sel_sof(dd2)
  set_sel_end()
  lued.global_cut(dd)
end


function lued.del_eof(dd)
  local dd2 = 1
  lued.sel_eof(dd2)
  set_sel_end()
  lued.del_sel(dd)
end


function lued.cut_eof(dd)
  local dd2 = 1
  lued.sel_eof(dd2)
  set_sel_end()
  lued.global_cut(dd)
end


function lued.del_all(dd)
  local dd2 = 1
  lued.sel_all(dd2)
  lued.del_sel(dd)
end


function lued.cut_all(dd)
  local dd2 = 1
  lued.sel_all(dd2)
  lued.global_cut(dd)
end

g_cut_mode = true


function lued.cut_or_del_sel(cut_mode,dd)
  if cut_mode then
    lued.global_cut(dd)
  else
    lued.del_sel(dd)
  end
end

function lued.cut_or_del_next(str, cut_mode, dd)
  local dd2 = 1
  local same_keystroke = lued.same_keystroke()
  local str = same_keystroke and g_find_str or ""
  local r1,c1 = get_cur_pos()
  if lued.find_forward(str,dd2) then
    local r2,c2 = get_cur_pos()
    lued.sel(r1,c1,r2,c2)
    set_sel_end()
    lued.cut_or_del_sel(cut_mode,dd2)
  end
  lued.disp(dd)
end

function lued.del_next(str, dd)
  lued.cut_or_del_next(str,false,dd)
end


function lued.cut_next(str, dd)
  lued.cut_or_del_next(str,true,dd)
end


function lued.del_char(n,dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  if is_sel_off()==1 then
    set_sel_start()
    n = n or 1
    lued.move_right_n_char(n, dd2)
    set_sel_end()
    set_cur_pos(r,c)
    lued.del_sel(dd)
  else
    set_sel_end()
    lued.del_sel(dd)
  end
end


function lued.cut_char(n,dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  if is_sel_off()==1 then
    set_sel_start()
    n = n or 1
    lued.move_right_n_char(n, dd2)
    set_sel_end()
    set_cur_pos(r,c)
    lued.global_cut(dd)
  else
    set_sel_end()
    lued.global_cut(dd)
  end
end


function lued.del_sow(dd)
  local dd2 = 1
  lued.sel_sow(dd2)
  lued.del_sel(dd2)
  if lued.is_space() then
    lued.sel_sow(dd2)
    lued.del_sel(dd2)
  end
  lued.disp(dd)
end


function lued.cut_sow(dd)
  local dd2 = 1
  lued.sel_sow(dd2)
  lued.global_cut(dd2)
  if lued.is_space() then
    lued.sel_sow(dd2)
    lued.del_sel(dd2)
  end
  lued.disp(dd)
end


function lued.del_eow(dd)
  local dd2 = 1
  lued.sel_eow(dd2)
  lued.del_sel(dd2)
  if lued.is_space() then
    lued.sel_eow(dd2)
    lued.del_sel(dd2)
  end
  lued.disp(dd)
end


function lued.cut_eow(dd)
  local dd2 = 1
  lued.sel_eow(dd2)
  lued.global_cut(dd2)
  if lued.is_space() then
    lued.sel_eow(dd2)
    lued.del_sel(dd2)
  end
  lued.disp(dd)
end


function lued.del_spaces(dd)
  local dd2 = 1
  if not lued.is_space() then
    lued.disp(dd)
    return
  end
  set_sel_start()
  lued.skip_spaces(dd2)
  set_sel_end()
  lued.del_sel(dd)
end


function lued.cut_spaces(dd)
  local dd2 = 1
  if not lued.is_space() then
    lued.disp(dd)
    return
  end
  set_sel_start()
  lued.skip_spaces(dd2)
  set_sel_end()
  lued.global_cut(dd)
end


-- Remove spaces from cursor to start of next word.  If cursor is not over a
-- space then go to next line and then delete the spaces.
function lued.del_spaces_next_line(dd)
  local dd2 = 1
  if not lued.is_space() then
    lued.move_down(dd2)
  end
  local r,c = get_cur_pos()
  set_sel_start()
  lued.skip_spaces(dd2)
  set_sel_end()
--  set_cur_pos(r,c)
  lued.del_sel(dd)
end


function lued.cut_spaces_next_line(dd)
  local dd2 = 1
  if not lued.is_space() then
    lued.move_down(dd2)
  end
  local r,c = get_cur_pos()
  set_sel_start()
  lued.skip_spaces(dd2)
  set_sel_end()
--  set_cur_pos(r,c)
  lued.global_cut(dd)
end


function lued.del_spaces_selected(dd)
  lued.foreach_selected(lued.del_spaces_next_line, dd)
end


function lued.cut_spaces_selected(dd)
  lued.foreach_selected(lued.cut_spaces_next_line, dd)
end


function lued.del_word(n,dd)
  local dd2 = 1
  if lued.is_word() then
    lued.sel_word(dd2)
    set_sel_end()
    lued.del_sel(dd)
  else
    while not lued.is_word() do
      lued.del_char(1,dd2)
    end
    lued.disp(dd)
  end
end


function lued.cut_word(n,dd)
  local dd2 = 1
  if lued.is_word() then
    lued.sel_word(dd2)
    set_sel_end()
    lued.global_cut(dd)
  else
    while not lued.is_word() do
      lued.del_char(1,dd2)
    end
    lued.disp(dd)
  end
end


function lued.del_eol(dd)
  local dd2 = 1
  if lued.is_eol() then
    lued.move_down(dd2)
  end
  if not lued.is_eol() then
    lued.sel_eol(dd2)
    set_sel_end()
    lued.del_sel(dd2)
  end
  lued.disp(dd)
end


function lued.cut_eol(dd)
  local dd2 = 1
  if lued.is_eol() then
    lued.move_down(dd2)
  end
  if not lued.is_eol() then
    lued.sel_eol(dd2)
    set_sel_end()
    lued.global_cut(dd2)
  end
  lued.disp(dd)
end


function lued.del_eol_selected(dd)
  lued.foreach_selected(lued.del_eol, dd)
end


function lued.cut_eol_selected(dd)
  lued.foreach_selected(lued.cut_eol, dd)
end


function lued.del_sol(dd)
  local dd2 = 1
  if lued.is_sof() then
    lued.disp(dd)
  elseif lued.is_sol() then
    lued.del_backspace(1,dd)
  else
    lued.sel_sol(dd2)
    set_sel_end()
    lued.del_sel(dd)
  end
end


function lued.cut_sol(dd)
  local dd2 = 1
  if lued.is_sof() then
    lued.disp(dd)
  elseif lued.is_sol() then
    lued.del_backspace(1,dd)
  else
    lued.sel_sol(dd2)
    set_sel_end()
    lued.global_cut(dd)
  end
end


function lued.del_line(n,dd)
  n = n or 1
  local dd2 = 1
  local r,c = get_cur_pos()
  set_cur_pos(r,1)
  set_sel_start()
  lued.move_down_n_lines(n,dd2)
  set_sel_end()
--   if (g_command_count == g_cut_line_command_count) then
  if (lued.same_keystroke()) then
    lued.global_cut_append(dd2)
  else
    lued.del_sel(dd2)
  end
  g_cut_line_command_count = g_command_count
  lued.disp(dd)
end


function lued.cut_line(n,dd)
  n = n or 1
  local dd2 = 1
  local r,c = get_cur_pos()
  set_cur_pos(r,1)
  set_sel_start()
  lued.move_down_n_lines(n,dd2)
  set_sel_end()
  if (lued.same_keystroke()) then
    lued.global_cut_append(dd2)
  else
    lued.global_cut(dd2)
  end
  g_cut_line_command_count = g_command_count
  lued.disp(dd)
end


function lued.del_backspace(n,dd)
  local dd2 = 1
  if lued.is_sof() then
    lued.disp(dd)
  elseif is_sel_off()==1 then
    n = n or 1
    local r,c = get_cur_pos()
    lued.move_left_n_char(n, dd2)
    set_sel_start()
    set_cur_pos(r,c)
    set_sel_end()
    lued.del_sel(dd)
  else
    set_sel_end()
    lued.del_sel(dd)
  end
end


function lued.cut_backspace(n,dd)
  local dd2 = 1
  if lued.is_sof() then
    lued.disp(dd)
  elseif is_sel_off()==1 then
    n = n or 1
    local r,c = get_cur_pos()
    lued.move_left_n_char(n, dd2)
    set_sel_start()
    set_cur_pos(r,c)
    set_sel_end()
    lued.del_sel(dd)
  else
    set_sel_end()
    lued.cut(dd)
  end
end


function lued.del_backword(n,dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  set_sel_start()
  lued.move_left_n_words(n,dd2)
  set_sel_end()
  set_cur_pos(r,c)
  lued.del_sel(dd)
end


function lued.cut_backword(n,dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  set_sel_start()
  lued.move_left_n_words(n,dd2)
  set_sel_end()
  set_cur_pos(r,c)
  lued.global_cut(dd)
end




