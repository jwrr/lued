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


function lued.is_sel_on()
  return not (is_sel_off()==1)
end


function lued.get_sel_str()
  local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
  local sel_str = ""
  if sel_state~=0 then
    sel_str = get_str(sel_sr,sel_sc,sel_er,sel_ec)
  end
  return sel_str, sel_sr, sel_sc, sel_er, sel_ec
end


function lued.sel_n_char(n,dd)
  n = n or 1
  set_sel_start()
  lued.move_right_n_char(n, dd)
end


function lued.word_start(dd)
  local r,c = get_cur_pos()
  local line = get_line()
  if lued.is_space(line,c) then
    lued.move_right_n_words(1,dd)
  elseif not lued.is_sow(line,c) then
    lued.move_left_n_words(1,dd)
  else
    lued.disp(dd)
  end
end


function lued.var_start(dd)
  local r,c = get_cur_pos()
  local line = get_line()
  local len = get_line_len()
  local c2 = string.find(line, "[%w_]", c) -- find space after end of word
  local c3 = c2 and c2 or len
  set_cur_pos(r, c3)
  lued.disp(dd)
end


function lued.line_contains(needles, line)
  local line = line or get_line() or ""
  local found = false
  if needles then
    for i=1,#needles do
      if string.find(line, needles[i], 1, true)~=nil then
        found = true
        break
      end
    end
  end
  return found
end


function lued.line_ends_with(needles, line)
  local line = line or get_line() or ""
  local found = false
  if needles then
    for i=1,#needles do
      if string.find(line, needles[i] .. "%s*$", 1, false)~=nil then
        found = true
        break
      end
    end
  end
  return found
end


function lued.sel_range(r1,c1,r2,c2)
  if not (r1 and c1 and r2 and c2) then return end
  local r,c= get_cur_pos()
  set_sel_off()
  set_cur_pos(r1,c1)
  set_sel_start()
  set_cur_pos(r2,c2)
end

function lued.sel_word(dd)
  local dd2 = 1

  local partial = false
  if lued.is_sel_on() then
    local r,c = get_cur_pos()
    local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
    set_cur_pos(sel_sr,sel_sc)
    partial = lued.is_word() and lued.prev_is_word()
    if not partial then
      set_cur_pos(sel_er,sel_ec)
      partial = lued.is_word() and lued.prev_is_word()
    end
    set_cur_pos(r,c)
  end

  if partial or is_sel_off()==1 then
    lued.word_start(dd2)
    lued.var_start(dd2)
    set_sel_start()
  else
    if lued.is_blankline() then
      lued.move_down(dd2)
    end
    lued.move_right_n_words(1, dd2)
  end
  lued.skip_variable(dd2)
  lued.disp(dd)
end


function lued.sel_line(n,dd)
  n = n or 1
  local dd2 = 1
  local r,c = get_cur_pos()
  local rlast = r + n
  if c ~= 1 or not lued.is_sel_on() then
    set_cur_pos(r,1)
    set_sel_start()
  end
  if rlast < get_numlines() then    
    set_cur_pos(rlast,1)
  else
    lued.move_to_last_line(dd2)
    lued.move_to_eol(dd2)
  end
  lued.disp(dd)
end


function lued.sel_inside_braces(dd)
  local dd2 = 1
  local save_find_str = g_find_str
  set_sel_off()

  g_find_str = "}"
  local r,c = get_cur_pos()
  lued.find_forward_again(dd2)
  lued.move_left_n_char(1,dd2)
  local r2,c2 = get_cur_pos()

  g_find_str = "{"
  set_cur_pos(r,c)
  lued.find_reverse_again(dd2)
  lued.move_right_n_char(1,dd2)
  set_sel_start()
  set_cur_pos(r2,c2)
  set_sel_end()

  g_find_str = save_find_str
  lued.disp(dd)
end


function lued.sel_sol(dd)
  local r,c = get_cur_pos()
  set_cur_pos(r,1)
  set_sel_start()
  set_cur_pos(r,c)
  lued.disp(dd)
end


function lued.sel_eol(dd)
  set_sel_start()
  lued.move_to_eol(dd)
end


