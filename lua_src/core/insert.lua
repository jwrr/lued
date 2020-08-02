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
  lued.del_sel(dd2)

  is_start_of_block = lued.line_contains(g_block_start)
  is_start_of_block = lued.line_ends_with(g_block_start)
  is_inside_braces  = lued.get_char()=="}" and lued.get_char(-1)=="{"

  if str == "\n" then
    if g_auto_indent==true and c~=1 then
      local line = get_line()
      local indent_str = line:match("^%s*") or ""
      if inhibit_cr then
        str = indent_str
      else
        str = str .. indent_str
      end
    end
    insert_str(str)

--FIXME     if is_inside_braces then
--FIXME       insert_str(str)
--FIXME       lued.move_up_n_lines(1,dd2)
--FIXME       lued.indent1(g_indent_size, g_indent_char, false, dd2)
--FIXME     elseif is_start_of_block then
--FIXME       lued.indent1(g_indent_size, g_indent_char, false, dd2)
--FIXME     end

    local r2,c2 = get_cur_pos()
    set_cur_pos(r,c)
    lued.remove_trailing_spaces(r2,c2,false,dd2)
  else
    local brace_closed = false
    if g_self_closing_braces and not lued.is_word() then
      if str=='{' then str= '{}'; brace_closed = true; end
      if str=='(' then str= '()'; brace_closed = true; end
      if str=='[' then str= '[]'; brace_closed = true; end
      if str=='"' then str= '""'; brace_closed = true; end
      if str=="'" then str= "''"; brace_closed = true; end
    end

    local ch = lued.get_char()
    if ch~='}' and ch~=')' and ch~=']' then
      ch = '';
    end
    if str==ch then -- ch is '' or closing brace
      lued.move_right_n_char(1,dd2)
    else
      insert_str(str)
      if brace_closed then
        lued.move_left_n_char(1,dd2)
      end
    end
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
  if g_overtype==1 then
    lued.overtype_string(str,dd)
  else
    lued.ins_string(str,dd)
  end
end

function lued.ins_str(str,dd)
  return ins_str(str,dd)
end


function lued.insert_tab_classic(dd)
  local t = (g_tab_size > 0) and string.rep(' ',g_tab_size) or "\t"
  ins_str(t,dd)
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

  if (lued.is_eol() or lued.is_space()) and not (lued.is_sol() or lued.prev_is_space()) then
    if lued.do_snippet(dd) then return end
    if lued.do_keyword(dd) then return end
  end
  
  local dd2 = 1
  local r1,c1 = get_cur_pos()
  local len = get_line_len()
  local r2 = r1
  local c2 = math.min(len+1,c1)

  set_cur_pos(r2,c2)
  local done = false
  repeat
    if lued.is_firstline() then break end
    lued.move_up_n_lines(1,dd2)
    local len = get_line_len()
    local short_line = (len <= c2)
    done = not short_line
  until done
  if not lued.is_eol() then
    lued.move_right_n_words(1,dd2)
  end
  local r3,c3 = get_cur_pos()

  set_cur_pos(r2,c2)

  if not lued.is_eol() and not lued.is_space() then
    -- goto beginning of word
    while not lued.is_space() do
      if lued.is_sol() then break end
      lued.move_left_n_char(1,dd2)
    end
  end

  if (c3 > c2) then
    if lued.is_space() then
      lued.del_eow(dd2) -- delete to end of spaces
    end
    r4,c4 = get_cur_pos()
    local num_spaces_to_insert = c3 - c4
    local t = string.rep(" ",num_spaces_to_insert) or " "
    ins_str(t,dd2)
  else
    lued.insert_tab_classic(dd2)
  end
  lued.disp(dd)
end


function lued.insert_tab_selected(dd)
  lued.foreach_selected(lued.insert_tab, dd)
end


function lued.insert_cr_before(dd)
  local dd2 = 1
  local is_end_of_block = lued.line_contains(g_block_end)
  if not lued.is_sol() then lued.move_to_sol(dd2) end
  set_sel_off()
  ins_str("\n",dd2)
  lued.move_up_n_lines(1,dd2)
  lued.indent(dd2)
  if is_end_of_block then
    lued.indent1(g_indent_size, g_indent_char, false, dd2)
  end
  lued.disp(dd)
end


function lued.insert_cr_after(dd)
  local dd2 = 1
  if not lued.is_eol() then lued.move_to_eol(dd2) end
  set_sel_off()
  ins_str("\n",dd2)
  lued.disp(dd)
end




