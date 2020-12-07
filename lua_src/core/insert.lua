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


function lued.ins_str_after(str, fstr, r, c, dd)
  local dd2 = 1
  lued.move_to(r,c,dd2)
  local r1,c1 = lued.get_cur_pos(dd2)
  local indent_size = c1 - 1
  local spaces = string.rep(" ", indent_size)
  local indented_str = string.gsub(str, "\n", "\n"..spaces)
  lued.ins_str(indented_str,dd2)
  lued.set_cur_pos(r1,c1,dd2)
  if fstr and #fstr>0 then
    lued.find_forward(fstr, dd2)
  end
  lued.disp(dd)
end


function lued.bracket_paste_start(dd)
  g_bracket_paste = 1
  lued.clr_auto_indent()
end


function lued.bracket_paste_stop(dd)
  g_bracket_paste = 0
  lued.set_auto_indent(dd)
end


function lued.ins_string(str, dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
  local first_line = sel_sr<=1
  local inhibit_cr = sel_state~=0 and not first_line

  local prev_cmd = get_last_cmd() or ""
--     print("prev_cmd=xxx"..prev_cmd.."xxx") io.read()
  if lued.is_sel_on() and str == "\n" then
    lued.find_forward_selected()
    return
  end
  lued.del_sel(dd2)

  local  _, str_line_cnt = string.gsub(str, '\n', '\n')

  local line_len = get_line_len()

  if str == "\n" then
    if g_auto_indent==true and c>1 then
      local line = get_line()
      local indent_str = line:match("^%s*") or ""
      if inhibit_cr then
        str = indent_str
      else
        str = str .. indent_str
      end
      local is_start_of_block = lued.line_ends_with(g_block_start)
      local is_eol = lued.is_eol()
      insert_str(str)
      if is_start_of_block and is_eol then
        lued.indent1(g_indent_size, g_indent_char, false, dd2)
      end

      local is_end_of_block = lued.line_ends_with(g_block_end)
      if is_end_of_block then
        lued.insert_line_before(dd2)
      end

    else
      insert_str(str)
    end

    local r2,c2 = get_cur_pos()
    set_cur_pos(r,c)
    lued.remove_trailing_spaces(r2,c2,false,dd2)
  elseif str_line_cnt > 0 and line_len > 1 and lued.is_blankline() then
    local str_indent_len = lued.string_num_leading_spaces(str)
    local delete_spaces = ""
    if str_indent_len > 0 then
      delete_spaces = string.rep(" ", str_indent_len)
    end
    str = string.gsub(str, '^ *', '')
    str = string.gsub(str, '\n' .. delete_spaces, '\n')

    if not lued.is_eol() then lued.del_eol(dd2); end
    local spaces = ""
    local current_indent = lued.get_indent_len()

    if current_indent > 0 then
      spaces = string.rep(" ", current_indent)
    end
    str = string.gsub(str, '^', spaces)
    str = string.gsub(str, '\n', '\n' .. spaces)
    local r3,c3 = get_cur_pos()
    if c3 > 1 then
      lued.del_sol(dd2)
    end
    insert_str(str)
  else
    local brace_closed = false
    if g_self_closing_braces and not lued.is_word() then
      if str=='{' then str= '{}'; brace_closed = true; end
      if str=='(' then str= '()'; brace_closed = true; end
      if str=='[' then str= '[]'; brace_closed = true; end
      if str=='"' then str= '""'; brace_closed = true; end
      if str=="'" then str= "''"; brace_closed = true; end
    end

--     local ch = lued.get_char()
--     if ch~='}' and ch~=')' and ch~=']' then
--       ch = '';
--     end
--     if str==ch then -- ch is '' or closing brace
--       lued.move_right_n_char(1,dd2)
--     else
      insert_str(str)
      if brace_closed then
        lued.move_left_n_char(1,dd2)
      end
--     end
  end

  if g_bracket_paste==1 then
    lued.bracket_paste_stop(dd2)
  end
  lued.disp(dd)
end


function lued.overtype_string(str,dd)
  local dd2 = 1
  for c in string.gmatch(str,".") do
    if not lued.is_eol() then
      lued.del_char(1,dd2)
    end
    lued.ins_string(c,dd2)
  end
  lued.disp(dd)
end


function ins_str(str,dd)
--   print("DEBUG ERROR - ins_str called, but it has been depricated. use lued.ins_str instead")
--   print(debug.traceback())
  if g_overtype==1 then
    lued.overtype_string(str,dd)
  else
    lued.ins_string(str,dd)
  end
end

function lued.ins_str(str,dd)
  if g_overtype==1 then
    lued.overtype_string(str,dd)
  else
    lued.ins_string(str,dd)
  end
end


function lued.insert_tab_classic(dd)
  local t = (g_tab_size > 0) and string.rep(' ',g_tab_size) or "\t"
  lued.ins_str(t,dd)
end


function lued.do_snippet(dd)
  local snip_found = false
  if g_handle_snippets then
    snip_found = lued.handle_snippets()
    if snip_found then
      lued.disp(dd)
    end
  end
  return snip_found
end


function lued.do_keyword(dd)
  local keyword_found = lued.complete_keyword(dd)
  if keyword_found then
    lued.disp(dd)
  end
  return keyword_found
end

-- align cursor with previous line's next 'column'
function lued.insert_tab(dd)
  local dd2 = 1
  if g_tab_classic then
    lued.insert_tab_classic(dd)
    return
  end

  -- if the line is blank or just has spaces then move to the next indent column.
  if lued.is_blankline() then
    local goto_next_line = false
    lued.indent1(g_indent_size, g_indent_char, goto_next_line, dd2)
    lued.disp(dd)
    return
  end

  -- Only do snippet/keyword replacement when typist directly entered <tab>,
  -- which is indicated by dd2=false/nil
  if not dd2 then
    if (lued.is_eol() or lued.is_space()) and not (lued.is_sol() or lued.prev_is_space()) then
      if lued.do_snippet(dd) then return end
      if lued.do_keyword(dd) then return end
    end
  end

  local dd2 = 1
  local r1,c1 = get_cur_pos()
  local len = get_line_len()
  local r2 = r1
  local c2 = math.min(len+1, c1)

  -- search up until a longer line is found
  set_cur_pos(r2, c2)
  local done = false
  repeat
    if lued.is_firstline() then break end
    lued.move_up_n_lines(1,dd2)
    local len = get_line_len()
    local short_line = (len <= c2)
    done = not short_line
  until done

  -- in the longer line, if in a word go to next non-space
  if not lued.is_eol() and not lued.is_space() then
    lued.move_right_to_space(dd2)
  end

  -- in the longer line, skip spaces to next word
  while not lued.is_eol() and lued.is_space() do
    lued.move_right_n_char(1, dd2)
  end

  -- remember this position (especially the column)
  local r3, c3 = get_cur_pos()

  -- if a longer long wasn't found then just do a normal tab
  if c3 <= c2 then
    set_cur_pos(r1, c1)
    lued.insert_tab_classic(dd2)
    lued.disp(dd)
    return
  end

  -----------------------------------------------------------------------------
  -- go back to the original position
  set_cur_pos(r2,c2)

  -- if in a word then goto beginning of word
  if not lued.is_eol() and not lued.is_space() then
    while not lued.is_space() do
      if lued.is_sol() then break end
      lued.move_left_n_char(1, dd2)
    end
  end

  -- delete any spaces before next word
  while not lued.is_eol() and lued.is_space() do
    lued.del_n_char(1, dd2) -- delete to end of spaces
  end

  -- indent word to the start of the previous line's next word
  r4, c4 = get_cur_pos()
  g_tab_col = c4
  local num_spaces_to_insert = c3 - c4
  if num_spaces_to_insert > 0 then
    local t = string.rep(" ", num_spaces_to_insert) or " "
    lued.ins_str(t, dd2)
  end

  lued.disp(dd)
  g_tab_mode = 1
  return
end


function lued.insert_tab_selected(dd)
  lued.foreach_selected(lued.insert_tab, dd)
end


function lued.insert_line_before(dd)
  local dd2 = 1
  set_sel_off()
  if not lued.is_sol() then lued.move_to_sol(dd2) end
  if lued.is_firstline() then
    lued.move_to_sol(dd2)
    lued.ins_str("\n",dd2)
    lued.move_up_n_lines(1, dd2)
  else
    lued.move_up_n_lines(1, dd2)
    if not lued.is_eol() then lued.move_to_eol(dd2) end
    lued.ins_str("\n",dd2)
  end
  lued.disp(dd)
end


function lued.insert_line_after(dd)
  local dd2 = 1
  set_sel_off()
  if not lued.is_eol() then lued.move_to_eol(dd2) end
  lued.ins_str("\n", dd2)
  lued.disp(dd)
end




