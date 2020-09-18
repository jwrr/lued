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


function lued.set_indent_size(dd)
  local dd2 = 1
  set_indent_size_hist_id = set_indent_size_hist_id or lued.get_hist_id()
  local  indent_size = lued.prompt(set_indent_size_hist_id,"Enter Indent Size (Default = '"..g_indent_size.."'): ")
  if indent_size ~= nil and tonumber(indent_size) > 0 then
    g_indent_size = tonumber(indent_size)
  end
  lued.disp(dd)
end


function lued.set_auto_indent(dd)
  g_auto_indent = true
  lued.disp(dd)
end


function lued.clr_auto_indent(dd)
  g_auto_indent = false
  lued.disp(dd)
end


function lued.toggle_auto_indent(dd)
  g_auto_indent = not g_auto_indent
  lued.disp(dd)
end


function lued.set_scope_indent(val,dd)
  val = val or 1
  g_scope_indent = val
  lued.disp(dd)
end


function lued.indent_scope(str,dd)
  str = str or string.rep(" ",g_scope_indent)
  local dd2 = 1
  local r,c = get_cur_pos()
  local numlines = get_numlines()
  local line = get_line()
  local leading_ws1 = string.match(line,"^%s+") or ""
  for i=r,numlines do
    set_cur_pos(i,1)
    local line = get_line()
    local leading_ws = string.match(line,"^%s+") or ""
    if (leading_ws == leading_ws1) then
      ins_str(str,dd2)
    elseif lued.is_blankline(line)==false then
      break
    end
  end -- for
  set_cur_pos(r,c)
  lued.disp(dd)
end


function lued.reindent(n,dd)
  n = n or 3
  local dd2 = 1
  local ws1,ws1_len = lued.leading_ws()
  local r,c = get_cur_pos()
  local numlines = get_numlines() - r
  local indent_level = 0;
  local ws_len = ws1_len
  for i=1,numlines do
    set_cur_pos(r+i,1)
    local ws2,ws2_len = lued.leading_ws()
    if ws2_len < ws1_len then break end
    if ws2_len > ws_len then
      indent_level = indent_level + 1
    elseif ws2_len < ws_len then
      indent_level = indent_level - 1
    end
    ws_len = ws2_len
    local indent_str = ws1 .. string.rep(" ",n*indent_level)
    lued.del_char(ws2_len,dd2)
    ins_str(indent_str,dd2)
  end
  set_cur_pos(r,c)
  lued.disp(dd)
end


function lued.reindent_selected(dd)
  g_indent_char    = g_indent_char or " "
  g_indent_size    = g_indent_size or 4
  local dd2 = 1
  local initial_row,initial_col = get_cur_pos()
  local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
  local something_selected = sel_state~=0;

  if something_selected then
    set_sel_off()

    set_cur_pos(sel_sr,1)
    local ws1,ws1_len = lued.leading_ws()
    local indent_level = 0;
    local ws_len = ws1_len

    for row=sel_sr,sel_er-1 do
      set_cur_pos(row,1)
--
      local ws2,ws2_len = lued.leading_ws()
      if ws2_len < ws1_len then break end
      if ws2_len > ws_len then
        indent_level = indent_level + 1
      elseif ws2_len < ws_len then
        indent_level = indent_level - 1
      end
      ws_len = ws2_len
      local indent_str = ws1 .. string.rep(g_indent_char,g_indent_size*indent_level)
      lued.del_char(ws2_len,dd2)
      ins_str(indent_str,dd2)
--
    end
    set_cur_pos(initial_row,initial_col)
  end
  lued.disp(dd)
end


function lued.reindent_all(n,dd)
  n = n or 3
  local dd2 = 1
  local ws1,ws1_len = lued.leading_ws()
  local r,c = get_cur_pos()
  local numlines = get_numlines() - r
  local indent_level = 0;
  local ws_len = ws1_len
  for i=1,numlines do
    set_cur_pos(r+i,1)
    local ws2,ws2_len = lued.leading_ws()
    if ws2_len < ws1_len then break end
    if ws2_len > ws_len then
      indent_level = indent_level + 1
    elseif ws2_len < ws_len then
      indent_level = indent_level - 1
    end
    ws_len = ws2_len
    local indent_str = ws1 .. string.rep(" ",n*indent_level)
    lued.del_char(ws2_len,dd2)
    ins_str(indent_str,dd2)
  end
  set_cur_pos(r,c)
  lued.disp(dd)
