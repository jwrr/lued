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


g_cut_mode = true
function lued.cut_or_del_sel(cut_mode,dd)
  if cut_mode then
    lued.global_cut(dd)
  else
    lued.del_sel(dd)
  end
end


function lued.cut_or_del_sof(cut_mode, dd)
  local dd2 = 1
  lued.sel_sof(dd2)
  set_sel_end()
  lued.cut_or_del_sel(cut_mode, dd)
end


function lued.del_sof(dd)
  lued.cut_or_del_sof(false,dd)
end


function lued.cut_sof(dd)
  lued.cut_or_del_sof(true,dd)
end


function lued.cut_or_del_eof(cut_mode, dd)
  local dd2 = 1
  lued.sel_eof(dd2)
  set_sel_end()
  lued.cut_or_del_sel(cut_mode, dd)
end


function lued.del_eof(dd)
  lued.cut_or_del_eof(false, dd)
end


function lued.cut_eof(dd)
  lued.cut_or_del_eof(true, dd)
end


function lued.cut_or_del_all(cut_mode, dd)
  local dd2 = 1
  lued.sel_all(dd2)
  lued.cut_or_del_sel(cut_mode, dd)
end
lued.del_all = function(dd) return lued.cut_or_del_all(false, dd) end
lued.cut_all = function (dd) return lued.cut_or_del_all(true, dd) end


function lued.cut_or_del_next(cut_mode, str, dd)
  local dd2 = 1
  local same_keystroke = lued.same_keystroke()
  local str = same_keystroke and g_find_str or ""
  local r1,c1 = get_cur_pos()
  if not  lued.find_forward(str,dd2) then return false end
  local r2,c2 = get_cur_pos()
  lued.sel_range(r1,c1,r2,c2)
  set_sel_end()
  lued.cut_or_del_sel(cut_mode,dd2)
  lued.disp(dd)
  return true
end
lued.del_next = function(str, dd) return lued.cut_or_del_next(false, str, dd) end
lued.cut_next = function(str, dd) return lued.cut_or_del_next(true, str, dd) end

