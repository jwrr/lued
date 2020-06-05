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





function lued.move_to(r,c,dd)
  local dd2 = 1
  local r1,c1 = lued.get_cur_pos(dd2)
  r = r or r1
  r = r>0 and r or r1
  c = c or c1
  c = c>0 and c or c1
  lued.set_cur_pos(r,c,dd2)
  lued.disp(dd)
end

function lued.move_left_n_char(n,dd)
  local n_is_nil = n == nil or n == 0
  n = n or 1
  local dd2 = 1
  for i=1,n do
    if lued.is_sof() then break end
    if lued.is_sol() then
      lued.move_up_n_lines(1,dd2)
      if not lued.is_eol() then lued.move_to_eol(dd2) end
    else
      local r,c = get_cur_pos()
      local len = get_line_len()
      c = math.min(c,len+1)
      c = c - 1
      set_cur_pos(r,c)

      if g_double_speed > 0 and n_is_nil then
        if g_command_count == g_move_left_n_char_command_count then
          g_scroll_speed = g_scroll_speed or 0
          set_cur_pos(r,c-g_scroll_speed)
          g_scroll_speed = g_double_speed
        else
          g_scroll_speed = 0
        end
        g_command_count = g_command_count or 1
        g_move_left_n_char_command_count = g_command_count+1
      else
        g_scroll_speed = 0
      end

    end
  end
  lued.disp(dd)
end


function lued.set_move_left_n_char(n,dd)
  g_move_left_n_char = n or g_move_left_n_char
  lued.move_left_n_char(g_move_left_n_char,dd)
end



function lued.move_left_fast(dd)
  if g_express_mode then
    lued.move_left_n_char(g_move_left_n_char,dd)
  else
    lued.move_left_n_char(1,dd)
  end
end


function lued.move_right_n_char(n,dd)
  local n_is_nil = n == nil or n == 0
  n = n or 1
  local dd2 = 1
  for i=1,n do
    if lued.is_eof() then break end
    if lued.is_eol() then
      lued.move_down(dd2)
      lued.move_to_sol_classic(dd2)
    else
      local r,c = get_cur_pos()
      c = c + 1
      set_cur_pos(r,c)

      if g_double_speed > 0 and n_is_nil then
        if g_command_count == g_move_right_n_char_command_count then
          g_scroll_speed = g_scroll_speed or 0
          set_cur_pos(r,c+g_scroll_speed)
          g_scroll_speed = g_double_speed
        else
          g_scroll_speed = 0
        end
        g_command_count = g_command_count or 1
        g_move_right_n_char_command_count = g_command_count+1
      else
        g_scroll_speed = 0
      end

    end
  end
  lued.disp(dd)
end


function lued.move_right_fast(dd)
  if g_express_mode then
    lued.move_right_n_char(g_move_right_n_char,dd)
  else
    lued.move_right_n_char(1,dd)
  end
end


function lued.set_move_right_n_char(n,dd)
  g_move_right_n_char = n or g_move_right_n_char
  lued.move_right_n_char(g_move_right_n_char,dd)
end


function lued.move_halfsy_left(dd)
  local r,c = get_cur_pos()
  g_move_halfsy_right = c
  if g_command_count ~= g_move_halfsy_command_count or g_move_halfsy_left==nil then
    g_move_halfsy_left = 1
  end
  g_command_count = g_command_count or 1
  g_move_halfsy_command_count = g_command_count+1
  local next_c = c - math.ceil( (c-g_move_halfsy_left) / 2)
  set_cur_pos(r,next_c)
  g_move_halfsy_right = c
  lued.disp(dd)
end


function lued.move_halfsy_right(dd)
  local r,c = get_cur_pos()
  local len = get_line_len()
  g_move_halfsy_left = c
  if g_command_count ~= g_move_halfsy_command_count or g_move_halfsy_right==nil then
    g_move_halfsy_right = len+1
  end
  g_command_count = g_command_count or 1
  g_move_halfsy_command_count = g_command_count+1
  local next_c = c + math.ceil( (g_move_halfsy_right-c) / 2)
  set_cur_pos(r,next_c)
  lued.disp(dd)
end