end


function lued.get_indent_len()
  local line = get_line()
  local leading_ws = string.match(line,"^%s+") or ""
  local leading_ws_len = string.len(leading_ws)
  return leading_ws_len
end


function lued.sel_indentation(dd)
  local dd2 = 1
  local indent_len = lued.get_indent_len()

  local r,c = get_cur_pos()
  local r1,c1 = r,c
  repeat
    r1,c1 = get_cur_pos()
    if r1==1 then break end
    lued.move_up_n_lines(1,dd2)
  until (lued.get_indent_len() < indent_len)

  local lastline = get_numlines()
  set_cur_pos(r,c)
  repeat
    r2,c2 = get_cur_pos()
    if r2==lastline then break end
    lued.move_down_n_lines(2,dd2)
  until (lued.get_indent_len() < indent_len)
  lued.set_sel_from_to(r1, 1, r2+1, 1, dd2 )
--  set_cur_pos(r,c)
  lued.disp(dd)
end


function lued.indent1(n, ch, goto_next, dd)
  local dd2 = 1

  local spaces = string.rep(ch,n)
  local r,c = get_cur_pos()
  set_cur_pos(r,1)
  ins_str(spaces,dd2)
  if goto_next then
    lued.move_down(dd2)
    lued.move_to_sol_classic(dd2)
  else
    set_cur_pos(r,c+n)
  end
  lued.disp(dd)
end


function lued.unindent1(n, ch, goto_next, dd)
  local dd2 = 1
  n = n or g_indent_size
  ch = ch or g_indent_char
  goto_next = goto_next or true

  local spaces = string.rep(ch,n)
  local r,c = get_cur_pos()
  set_cur_pos(r,1)
  lued.del_char(n,dd2)
  if goto_next then
    lued.move_down(dd2)
    lued.move_to_sol_classic(dd2)
  else
    set_cur_pos(r,c-n)
  end
  lued.disp(dd)
end


function lued.indent(dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  local goto_next_line = false
  if r==1 then
     lued.indent1(g_indent_size, g_indent_char, goto_next_line, dd)
  else
    lued.move_up_n_lines(1,dd2)
    local line = get_line()
    local indent_str = line:match("^%s*") or ""
    set_cur_pos(r,1)
    ins_str(indent_str,dd2)
    set_cur_pos(r,c+indent_str:len())
    lued.disp(dd)
  end
end


function lued.indent_selected(dd)
  local dd2 = 1
  local initial_row,initial_col = get_cur_pos()
  local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
  local something_selected = sel_state~=0;
  g_indent_char = g_indent_char or " "
  if something_selected then
    set_sel_off()
    for row=sel_sr,sel_er-1 do
      set_cur_pos(row,1)
      ins_str(g_indent_char,dd2)
    end
    set_cur_pos(sel_sr,sel_sc)
    set_sel_start()
    set_cur_pos(sel_er,sel_ec)
  else
    local goto_next_line = true
    lued.indent1(g_indent_size, g_indent_char, goto_next_line, dd2)
  end
  lued.disp(dd)
end


function lued.unindent_selected(dd)
  local dd2 = 1
  local initial_row,initial_col = get_cur_pos()
  local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
  local something_selected = sel_state~=0;
  g_indent_char = g_indent_char or " "
  if something_selected then
    set_sel_off()
    for row=sel_sr,sel_er-1 do
      set_cur_pos(row,1)
      lued.del_char(1,dd2)
    end
    set_cur_pos(sel_sr,sel_sc)
    set_sel_start()
    set_cur_pos(sel_er,sel_ec)
  else
    local goto_next_line = true
    local ws, ws_len = lued.leading_ws()
    if ws_len < g_indent_size then
      lued.del_spaces(dd2)
      lued.move_down(dd2)
    else
      lued.unindent1(g_indent_size, g_indent_char, goto_next_line, dd2)
    end
  end
  lued.disp(dd)
end