function lued.sel_sof(dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  lued.move_to_first_line(dd2)
  set_sel_start()
  set_cur_pos(r,c)
  lued.disp(dd)
end


function lued.sel_eof(dd)
  set_sel_start()
  lued.move_to_last_line(dd)
end


function lued.sel_all(dd)
  local dd2 = 1
  lued.move_to_first_line(dd2)
  set_sel_start()
  lued.move_to_last_line(dd2)
  set_sel_end()
  lued.disp(dd)
end


function lued.sel_toggle(dd)
  if is_sel_off()==1 then
    set_sel_start()
  else
    set_sel_off()
  end
  lued.disp(dd)
end




function lued.sel_sow(dd)
  local dd2 = 1
  set_sel_start()
  if lued.is_word(lued.get_char(-1)) then
    while not lued.is_sol() and lued.is_word(lued.get_char(-1)) do
      lued.move_left_n_char(1,dd2)
    end
  elseif lued.is_space(lued.get_char(-1)) then
    while not lued.is_sol() and lued.is_space(lued.get_char(-1)) do
      lued.move_left_n_char(1,dd2)
    end
  elseif lued.is_punct(lued.get_char(-1)) then
    while not lued.is_sol() and lued.is_punct(lued.get_char(-1)) do
      lued.move_left_n_char(1,dd2)
    end
  end
  set_sel_end()
  lued.disp(dd)
end


function lued.sel_left_nonspaces(dd)
  local dd2 = 1
  set_sel_start()
  if not lued.is_space(lued.get_char(-1)) then
    while not lued.is_sol() and not lued.is_space(lued.get_char(-1)) do
      lued.move_left_n_char(1,dd2)
    end
  end
  set_sel_end()
  lued.disp(dd)
end


function lued.sel_left_pattern(pattern , dd)
  local dd2 = 1
  set_sel_start()
  while not lued.is_sol() and lued.is_pattern(pattern , lued.get_char(-1)) do
    lued.move_left_n_char(1,dd2)
  end
  set_sel_end()
  lued.disp(dd)
end


function lued.sel_eow(dd)
  local dd2 = 1
  set_sel_start()
  if lued.is_word() then
    while lued.is_word() and not lued.is_eol() do
      lued.move_right_n_char(1,dd2)
    end
  elseif lued.is_space() then
    while lued.is_space() and not lued.is_eol()  do
      lued.move_right_n_char(1,dd2)
    end
  elseif lued.is_punct() then
    while lued.is_punct() and not lued.is_eol() do
      lued.move_right_n_char(1,dd2)
    end
  else -- other
    while not lued.is_space() and not lued.is_eol() do
      lued.move_right_n_char(1,dd2)
    end
  end
  set_sel_end()
  lued.disp(dd)
end


--  lued.foreach_selected(lued.align_start_of_next_line, dd)
--  lued.foreach_selected(lued.align_delimiter_of_next_line, dd)
--  lued.foreach_selected(lued.del_spaces_next_line, dd)
--  lued.foreach_selected(lued.bubble_line_up,dd)
--  lued.foreach_selected(lued.comment, dd)
--  lued.foreach_selected(lued.uncomment, dd)


function lued.foreach_selected(fn, dd)
  local dd2 = 1
  if lued.is_sel_on() then
    local r,c = get_cur_pos()
    set_sel_off()
    local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
    set_cur_pos(sel_sr,c)
    local r,c = get_cur_pos()
    local r_last = sel_er
    while r<r_last do
      set_cur_pos(r,c)
      fn(dd2)
      r = r + 1
    end
    set_cur_pos(sel_sr,c)
    set_sel_start()
    set_cur_pos(sel_er,c)
  else
    fn(dd2)
  end
  lued.disp(dd)
end


function lued.sel_to_upper(dd)
  local dd2 = 1
  if not lued.is_sel_on() then
    lued.sel_n_char(1,dd2)
    set_sel_end()
  end
  local sel_str, sel_sr, sel_sc = lued.get_sel_str()
  if sel_str ~= "" then
    lued.ins_string(string.upper(sel_str),dd2)
  end
  lued.disp(dd)
end


function lued.sel_to_lower(dd)
  local dd2 = 1
  if not lued.is_sel_on() then
    lued.sel_n_char(1,dd2)
    set_sel_end()
  end
  local sel_str, sel_sr, sel_sc = lued.get_sel_str()
  if sel_str ~= "" then
    lued.ins_string(string.lower(sel_str),dd2)
  end
  lued.disp(dd)
end


function lued.sel_number(dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  local line = get_line()
  local c1 = c
  local c2 = c
  if lued.is_digit( string.sub(line,c,c) ) then
    while lued.is_digit( string.sub(line,c1-1,c1-1) ) do c1 = c1 - 1; end
    while lued.is_digit( string.sub(line,c2+1,c2+1) ) do c2 = c2 + 1; end
    lued.set_sel_from_to(r,c1,r,c2+1,dd2)
  else
    set_sel_off()
  end
end


function lued.set_sel_from_to(sel_sr,sel_sc,sel_er,sel_ec,dd)
  local dd2 = 1
  set_cur_pos(sel_sr,sel_sc)
  set_sel_start()
  set_cur_pos(sel_er,sel_ec)
  set_sel_end()
  lued.disp(dd)
end