function lued.move_right_n_words(n,dd)
  n = n or 1
  local dd2 = 1
  for i=1,n do
    if lued.is_eol() then
      if not lued.is_eof() then
        lued.move_right_n_char(1,dd2)
      end
    elseif lued.is_word() then
      repeat
        lued.move_right_n_char(1,dd2)
      until lued.is_eol() or not lued.is_word()
    elseif not lued.is_space() then -- misc char
      repeat
        lued.move_right_n_char(1,dd2)
      until lued.is_eol() or lued.is_word() or lued.is_space()
    end
    if not lued.is_eol() then
      lued.skip_spaces_right(dd2)
    end
  end
  lued.disp(dd)
end


function lued.move_right_word(dd)
  return lued.move_right_n_words(1,dd)
end


function lued.move_left_n_words(n,dd)

--   if sof do nothing
--   if sol then move to end of previous line
--   if at start of word goto start of previous word or misc
--   if at start of misc go to start of previous word or misc
--   if in space go to start of previous word or misc
--   if in word then goto start of word
--   if in misc then goto start of misc

  n = n or 1
  local dd2 = 1
  for i=1,n do
    if lued.is_sof() then
      break
    elseif lued.is_sol() then
      lued.move_left_n_char(1,dd2)
    else
      local start_of_word = lued.is_word() and not lued.prev_is_word()
      local start_of_other = lued.is_other() and not lued.prev_is_other()
      local in_space = lued.is_space()

      if in_space or start_of_word or start_of_other then
        lued.move_left_n_char(1,dd2)
        lued.skip_spaces_left(1,dd2)
      end

      local in_word = lued.is_word() and lued.prev_is_word()
      local in_other = lued.is_other() and lued.prev_is_other()
      if in_word then
        while lued.prev_is_word() and not lued.is_sol() do
          lued.move_left_n_char(1,dd2)
        end
      elseif in_other then
        while lued.prev_is_other() and not lued.is_sol() do
          lued.move_left_n_char(1,dd2)
        end
      end
    end -- else not eol
  end

  lued.disp(dd)
end


function lued.move_left_word(dd)
  return lued.move_left_n_words(1,dd)
end


function lued.move_down_n_lines(n,dd)
  local dd2 = 1
  n = n or 1
  local r,c = get_cur_pos()
  local numlines = get_numlines()
  local r2 = r + n

  g_scroll_speed = n
  if g_double_speed > 0 and not dd and n <= 1 then
    if g_command_count == g_move_down_n_lines_command_count then
      g_scroll_speed = g_double_speed + 1
    end
    g_command_count = g_command_count or 1
    g_move_down_n_lines_command_count = g_command_count + 1
  end

  r2 = r + g_scroll_speed
  lued.remove_trailing_spaces(r2,c,false,dd2)
  lued.disp(dd)
end


function lued.move_down(dd)
  return lued.move_down_n_lines(1,dd)
end


function lued.set_move_down_n_lines(val,dd)
  g_move_down_n_lines = val or g_move_down_n_lines
  lued.move_down_n_lines(g_move_down_n_lines, dd)
end


function lued.move_up_n_lines(n,dd)
  local dd2 = 1
  n = n or 1
  local r,c = get_cur_pos()
  local r2 = (n >= r) and 1 or (r - n)

  if g_double_speed > 0 and n <= 1 then
    if g_command_count == g_move_up_n_lines_command_count then
      g_scroll_speed = g_double_speed + 1
    else
      g_scroll_speed = 1
    end
    g_command_count = g_command_count or 1
    g_move_up_n_lines_command_count = g_command_count+1
    r2 = (g_scroll_speed >= r) and 1 or (r - g_scroll_speed)
  else
    g_scroll_speed = 0
  end

  lued.remove_trailing_spaces(r2,c,false,dd2)
  lued.disp(dd)
end


function lued.set_move_up_n_lines(val,dd)
  g_move_up_n_lines = val or g_move_up_n_lines
  lued.move_up_n_lines(g_move_up_n_lines, dd)
end


function lued.move_up_n_pages(n,dd)
  n = n or 1
  local pagesize = lued.get_pagesize()
  lued.move_up_n_lines(n*pagesize,dd)
end


function lued.move_down_n_pages(n,dd)
  n = n or 1
  local pagesize = lued.get_pagesize()
  lued.move_down_n_lines(n*pagesize, dd)
end