function lued.cut_or_del_char(cut_mode,n,dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  if is_sel_off()==1 then
    set_sel_start()
    n = n or 1
    lued.move_right_n_char(n, dd2)
    set_sel_end()
    set_cur_pos(r,c)
    lued.cut_or_del_sel(cut_mode, dd)
  else
    set_sel_end()
    lued.cut_or_del_sel(cut_mode, dd)
  end
end
lued.del_char = function(n,dd) return lued.cut_or_del_char(false, n, dd) end
lued.cut_char = function(n,dd) return lued.cut_or_del_char(true, n, dd) end


function lued.cut_or_del_sow(cut_mode, dd)
  local dd2 = 1
  lued.sel_sow(dd2)
  lued.del_sel(dd2)
  if lued.is_space() then
    lued.sel_sow(dd2)
    lued.cut_or_del_sel(cut_mode, dd2)
  end
  lued.disp(dd)
end
lued.del_sow = function(dd) return lued.cut_or_del_sow(false, dd) end
lued.cut_sow = function(dd) return lued.cut_or_del_sow(true, dd) end


function lued.cut_or_del_eow(cut_mode, dd)
  local dd2 = 1
  lued.sel_eow(dd2)
  lued.del_sel(dd2)
  if lued.is_space() then
    lued.sel_eow(dd2)
    lued.cut_or_del_sel(cut_mode, dd2)
  end
  lued.disp(dd)
end
lued.del_eow = function(dd) return lued.cut_or_del_eow(false, dd) end
lued.cut_eow = function(dd) return lued.cut_or_del_eow(true, dd) end


function lued.cut_del_spaces(cut_mode, dd)
  local dd2 = 1
  if not lued.is_space() then
    lued.disp(dd)
    return
  end
  set_sel_start()
  lued.skip_spaces(dd2)
  set_sel_end()
  lued.cut_or_del_sel(cut_mode, dd)
end
lued.del_spaces = function(dd) return lued.cut_del_spaces(false, dd) end
lued.cut_spaces = function(dd) return lued.cut_del_spaces(true, dd) end


-- Remove spaces from cursor to start of next word.  If cursor is not over a
-- space then go to next line and then delete the spaces.
function lued.cut_or_del_spaces_next_line(cut_mode, dd)
  local dd2 = 1
  if not lued.is_space() then
    lued.move_down(dd2)
  end
  local r,c = get_cur_pos()
  set_sel_start()
  lued.skip_spaces(dd2)
  set_sel_end()
--  set_cur_pos(r,c)
  lued.cut_or_del_sel(cut_mode, dd)
end
lued.del_spaces_next_line = function(dd) return lued.cut_or_del_spaces_next_line(false, dd)  end
lued.cut_spaces_next_line = function(dd) return lued.cut_or_del_spaces_next_line(true, dd) end


function lued.del_spaces_selected(dd)
  lued.foreach_selected(lued.del_spaces_next_line, dd)
end


function lued.cut_spaces_selected(dd)
  lued.foreach_selected(lued.cut_spaces_next_line, dd)
end


function lued.cut_or_del_word(cut_mode, dd)
  local dd2 = 1
  if lued.is_word() then
    lued.sel_word(dd2)
    set_sel_end()
    lued.cut_or_del_sel(cut_mode, dd)
  else
    while not lued.is_word() do
      lued.del_char(1,dd2)
    end
    lued.disp(dd)
  end
end
lued.del_word = function(dd) return lued.cut_or_del_word(false, dd) end
lued.cut_word = function(dd) return lued.cut_or_del_word(true, dd) end


function lued.cut_or_del_eol(cut_mode, dd)
  local dd2 = 1
  if lued.is_eol() then
    lued.move_down(dd2)
  end
  if not lued.is_eol() then
    lued.sel_eol(dd2)
    set_sel_end()
    lued.cut_or_del_sel(cut_mode, dd2)
  end
  lued.disp(dd)
end
lued.del_eol = function(dd) return lued.cut_or_del_eol(false, dd) end
lued.cut_eol = function(dd) return lued.cut_or_del_eol(true, dd) end


function lued.del_eol_selected(dd)
  lued.foreach_selected(lued.del_eol, dd)
end


function lued.cut_eol_selected(dd)
  lued.foreach_selected(lued.cut_eol, dd)
end


function lued.cut_or_del_sol(cut_mode, dd)
  local dd2 = 1
  if lued.is_sof() then
    lued.disp(dd2)
  elseif lued.is_sol() then
    lued.del_backspace(1,dd2)
  else
    lued.sel_sol(dd2)
    set_sel_end()
    lued.cut_or_del_sel(cut_mode,dd2)
  end
  lued.disp(dd)
end
lued.del_sol = function(dd) return lued.cut_or_del_sol(false, dd) end
lued.cut_sol = function(dd) return lued.cut_or_del_sol(true, dd) end


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
    lued.del_sel(dd2)
  else
    lued.del_sel(dd2)
  end
  g_cut_line_command_count = g_command_count
  lued.disp(dd)
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


function lued.del_n_lines_plus1(n,dd)
  n = n or 1
  n = n + 1
  lued.del_n_lines(n, dd)  
end

function lued.del_n_char(n,dd)
  n = n or 1
  lued.del_char(n,dd)
end


function lued.cut_line(n,dd)
  n = n or 1
  local dd2 = 1
  local r,c = get_cur_pos()
  set_cur_pos(r,1)
  set_sel_start()
  if lued.is_lastline() then
    lued.move_to_eol(dd2)
  else
    lued.move_down_n_lines(n,dd2)
  end
  set_sel_end()
  if (lued.same_keystroke()) then
    lued.global_cut_append(dd2)
  else
    lued.global_cut(dd2)
  end
  g_cut_line_command_count = g_command_count
  lued.disp(dd)
end

function lued.cut_sel_or_line(dd)
  if lued.is_sel_on() then
    return lued.global_cut(dd)
  else
    return lued.cut_line(1,dd)
  end
end


function lued.cut_ot_del_backspace(cut_mode, n, dd)
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
    lued.cut_or_del_sel(cut_mode, dd)
  else
    set_sel_end()
    lued.cut_or_del_sel(cut_mode, dd)
  end
end


function lued.del_backspace(n,dd)
  return lued.cut_ot_del_backspace(false, n, dd)
end


function lued.del_backspace2(dd)
  local num_to_delete = 1
  local r, c = get_cur_pos()
  local indent_len = lued.get_indent_len()
  if c > 1 and indent_len >= c-1 then
    local gis = lued.get_global_indent_size()
    local indent_level = math.floor( (c-1) / gis)
    local new_indent_level = indent_level
    local mod = math.fmod(c-1, gis)
    local on_indent_boundary = mod == 0 
    if on_indent_boundary then
      new_indent_level = new_indent_level - 1
    end
    local new_c = new_indent_level * gis + 1
    num_to_delete = c - new_c
  end
  lued.del_backspace(num_to_delete, dd)
end


function lued.cut_backspace(n,dd)
  return lued.cut_ot_del_backspace(true, n, dd)
end


-- lued.del_backspace = function(n,dd) return lued.cut_ot_del_backspace(false, n, dd) end
-- lued.cut_backspace = function(n,dd) return lued.cut_ot_del_backspace(true, n, dd) end


function lued.cut_or_del_backword(cut_mode, n, dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  set_sel_start()
  lued.move_left_n_words(n,dd2)
  set_sel_end()
  set_cur_pos(r,c)
  lued.cut_or_del_sel(cut_mode,dd)
end
lued.del_backword = function(n,dd) return lued.cut_or_del_backword(false, n, dd) end
lued.cut_backword = function(n,dd) return lued.cut_or_del_backword(true, n, dd) end





