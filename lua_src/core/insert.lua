--[[
MIT License

Copyright (c) 2018 JWRR.COM

git clone https://github.com/jwrr/lued.git

Permission is hereby granted, free of charge, to any person obtaining a lued.copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, lued.copy, modify, merge, publish, distribute, sublicense, and/or sell
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


function lued.insert_tab_classic(dd)
  local t = (g_tab_size > 0) and string.rep(' ',g_tab_size) or "\t"
  ins_str(t,dd)
end

-- align cursor with previous line's next 'column'
function lued.insert_tab(dd)
  if g_tab_classic then
    lued.insert_tab_classic(dd)
    return
  end
  
  local snip_found = false
  if g_handle_snippets then
    snip_found = lued.handle_snippets(dd)
  end
  
  if snip_found then
    return
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

  if not lued.is_eol() then
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
  lued.move_to_sol_classic(dd2)
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