function lued.move_to_first_line(dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  lued.move_up_n_lines(r-1,dd2)
  lued.move_to_sol_classic(dd)
end
first_line = lued.move_to_first_line


function lued.move_to_last_line(dd)
  local dd2 = 1
  local lastline = get_numlines()
  local trows, tcols = get_termsize()
  local r,c = get_cur_pos()
  local r2 = lastline
  if r >= lastline - trows then
    r2 = lastline - r
  else
    r2 = lastline - r - trows/2
  end
  lued.move_down_n_lines(r2,dd2)
  lued.move_to_line(lastline, dd2)
  lued.move_to_eol(dd)
end


function lued.toggle_top(dd)
  if lued.is_sof() then
     lued.move_to_last_line(dd)
  else
     lued.move_to_first_line(dd)
  end
end


function lued.toggle_bottom(dd)
  if lued.is_eof() then
     lued.move_to_first_line(dd)
  else
     lued.move_to_last_line(dd)
  end
end


function lued.move_to_sol_classic(dd)
  local r,c = get_cur_pos()
  set_cur_pos(r,1)
  lued.disp(dd)
end


function lued.move_to_sol(dd)
  local dd2 = 1
  if not lued.is_sof() then
    if lued.is_sol() then
      lued.move_up_n_lines(1,dd2)
      if not lued.is_eol() then
        lued.move_to_eol(dd2)
      end
    end
    local r,c = get_cur_pos()
    lued.move_to_sol_classic(dd2)
    lued.skip_spaces(dd2)
    local r2,c2 = get_cur_pos()
    if (c2 == c) then set_cur_pos(r,1) end
  end
  lued.disp(dd)
end


function lued.move_to_eol(dd)
  local dd2 = 1
  if not lued.is_eof() then
    if lued.is_eol() then
      lued.move_down(dd2)
    end
    local r,c = get_cur_pos()
    local line_len = get_line_len()
    set_cur_pos(r,line_len+1)
  end
  lued.disp(dd)
end


function lued.move_to_line(n,dd)
  local r,c = get_cur_pos()
  if n == nil then
    move_to_line_hist_id = move_to_line_hist_id or lued.get_hist_id()
    local n_str = lued.prompt(move_to_line_hist_id,"Goto Linenumber: ")
    n = tonumber(n_str) or r
  end
  if n > r then
    lued.move_down_n_lines(n-r,dd)
  elseif (n < r) then
    lued.move_up_n_lines(r-n,dd)
  else
    lued.disp(dd)
  end
end


function lued.move_down_and_repeat(dd)
  local dd2 = 1
  if g_prev_pos ~= nil then
    local prev_r, prev_c = g_prev_pos;
    local prev_cmd = get_last_cmd() or ""
    set_cur_pos(prev_r, prev_c);
    lued.move_down(dd2)
  end
  lued.disp(dd)
end


function lued.word_end(dd)
  local r,c = get_cur_pos()
  local len = get_line_len()
  local line = get_line()
  c = string.find(line, "%s", c) -- find space after end of word
  c = c and c-1 or len
  set_cur_pos(r, c)
  lued.disp(dd)
end


function lued.skip_word(dd)
  local dd2 = 1
  lued.word_end(dd2)
end


function lued.var_end(dd)
  local r,c = get_cur_pos()
  local len = get_line_len()
  local line = get_line()
  local c2 = string.find(line, "[^%w_]", c) -- find space after end of word
  if c2==c then c2 = c2+1 end
  local c3 = c2 and c2 or len+1
  set_cur_pos(r, c3)
  lued.disp(dd)
end


function lued.skip_variable(dd)
  lued.var_end(dd)
end


function lued.skip_spaces(dd)
  local line = get_line()
  local r,c = get_cur_pos()
  local len = get_line_len()
  c = string.find(line, "[^%s]", c)
  c = c or len + 1
  set_cur_pos(r,c)
  lued.disp(dd)
end


function lued.skip_spaces_right(dd)
  local dd2 = 1
  if lued.is_eol() and not lued.is_eof() then
    lued.move_right_n_char(1,dd2)
  elseif lued.is_space() then
    repeat
      lued.move_right_n_char(1,dd2)
    until lued.is_eol() or not lued.is_space()
  end
  lued.disp(dd)
end


function lued.skip_spaces_left(dd)
  local dd2 = 1
  if lued.is_sol() and not lued.is_sof() then
    lued.move_left_n_char(1,dd2)
  elseif lued.is_space() then
    repeat
      lued.move_left_n_char(1,dd2)
    until lued.is_sol() or not lued.is_space()
  end
  lued.disp(dd)
end



