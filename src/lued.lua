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

  g_auto_indent            = true  -- Indent the same as the previous line
  g_replace_tabs           = 0     -- 4 -- Replace tab with N spaces (does not remove existing tabs). 0 keeps tabs.
  g_remove_trailing_spaces = false -- Only removes on lines that are modified. Use alt_Rats to remove all trailing spaces.
  g_show_trailing_spaces   = true  -- Show trailing spaces in reverse video
  g_enable_regex           = true  -- ALWAYS REGEX FOR NOW. use with find commands: ctrl_F, (ff), find_reverse(fr)
  g_scope_indent           = 2     -- use with indent_scope(is) command. change indent with si2 si3 si4...
  g_min_lines_from_top     = 5     -- scroll will try to keep at least 5 lines from the top
  g_min_lines_from_bot     = 7     -- scroll will try to keep at least 7 lines from the bottom
  g_page_size              = 0.25  -- this controls PgUp/PgDn speed. 0.25 is quarter page at a time.
  g_enable_file_changed    = true  -- efc0, efc1. detect file change and prompt to reload
  g_case_sensitive         = true  -- cs0 cs1
  g_show_line_numbers      = false -- alt_LN (toggle_line_numbers) toggles on/off
  g_ctrl_c_max             = 5     -- Quit when Ctrl+C is pounded several times with empty select buffer
  g_show_help              = false -- Show startup help menu
  g_double_speed           = 1     -- Increases scroll speed. 0 disables this feature. 2 or more goes even faster
  g_lua_mode               = false -- set_lua_mode (Alt+LU) forces lua mode. LuEd automatically goes in and out of Lua mode as needed.
  g_buffer                 = ""    -- The global buffer is used for cut and paste between multiple files.

function toggle_line_numbers(dd)
  g_show_line_numbers = not g_show_line_numbers
  local show = 0;
  if g_show_line_numbers then
    show = 1;
  end
  set_show_line_numbers(show)
  disp(dd)
end

function set_auto_indent(dd)
  g_auto_indent = true
  disp(dd)
end

function clr_auto_indent(dd)
  g_auto_indent = false
  disp(dd)
end

function toggle_auto_indent(dd)
  g_auto_indent = not g_auto_indent
  disp(dd)
end

function bracket_paste_start(dd)
  g_bracket_paste = 1
  clr_auto_indent()
end

function bracket_paste_stop(dd)
  g_bracket_paste = 0
  set_auto_indent(dd)
end

function set_replace_tabs(val,dd)
  val = val or 0
  g_replace_tabs = val
  disp(dd)
end

function toggle_remove_trailing_spaces(dd)
  g_remove_trailing_spaces = not g_remove_trailing_spaces
  disp(dd)
end

function toggle_show_trailing_spaces(dd)
  g_show_trailing_spaces = not g_show_trailing_spaces
  disp(dd)
end

function set_scope_indent(val,dd)
  val = val or 1
  g_scope_indent = val
  disp(dd)
end

function set_min_lines_from_top(val,dd)
  if val==nil then val = 5 end
  g_min_lines_from_top = val
  disp(dd)
end

function set_min_lines_from_bot(val,dd)
  if val==nil then val = 7 end
  g_min_lines_from_bot = val
  disp(dd)
end

function set_enable_file_changed(val,dd)
  val = val or 1
  g_enable_file_changed = val==1 and true or false
  disp(dd)
end

function set_case_sensitive(val,dd)
  val = val or 1
  g_case_sensitive = val==1 and true or false
  disp(dd)
end


function toggle_overtype(dd)
  g_overtype = g_overtype or 0
  g_overtype = (g_overtype+1) % 2
  disp(dd)
end

function is_sol()
  local r,c = get_cur_pos()
  return c <= 1
end

function is_eol()
  local r,c = get_cur_pos()
  local len = get_line_len()
  return c > len
end

function is_sof()
  local r,c = get_cur_pos()
  return c <= 1 and r <= 1
end

function is_space(line,pos)
  local is = string.match(line,"^%s",pos) and true or false
  return is
end

function is_word(line,pos)
  local is = string.match(line,"^[%w_]",pos) and true or false
  return is
end

function is_sow()
  local r,c = get_cur_pos()
  local line = get_line()
  local prev_boundary = (c==1) or is_space(line,c-1)
  local is = prev_boundary and not is_space(line,c)
  return is
end

function is_lastline()
  local r,c = get_cur_pos()
  local num_lines = get_numlines()
  return r >= num_lines
end

function is_eof()
  local r,c = get_cur_pos()
  local len = get_line_len()
  return is_lastline() and is_eol()
end

function is_sel_on()
  return not (is_sel_off()==1)
end

function is_blankline(line)
  local found = string.find(line,"^%s*$")
  local is = found~=nil
  return is
end


function set_edit_mode(dd)
  g_lua_mode = false
  local keys = get_hotkeys()
  keys = "all" .. keys
  -- print ("KEYS1="..keys)
  set_hotkeys(keys)
  disp(dd)
end

function set_lua_mode(dd)
  g_lua_mode = true
  local keys = get_hotkeys()
  keys = string.gsub(keys,"(all)","")
  print ("KEYS2="..keys)
  set_hotkeys(keys)
  disp(dd)
end

function remove_trailing_spaces(next_row,next_col,force,dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  local line = get_line()
  local row_changing = next_row ~= row
  local saved_exists = saved_line ~= nil
  local line_exists = line ~= nil
  local line_different = next_row==0 or line ~= saved_line
  local line_changed = row_changing and saved_exists and line_exists and line_different
  local remove = force==true or g_remove_trailing_spaces==true and line_changed==true
  if remove==true then
    local non_space = string.find(line,"%S")
    local last_nonspace = non_space==nil and 0 or string.find(line,"%S%s+$")
    if last_nonspace then
      local first_trailing_space = non_space==nil and 0 or last_nonspace + 1
      set_cur_pos(r,first_trailing_space)
      if not is_eol() then
        del_eol(dd2)
      end
    end
  end
  if next_row > 0 and next_col > 0 then
    set_cur_pos(next_row,next_col)
    local numlines = get_numlines()
    if next_row > numlines then
      next_row = numlines
      eol(dd2);
    end
    if (next_row ~= row) then
      saved_line = get_line()
    end
  else
    saved_line = ""
  end
  disp(dd)
end

function remove_all_trailing_space(dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  local pr,pc = get_page_pos()
  local numlines = get_numlines()
  for i=1,numlines do
    set_cur_pos(i,1)
    remove_trailing_spaces(0,0,true,dd2)
  end
  set_cur_pos(r,c)
  set_page_pos(pr,pc)
  disp(dd)
end

function remove_all_trailing_space_all_files(dd)
  local dd2 = 1
  local fileid = get_fileid()
  local num_sessions = get_numsessions()
  for i=1,num_sessions do
    session_sel(i,dd2)
    remove_all_trailing_space(dd2)
  end
  session_sel(fileid,dd)
end

function remove_all_leading_tabs(tab_size,dd)
  tab_size = tab_size or  8
  local dd2 = 1
  local r,c = get_cur_pos()
  local numlines = get_numlines()
  for i=1,numlines do
    set_cur_pos(i,1)
    local line = get_line()
    local leading_ws = string.match(line,"^%s+") or ""
    if (leading_ws ~= nil) then
      local leading_ws_len = string.len(leading_ws)
      local tabi = string.find(leading_ws,"\t")
      local count = 0
      while tabi~=nil and count < 10 do
        count = count + 1
        tabi = tabi - 1
        local num_tab = math.floor(tabi / tab_size)
        local next_tab = tab_size*(num_tab+1)
        local this_tab_size = next_tab - tabi;
        local spaces = string.rep(' ',this_tab_size);
        leading_ws = string.gsub(leading_ws, "(\t)", spaces, 1)
        tabi = string.find(leading_ws,"\t")
      end
      set_sel_start()
      set_cur_pos(i,leading_ws_len+1)
      set_sel_end()
      del_sel(dd2)
      ins_str(leading_ws,dd2)
    end
  end -- for
  set_cur_pos(r,c)
  disp(dd)
end

function leading_ws()
  local line = get_line()
  local ws = string.match(line,"^%s+") or ""
  local ws_len = string.len(ws)
  return ws, ws_len
end

function indent_scope(str,dd)
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
    elseif is_blankline(line)==false then
      break
    end
  end -- for
  set_cur_pos(r,c)
  disp(dd)
end

function reindent(n,dd)
  n = n or 3
  local dd2 = 1
  local ws1,ws1_len = leading_ws()
  local r,c = get_cur_pos()
  local numlines = get_numlines() - r
  local indent_level = 0;
  local ws_len = ws1_len
  for i=1,numlines do
    set_cur_pos(r+i,1)
    local ws2,ws2_len = leading_ws()
    if ws2_len < ws1_len then break end
    if ws2_len > ws_len then
      indent_level = indent_level + 1
    elseif ws2_len < ws_len then
      indent_level = indent_level - 1
    end
    ws_len = ws2_len
    local indent_str = ws1 .. string.rep(" ",n*indent_level)
    del_char(ws2_len,dd2)
    ins_str(indent_str,dd2)
  end
  set_cur_pos(r,c)
  disp(dd)
end

function hot_range(lower,upper)
  local hot = ""
  for ch=string.byte(lower),string.byte(upper) do
    hot = hot .. "," .. string.char(ch)
  end
  if hot ~= "" then hot = hot .. "," end
  return hot
end

function lued_prompt(prompt,hist_id,hot)
  -- io.write(prompt)
  -- str = io.read()
  hist_id = hist_id or ""
  hot = hot or ""
  str = io_read(prompt,hist_id,hot)
  return str
end

function get_yesno(prompt,hist_id,default)
  local yes = false
  local no = false
  local quit = false
  local all = false
  local valid_answer = false
  local answer = ""
  repeat
    answer = lued_prompt(prompt .. " ")
    if default~=nil and answer==nil or answer=="" then answer = default end
    answer = string.upper(answer)
    yes = answer=="Y"
    no  = answer=="N"
    quit = answer=="Q"
    all = answer=="A"
    valid_answer = yes or no or quit or all
  until (valid_answer)
  return answer
end

function disp(dd)
   dd = dd or 0
   local dd2 = 1
   if g_enable_file_changed then
     local file_has_changed,mtime,ts = is_file_modified(0)
     if file_has_changed==1 then
       io.write("\n\n=======================================\n\n")
       local id = get_fileid()
       local prompt = "File '" .. get_filename(id) .. "' has changed. Do you want to reload <y/n>?"
       local reload = get_yesno(prompt)=="Y"
       if reload then
         reopen()
       end
     end
   end
   local r,c = get_cur_pos()
   local pr,pc = get_page_pos()
   local tr,tc = get_termsize()
   if (r-pr) < g_min_lines_from_top then
     set_page_offset_percent(g_min_lines_from_top,dd2)
   end
   if (pr+tr-r < g_min_lines_from_bot) then
     set_page_offset_percent(-g_min_lines_from_bot,dd2)
   end
   if dd == 0 then
     g_command_count = g_command_count or 0
     g_command_count = g_command_count + 1

     if g_lua_mode == nil then return end
     local show_trailing_spaces = 0;
     if g_show_trailing_spaces then
       show_trailing_spaces = 1
     end
     local lua_mode = 0
     if g_lua_mode then
       lua_mode = 1
     end
     display_screen(lua_mode,show_trailing_spaces)
   end
end

function char_left(n,dd)
  local n_is_nil = n == nil or n == 0
  --print ("999", n, n_is_nil); io.ad()
  n = n or 1
  local dd2 = 1
  for i=1,n do
    if is_sof() then break end
    if is_sol() then
      line_up(1,dd2)
      if not is_eol() then eol(dd2) end
    else
      local r,c = get_cur_pos()
      local len = get_line_len()
      c = math.min(c,len+1)
      c = c - 1
      set_cur_pos(r,c)

      if g_double_speed > 0 and n_is_nil then
        if g_command_count == g_char_left_command_count then
          g_scroll_speed = g_scroll_speed or 0
          set_cur_pos(r,c-g_scroll_speed)
          g_scroll_speed = g_double_speed
        else
          g_scroll_speed = 0
        end
        g_command_count = g_command_count or 1
        g_char_left_command_count = g_command_count+1
      else
        g_scroll_speed = 0
      end

    end
  end
  disp(dd)
end

function char_right(n,dd)
  local n_is_nil = n == nil or n == 0
  n = n or 1
  local dd2 = 1
  for i=1,n do
    if is_eof() then break end
    if is_eol() then
      line_down(1,dd2)
      sol_classic(dd2)
    else
      local r,c = get_cur_pos()
      c = c + 1
      set_cur_pos(r,c)

      if g_double_speed > 0 and n_is_nil then
        if g_command_count == g_char_right_command_count then
          g_scroll_speed = g_scroll_speed or 0
          set_cur_pos(r,c+g_scroll_speed)
          g_scroll_speed = g_double_speed
        else
          g_scroll_speed = 0
        end
        g_command_count = g_command_count or 1
        g_char_right_command_count = g_command_count+1
      else
        g_scroll_speed = 0
      end

    end
  end
  disp(dd)
end

function word_left(n,dd)
  n = n or 1
  local dd2 = 1
  for i=1,n do
    if is_sof() then break end
    if is_sol() then
      line_up(1,dd2)
      eol(dd2)
      break
    end
    local line = get_line()
    local r,c = get_cur_pos()
--    while is_space(line,c-1) do c = c - 1 end -- back through spaces
    while not is_word(line,c-1) do c = c - 1 end -- back through spaces
    while is_word(line,c-1) do c = c - 1 end -- back through alphanums
    -- while not is_space(line,c-1) do c = c - 1 end -- back through alphanums
    set_cur_pos(r,c)
  end
  disp(dd)
end

function word_end(dd)
  local r,c = get_cur_pos()
  local len = get_line_len()
  local line = get_line()
  c = string.find(line, "%s", c) -- find space after end of word
  c = c and c-1 or len
  set_cur_pos(r, c)
  disp(dd)
end

function skip_word(dd)
  local dd2 = 1
  word_end(dd2)
end

function var_end(dd)
  local r,c = get_cur_pos()
  local len = get_line_len()
  local line = get_line()
  local c2 = string.find(line, "[^%w_]", c) -- find space after end of word
  local c3 = c2 and c2 or len+1
  set_cur_pos(r, c3)
  disp(dd)
end

function skip_variable(dd)
  var_end(dd)
end

function skip_spaces(dd)
  local line = get_line()
  local r,c = get_cur_pos()
  local len = get_line_len()
  c = string.find(line, "[^%s]", c)
  c = c or len + 1
  set_cur_pos(r,c)
  disp(dd)
end

function word_right(n,dd)
  n = n or 1
  local dd2 = 1
  for i=1,n do
    if is_eol() then
      line_down(1, dd2)
      sol(dd2)
    else
      skip_word(dd2)
      char_right(1,dd2)
      skip_spaces(dd2)
    end
  end
  disp(dd)
end

function set_pagesize(val,dd)
  val = val or 0 -- zero is a special case.
  g_page_size = val
  disp(dd)
end

function get_pagesize()
  rows, cols = get_termsize()
  if g_page_size==nil or g_page_size==0 then
    return rows
  elseif g_page_size < 1 then
    return math.floor(rows*g_page_size*100 + 0.5) / 100;
  else
    return g_page_size
  end
end

function page_up(n,dd)
  n = n or 1
  local pagesize = get_pagesize()
  line_up(n*pagesize,dd)
end

function page_down(n,dd)
  n = n or 1
  local pagesize = get_pagesize()
  line_down(n*pagesize, dd)
end

function line_down(n,dd)
  local dd2 = 1
  n = n or 1
  local r,c = get_cur_pos()
  local numlines = get_numlines()
  local r2 = r + n
--  if r2>numlines then
--    r2 = numlines
--  end
  remove_trailing_spaces(r2,c,false,dd2)
  disp(dd)
end

function line_up(n,dd)
  local dd2 = 1
  n = n or 1
  local r,c = get_cur_pos()
  local r2 = (n >= r) and 1 or (r - n)
  remove_trailing_spaces(r2,c,false,dd2)
  disp(dd)
end

function first_line(dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  line_up(r-1,dd2)
  sol_classic(dd)
end

function last_line(dd)
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
  line_down(r2,dd2)
  goto_line(lastline, dd2)
  eol(dd)
end

function toggle_top(dd)
  if is_sof() then
     last_line(dd)
  else
     first_line(dd)
  end
end

function sol_classic(dd)
  local r,c = get_cur_pos()
  set_cur_pos(r,1)
  disp(dd)
end

function sol(dd)
  local dd2 = 1
  if not is_sof() then
    if is_sol() then
      line_up(1,dd2)
      eol(dd2)
    end
    local r,c = get_cur_pos()
    sol_classic(dd2)
    skip_spaces(dd2)
    local r2,c2 = get_cur_pos()
    if (c2 == c) then set_cur_pos(r,1) end
  end
  disp(dd)
end

function eol(dd)
  local dd2 = 1
  if not is_eof() then
    if is_eol() then
      line_down(1,dd2)
    end
    local r,c = get_cur_pos()
    line_len = get_line_len()
    set_cur_pos(r,line_len+1)
  end
  disp(dd)
end

function session_sel(session_id,dd)
  if session_id then
    local fileid = get_fileid()
    if session_id ~= fileid then
      g_buffer_prev = fileid
    end
    set_fileid(session_id)
  end
  disp(dd)
end

function session_next(dd)
  local num_sessions = get_numsessions()
  local next_session = (get_fileid() % num_sessions)+1
  session_sel(next_session, dd)
  return get_fileid()
end

function buffer_prev(dd)
  session_sel(g_buffer_prev, dd)
end

function goto_line(n,dd)
  local r,c = get_cur_pos()
  if n == nil then
    local n_str = lued_prompt("Goto Linenumber: ", "", "")
    n = tonumber(n_str) or r
  end
  if n > r then
    line_down(n-r,dd)
  elseif (n < r) then
    line_up(r-n,dd)
  else
    disp(dd)
  end
end

function get_sel_str()
  local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
  local sel_str = ""
  if sel_state~=0 then
    sel_str = get_str(sel_sr,sel_sc,sel_er,sel_ec)
  end
  return sel_str, sel_sr, sel_sc, sel_er, sel_ec
end

function find(str,dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  local found,r2,c2 = find_str(str)
  if found==0 then
    first_line(dd2)
    found,r2,c2 = find_str(str)
    set_cur_pos(r,c)
  end
  if found ~= 0 then
    remove_trailing_spaces(r2,c2,false,dd2)
    local pr,pc = get_page_pos()
    local tr,tc = get_termsize()
    local third = math.floor(tr / 3)
    local lr = pr+tr
    local page_change = r2 > lr-third or r2 < pr+third
    if page_change==true then
      set_page_offset_percent(third,dd2)
    end
  end
  disp(dd)
end

function find_prompt()
  local str = ""
  -- repeat
    local default_str = ""
    if g_find_str and g_find_str~="" then
      default_str = " (default='"..g_find_str.."')"
    end

    local prompt = " String to Find"..default_str..": "
    str = find_read(prompt)
    if str==nil or str=="" and g_find_str and g_find_str~="" then
      str = g_find_str
    else
      disp()
    end
  -- until str and str ~= ""
  if (str=="/*") then str = "/" .. "\\" .. "*" end
  return str
end

function replace_prompt()
  local str = ""
  -- repeat
    local default_str = ""
    if g_replace_str and g_replace_str~="" then
      default_str = " (default='"..g_replace_str.."')"
    end

    local prompt = " String to Replace"..default_str..": "
    str = replace_read(prompt)
    if str==nil or str=="" and g_replace_str and g_replace_str~="" then
      str = g_replace_str
    else
      disp()
    end
  -- until str and str ~= ""
  return str
end

function find_all_on_line(line,str)
  local matchi = {}
  local s,e = 1,1
  local match_count = 0
  local line2 = line
  local str2 = str
  repeat
    s,e = string.find(line2,str2,e)
    if s ~= nil then
      match_count = match_count + 1
      matchi[match_count] = s
      e = e + 1
    end
  until (s == nil)
  return matchi
end

function get_last_match(matches, maxc)
  if matches==nil then return end
  local last_match
  for i=1,#matches do
    if matches[i] < maxc then
      last_match = matches[i]
    end
  end
  return last_match
end

function find_reverse(str,dd)
  local dd2 = 1
  if (str==nil or str=="") then
    g_find_str = find_prompt()
  end
  if g_find_str == "" then
    disp(dd)
    return
  end

  local g_find_str2 = g_find_str
  if not g_case_sensitive then
    g_find_str2 = string.lower(g_find_str)
  end

  local r,c = get_cur_pos()
  local pr,pc = get_page_pos()
  local local_page_offset = page_offset
  c = c-1
  local numlines = get_numlines()
  for k=numlines,1,-1 do
    i = (r+k-numlines) % numlines
    local line = get_line()
    if not g_case_sensitive then
      line = string.lower(line)
    end
    local matches = find_all_on_line(line,g_find_str2)
    local maxc = i==r and c or string.len(line)+1
    local match_c = get_last_match(matches,maxc)
    for j=1,#matches do matches[j] = nil end
    if match_c == nil then
      if k==1 then
        set_cur_pos(r,c+1)
        set_page_pos(pr,pc)
      else
        set_cur_pos(i-1,1)
      end
    else
      local match_str = string.match(line,g_find_str,match_c)
      local match_len = string.len(match_str)
      set_cur_pos(i,match_c)
      set_sel_start()
      set_cur_pos(i,match_c+match_len)
      set_sel_end()
      set_cur_pos(i,match_c)
      break
    end
  end
  disp(dd)
end

function find_reverse_again(dd)
  local dd2 = 1
  local sel_str,sel_sr,sel_sc = get_sel_str()
  if sel_str~="" then
    set_cur_pos(sel_sr,sel_sc)
    char_left(1,dd2)
    g_find_str = sel_str
  end
  find_reverse(g_find_str,dd)
end

function get_first_match(matches, minc)
  if matches==nil then return end
  local first_match
  for i=1,#matches do
    if matches[i] > minc then
      first_match = matches[i]
      break
    end
  end
  return first_match
end

function find_forward(str,nowrap,search_all,replace,dd)
  local dd2 = 1
  local found = false
  if str==nil or str=="" then
    g_find_str = find_prompt()
  else
    g_find_str = str
  end
  if g_find_str == "" then
    disp(dd)
    return
  end

  local g_find_str2 = g_find_str
  if not g_case_sensitive then
    g_find_str2 = string.lower(g_find_str2)
  end

  if replace and (str==nil or str=="") then
    g_replace_str = replace_prompt()
    if g_replace_str == "" then
      disp(dd)
      return
    end



  end

  local r,c = get_cur_pos()
  local pr,pc = get_page_pos()
  local local_page_offset = page_offset
  local numlines = get_numlines()
  local i = 0
  for k=1,numlines,1 do
    local ibefore = i
    i = (((r+k-1)-1) % numlines)+1
    local wrap = i < ibefore
    if wrap==true and nowrap==true then break end
    set_cur_pos(i,1)
    local line = get_line()
    if not g_case_sensitive then
      line = string.lower(line)
    end
    local matches = find_all_on_line(line,g_find_str2)
    local minc = 0
    if i==r and not search_all then
      minc = c
    end
    local match_c = get_first_match(matches,minc)
    for j=1,#matches do matches[j] = nil end
    if match_c == nil then
      if k==numlines then
        local r2,c2 = get_cur_pos()
        local pr2,pc2 = get_page_pos()
        set_cur_pos(r,c)
        set_page_pos(pr,pc)
      else
        set_cur_pos(i+1,1)
      end
    else
      local match_str = string.match(line,g_find_str2,match_c)
      local match_len = string.len(match_str)
      set_cur_pos(i,match_c)
      set_sel_start()
      set_cur_pos(i, match_c+match_len)
      set_sel_end()
      set_cur_pos(i,match_c)
      found = true
      break
    end
  end
  disp(dd)
  return found
end

function find_and_replace(from,to,options,dd)
  local dd2 = 1
  local found = false
  local str = nil
  if from~=nil then
    str = from
  end
  if to~=nil then
    g_replace_str = to
  end

  local replace_all = false
  if options=='a' then
    replace_all = true
  end

  local initial_r,initial_c = get_cur_pos()
  local r,c = get_cur_pos()
  repeat
    found = find_forward(str,true,false,true,dd2)
    str = str or g_find_str
    if found then
      local resp = "y"
      if not replace_all then
        disp(0)
        r,c = get_cur_pos()
        resp = lued_prompt("Replace <y/n/a/q>?", "", ",y,n,a,q,")
        resp = string.lower( string.sub(resp,1,1) )
        resp = string.match(resp,"[ynaq]") or "q"
        replace_all = resp=="a"
      end

      if resp=="y" or resp=="a" then
        ins_string(g_replace_str,dd2)
      elseif resp=="n" then
        char_right(1,dd2)
      else -- q or invalid response
        break
      end

    end
  until not found
  set_cur_pos(initial_r,initial_c)
  disp(dd)
end

function search_all(str,dd)
  local dd2 = 1
  str = str or ""
  local match = find_forward(str,true,false,false,dd2)
  local start_session = get_fileid()
  while not match do
    local session_id = session_next(dd2)
    if session_id == start_session then break end
    local r,c = get_cur_pos()
    first_line(dd2)
    sol_classic(dd2)
    match = find_forward(g_find_str,true,true,false,dd2)
    if not match then -- restore cur_pos
      set_cur_pos(r,c)
    end
  end
  disp(dd)
end

function find_forward_again(dd)
  local dd2 = 1
  local initial_r,initial_c = get_cur_pos()
  local sel_str, sel_sr, sel_sc = get_sel_str()
  if sel_str~="" then
    char_right(1,dd2)
    g_find_str = sel_str
    set_sel_off()
  end
  local found = find_forward(g_find_str,false,false,false,dd2)
  if not found then
    set_cur_pos(initial_r,initial_c)
  end
  disp(dd)
  return found
end

function find_selected_OLD(dd)
  local dd2 = 1
  local str
  if is_sel_off()==1 then
    str = ""
  else
    local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
    str = get_str(sel_sr,sel_sc,sel_er,sel_ec)
  end
  find(str,dd)
end

function word_start(dd)
  local r,c = get_cur_pos()
  local line = get_line()
  if is_space(line,c) then
    word_right(1,dd)
  elseif not is_sow(line,c) then
    word_left(1,dd)
  else
    disp(dd)
  end
end

function var_start(dd)
  local r,c = get_cur_pos()
  local line = get_line()
  local len = get_line_len()
  local c2 = string.find(line, "[%w_]", c) -- find space after end of word
  local c3 = c2 and c2 or len
  set_cur_pos(r, c3)
  disp(dd)
end

function sel_word(n,dd)
  n = n or 1
  local dd2 = 1
  word_start(dd2)
  var_start(dd2)
  if is_sel_off()==1 then set_sel_start() end
  if n > 1 then
    word_right(n-1, dd2)
  end
  skip_variable(dd2)
  -- set_sel_end()
  local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()

  -- set_cur_pos(r,c)
  disp(dd)
end

function sel_line(n,dd)
  n = n or 1
  local dd2 = 1
  local r,c = get_cur_pos()
  local rlast = r + n - 1
  set_cur_pos(r,1)
  set_sel_start()
  set_cur_pos(rlast+1,1)
  set_sel_end(dd2)
  set_cur_pos(rlast+1,1)
  disp(dd)
end

function sel_all(dd)
  local dd2 = 1
  first_line(dd2)
  set_sel_start()
  last_line(dd2)
  set_sel_end()
  disp(dd)
end

function sel_toggle(dd)
  if is_sel_off()==1 then
    set_sel_start()
  else
    set_sel_off()
  end
  disp(dd)
end

function del_sel(dd)
  delete_selected()
  disp(dd)
end

function cut(dd)
  if is_sel_off()==1 then
    disp(dd)
  else
    set_paste()
    del_sel(dd)
  end
end

function copy(dd)
  if is_sel_off()==1 then
    g_ctrl_c_count = g_ctrl_c_count or 0
    g_ctrl_c_count = g_ctrl_c_count+1
    if (g_ctrl_c_count >= g_ctrl_c_max) then
      local force = true
      quit_all(force,1)
    end
    disp(dd)
  else
    g_ctrl_c_count = 0
    set_sel_end()
    set_paste()
    set_sel_off()
    disp(dd)
  end
end

function set_paste_buffer(str,dd)
  set_paste(str)
  disp(dd)
end

function paste(dd)
  local dd2 = 1
  local auto_indent_save = g_auto_indent
  g_auto_indent = false
  del_sel(dd2)
  local pb = get_paste()
  ins_str(pb, dd)
  g_auto_indent = auto_indent_save
end

function global_cut(dd)
  cut(dd)
  g_buffer = get_paste()
  disp(dd)
end

function global_cut_append(dd)
  cut(dd)
  g_buffer = g_buffer .. get_paste()
  disp(dd)
end

function global_copy(dd)
  local dd2 = 1
  copy(dd2)
  g_buffer = get_paste()
  disp(dd)
end

function global_paste(dd)
  local dd2 = 1
  set_paste(g_buffer)
  paste(dd2)
  disp(dd)
end

function del_char(n,dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  if is_sel_off()==1 then
    set_sel_start()
    n = n or 1
    char_right(n, dd2)
    set_sel_end()
    set_cur_pos(r,c)
    del_sel(dd)
  else
    set_sel_end()
    cut(dd)
  end
end

function del_eow(dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  set_sel_start()
  skip_spaces(dd2)
  var_end(dd2)
  set_sel_end()
  set_cur_pos(r,c)
  cut(dd)
end

function del_word(n,dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  word_start(dd2)
  del_eow(dd)
end

function del_word_multi(n,dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  word_start(dd2)
  set_sel_start()
  word_right(n,dd2)
  set_sel_end()
  set_cur_pos(r,c)
  cut(dd)
end

function cut_eol(dd)
  local dd2 = 1
  if is_eol() then
    del_char(1,dd)
  else
    local r,c = get_cur_pos()
    set_sel_start()
    eol(dd2)
    set_sel_end()
    set_cur_pos(r,c)
    cut(dd)
  end
end

function del_eol(dd)
  local dd2 = 1
  if is_eol() then
    del_char(1,dd)
  else
    local r,c = get_cur_pos()
    set_sel_start()
    eol(dd2)
    set_sel_end()
    set_cur_pos(r,c)
    del_sel(dd)
  end
end

function del_sol(dd)
  local dd2 = 1
  if is_sof() then
    disp(dd)
  elseif is_sol() then
    del_backspace(1,dd)
  else
    local r,c = get_cur_pos()
    sol(dd2) -- sol_classic(dd2)
    set_sel_start()
    set_cur_pos(r,c)
    set_sel_end()
    cut(dd)
  end
end

function del_line(n,dd)
  n = n or 1
  local dd2 = 1
  local r,c = get_cur_pos()
  set_cur_pos(r,1)
  set_sel_start()
  line_down(n,dd2)
  set_sel_end()
  if (g_command_count == g_del_line_command_count) then
    global_cut_append(dd)
  else
    global_cut(dd)
  end
  g_del_line_command_count = g_command_count
end

function del_backspace(n,dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  if is_sel_off()==1 then
    n = n or 1
    char_left(n, dd2)
    set_sel_start()
    set_cur_pos(r,c)
    set_sel_end()
    del_sel(dd)
  else
    set_sel_end()
    cut(dd)
  end
end

function del_backword(n,dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  set_sel_start()
  word_left(n,dd2)
  set_sel_end()
  set_cur_pos(r,c)
  del_sel(dd)
end

function indent1(n, ch, dd)
  local dd2 = 1
  n = n or 4 -- indent_size
  local spaces = string.rep(ch,n)
  local r,c = get_cur_pos()
  set_cur_pos(r,1)
  ins_str(spaces,dd2)
  set_cur_pos(r,c+n)
  disp(dd)
end

function indent(dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  if r==1 then
     indent1(dd)
  else
    line_up(1,dd2)
    local line = get_line()
    local indent_str = line:match("^%s*") or ""
    set_cur_pos(r,1)
    ins_str(indent_str,dd2)
    set_cur_pos(r,c+indent_str:len())
    disp(dd)
  end
end

function ins_string(str, dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
  local inhibit_cr = sel_state~=0 and sel_sr>1
  del_sel(dd2)
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
    local r2,c2 = get_cur_pos()
    set_cur_pos(r,c)
    remove_trailing_spaces(r2,c2,false,dd2)
  else
    insert_str(str)
  end
  if g_bracket_paste==1 then
    bracket_paste_stop(dd2)
  end
  disp(dd)
end

function overtype_string(str,dd)
  local dd2 = 1
  for c in string.gmatch(str,".") do
    if not is_eol() then
      del_char(1,dd2)
    end
    ins_string(c,dd2)
  end
  disp(dd)
end

function ins_str(str,dd)
  if g_overtype==1 then
    overtype_string(str,dd)
  else
    ins_string(str,dd)
  end
end

function insert_tab(dd)
  local t = (g_replace_tabs > 0) and string.rep(' ',g_replace_tabs) or "\t"
  ins_str(t,dd)
end

function cr_before(dd)
  local dd2 = 1
  sol_classic(dd2)
  ins_str("\n",dd2)
  line_up(1,dd2)
  indent(dd)
end

function cr_after(dd)
  local dd2 = 1
  local line = get_line()
  if is_blankline(line) then
    if not is_eol() then eol(dd2) end
    ins_str("\n",dd2)
    ins_str("\n",dd2)
    line_up(1,dd)
  elseif is_eol() then
    ins_str("\n",dd2)
    ins_str("\n",dd)
  else
    eol(dd2)
    ins_str("\n",dd)
  end
end

function hot_squote(key, dd)
  if key == nil then return end
  key = key .. ","
  local keys = get_hotkeys()
  if not string.find(keys, key) then
    set_hotkeys(keys .. key)
  end
  disp(dd)
end

function nohot_squote(key, dd)
  if not key then return end
  key = key .. ","
  local keys = get_hotkeys()
  keys:gsub(key,"")
  set_hotkeys(keys)
  disp(dd)
end

function save_file(dd)
  local r,c = get_cur_pos()
  local file_has_changed,mtime,ts = is_file_modified(1)
  if file_has_changed==1 then
    io.write("\n\n=======================================\n\n")
    local overwrite = get_yesno("File has changed. Do you want to overwrite <y/n>?")=="Y"
    if overwrite then
      save_session()
    end
  else
    save_session()
  end
  set_cur_pos(r,c)
  disp(dd)
end

function save_as(filename, dd)
  set_filename(filename)
  save_session()
  disp(dd)
end

function save_all(dd)
  local dd2 = 1
  local fileid = get_fileid()
  local numsessions = get_numsessions()
  for i=1,numsessions do
    session_sel(i)
    if is_modified()==1 then
      save_session(dd2)
    end
  end
  session_sel(fileid,dd)
end

function exit_session(dd)
  save_session()
  close_session()
  disp(dd)
end

function exit_all(dd)
  local dd2 = 1
  while (true) do
     exit_session(dd2)
  end
end

function quit_session(force,dd)
  force = force or false
  local not_saved_yet = is_modified()
  local numsessions = get_numsessions()
  if not force and not_saved_yet==1 and numsessions>0 then
    local id = get_fileid()
    local prompt = "Save '" .. get_filename(id) .. "' <y/n>?";
    if get_yesno(prompt)=="Y" then
      save_session()
    end
  end
  close_session()
  disp(dd)
end

function quit_all(force, dd)
  local dd2 = 1
  force = force or false
  while (true) do
     quit_session(force, dd2)
  end
end

function open_file(filename,dd)
  local dd2 = 1
  if filename==nil then
    filename = lued_prompt("Enter Filename: ","open_file")
  end
  if (filename~=nil and filename~="") then
    local fileid = lued_open(filename)
    if fileid~=nil and fileid~=0 then
       set_fileid(fileid)
       first_line(dd2)
    end
  end
  disp(dd)
end

function new_file(filename, dd)
  local dd2 = 1
  local fileid = lued_open("")
  if filename == nil then
    local default_filename = "lued_untitled_"..fileid..".txt"
    filename = lued_prompt("Enter Filename (default: '"..default_filename.."'): ","new_file")
    if filename == nil or filename=="" then
      filename = default_filename
    end
  end
  set_fileid(fileid)
  save_as(filename,dd)
end

function set_page_offset_percent(offset,dd)
  local tr,tc = get_termsize()
  local r,c = get_cur_pos()
  if offset == nil then
    offset = math.floor(tr / 2)
  elseif 0.0 < offset and offset < 1.0 then
    offset = math.floor(offset*tr*100 + 0.5) / 100
  elseif offset < 0 then
    offset = tr + offset
    if offset < 0 then offset = 0 end
  else
    if offset >= tc-1 then offset = tc-1 end
  end
  set_page_offset(offset,0)
  page_offset = offset
  if (dd==0) then disp(dd) end
end

function undo_cmd(dd)
  undo()
  disp(dd)
end

function redo_cmd(dd)
  redo()
  disp(dd)
end

function set_nameless_mark(dd)
  local dd2 = 1
  g_nameless_stack = g_nameless_stack or 0
  set_mark("nameless_" .. g_nameless_stack)
  g_nameless_stack = g_nameless_stack + 1
  local r,c = get_cur_pos()
  sol_classic(dd2)
  set_sel_start()
  eol(dd2)
  set_sel_end()
  disp()
  lued_prompt(" - Mark set on line# "..r..". Alt+MM returns to this line. Press <Enter> to continue...","hit_cr")
  set_sel_off()
  disp()
end

function goto_nameless_mark_prev()
  g_nameless_stack = g_nameless_stack or 1
  if g_nameless_stack==0 then g_nameless_stack = 1 end
  g_nameless_stack = g_nameless_stack - 1
  goto_mark("nameless_" .. g_nameless_stack)
  disp()
end

function goto_nameless_mark_next()
  g_nameless_stack = g_nameless_stack or 0
  g_nameless_stack = g_nameless_stack + 1
  local found = goto_mark("nameless_" .. g_nameless_stack)
  if not found then g_nameless_stack = g_nameless_stack - 1 end
  disp()
end

function decset(val)
  val = val or 1000
  set_min_lines_from_top(0)
  set_min_lines_from_bot(0)
  local esc = string.char(27)
  local csi = esc .. "["
  io.write( csi .. "?" .. val .. "h" )
end

function decrst(val)
  val = val or 1000
  set_min_lines_from_top()
  set_min_lines_from_bot()
  local esc = string.char(27)
  local csi = esc .. "["
  io.write( csi .. "?" .. val .. "l" )
end

function mouse(val)
  if val==nil then
    if g_decset==nil or g_decset==0 then
      val = 1000
    else
      val = 0
    end
  end

  if g_decset and g_decset~=0 and val~=g_decset then
    decrst(g_decset)
  end
  if (val~=0) then -- 9 = x10 1000 = normal
    decset(val)
  else
    decrst(g_decset)
  end
  g_decset = val;
end

function mouse_event(str)
  local dd2 = 0
  local Cb = string.byte(str,1) - 32
  local Cx = string.byte(str,2) - 32
  local Cy = string.byte(str,3) - 32
  print("***",str,"***",Cb,Cx,Cy)
  local r,c = get_cur_pos()
  local pr,pc = get_page_pos()
  if Cb==0 then -- mouse down
    g_mouse_down_x = Cx
    g_mouse_down_y = Cy
    set_cur_pos(pr+Cy-2,Cx)
  elseif Cb==3 then -- mouse up
    print("MUP",Cx,Cy,g_mouse_down_x,g_mouse_down_y);
    if (Cx~=g_mouse_down_x or Cy~=g_mouse_down_y) then
      set_sel_start()
      set_cur_pos(pr+Cy-2,Cx)
      -- set_sel_end()
    end
  elseif Cb==64 then
    line_up(2,dd2)
  elseif Cb==65 then
    line_down(2,dd2)
  else
    dd2 = 1
  end
  disp(dd2)
end

function relued(dd)
  dofile("lued.lua")
  disp(dd)
end

function spare()
  lued_prompt(" Undefined control character. Press <Enter> to continue...","hit_cr")
  disp()
end

function dont_use()
  lued_prompt(" Please do not use this control character. Press <Enter> to continue...","hit_cr")
  disp()
end

function logo()
  -- logo generated by:
  -- http://patorjk.com/software/taag/#p=display&f=Big&t=LuEd%20v0%20.%2010


  local logo = [=[

  _           ______    _          ___        __  ___
 | |         |  ____|  | |        / _ \      /_ |/ _ \
 | |    _   _| |__   __| | __   _/ | | \      | | | | |
 | |   | | | |  __| / _` | \ \ / / | |        | | | | |
 | |___| |_| | |___| (_| |  \ V /\ |_| /  _   | | |_| |
 |______\__,_|______\__,_|   \_/  \___/  (_)  |_|\___/
]=]

return logo
end

function help(n,dd)
  n = n or 1
  local basic_help = [[
Basic Operations
- ** JUST TYPE!!!! **
- Arrow keys, Delete, Backspace, PgUp, PgDn, Home and End work as expected.
- Shift+Delete deletes a line
- Ctrl+s and Ctrl+q save and quit as expected
- Ctrl+z / Ctrl+y undo/redo as expected.
- Ctrl+f finds and Alt+l finds again (Ctrl+h finds in reverse direction)
- Ctrl+r for Find and Replace
- Ctrl+t moves to Top (first line). Double tap goes to last line
- Alt+s moves left one word, Alt+f moves right one word
- Alt+a moves to start of line, Alt+g moves to end of line
- Ctrl+d deletes character, Alt+d backspaces char
Cut / Copy / Paste
- Alt+z starts selecting (similar to mouse press and hold)
- Ctrl+x / Ctrl+c / Ctrl+v cut, copy and paste as expected.
- A common cut and paste sequence is Alt+z, move, Ctrl+c, move Ctrl+v
- Ctrl+d is the same as the delete key; Alt+d is the same as backspace key

Try the Scroll Wheel... It should work
Try Mouse select, right mouse button to copy/paste... It should work too.

More Help
- Alt+help2 shows more help
]]

  local advanced_help = [[
Control Keys
 Q (Quit),      W (Close),    E (Spare),  R (Replace),    T (Spare)
 Y (Redo),      U (Spare),    I (Tab),    O (Open File),  P (Spare)
 A (Start Sel), S (Save),     D (Delete), F (Find),       G (Spare)
 H (Find Back), J (Dont Use), K (Spare),  L (Spare),
 Z (Undo),      X (Cut),      C (Copy),   V (Paste),      B (Show Buffers)
 N (New),       M (Dont Use)

Select Commands
- Alt+z starts selecting
  Alt+z,<Home> selects from beginning of line to cursor
  Alt+z,<End> selects from cursor to end of line
  Alt+z,Alt+f selects word. Keep hitting Alt+f to select more words
- Alt+k selects the current word
  A common sequence is Alt+k, Alt+l to select a word and then find it
  Keep hitting Alt+k to select more words

Delete/Cut/Copy Commands
- Alt+b deletes to start of line  (Same as Alt+z,<Home>,<Delete>)
- Alt+e deletes to end of line    (Same as Alt+z,<End>,<Delete>)
- Alt+x deletes current line      (Same as Shift+Delete)
- Alt+w deletes to end of word    (Same as Alt+z,Alt+f,<Delete>)
- Alt+c copies current line to paste buffer. Repeat to copy more lines.

- Alt+l420<enter> goes to line 420

Multiple Files
- Ctrl+o opens a file and Ctrl-N creates a new file
- Ctrl+b shows a selectable list of all file buffers
- Alt+Shift+B goes to previous file buffer (useful when working with two files)

More Help
- <alt>help for basic edit commands
- <alt>help3 for less help
]]

local lua_help = [[

tbd...
More Help
- <alt>help for basic edit commands
- <alt>help2 for more features
]]

  disp(dd)
  if (n==1) then
    print (logo())
    print (basic_help)
  elseif (n==2) then
    print (logo())
    print (advanced_help)
  else
    print (logo())
    print (lua_help)
  end
  hit_cr()
  disp(dd)
end

function copy_line(n,dd)
  n = n or 1
  local dd2 = 1
  sol_classic(dd2)
  set_sel_start()
  line_down(n,dd)
  set_sel_end()
  copy(dd2)
  sol_classic(dd)
end

function hit_cr()
  lued_prompt("Press <Enter> to continue...","hit_cr")
end

function select_open_file_menu(filter)
  local n = get_numsessions()
  print "\n"
  print ("select_open_file (ss)")
  local id = get_fileid()
  local found_i = 0
  local found_count = 0
  for i=1,n do
    local is_changed = is_modified(i) and "* " or "  "
    local is_current = i==id and "->" or "  "
    local line = is_current..i..is_changed..get_filename(i)
    if filter==nil or string.find(line,filter) then
      if id==n and found_i==0 or id~=n and found_i <= id then
        found_i = i
      end
      found_count = found_count + 1
      print (line)
    end
  end
  if found_count > 1 then found_i = 0 end
  return found_i
end

function select_open_file(filter)
  local id = get_fileid()
  local new_id = id
  local found_i = 0
  repeat
    found_i = select_open_file_menu(filter)
    if found_i ~= 0 then
      new_id = found_i
    else
      local hot = nil -- hot_range('a','z') .. hot_range('A','Z') .. ",-,_,"
      -- print (hot); io.read()
      new_id = lued_prompt("Enter File Id Number: ","select_open_file",hot)
      local new_id_int = tonumber(new_id)
      if new_id_int==nil then
        filter = new_id
      elseif new_id_int==0 then
        new_id = id
        found_i = id
      else
        found_i = new_id_int
      end
    end
  until found_i > 0
  if (new_id~=id) then
    session_sel(new_id)
  else
    disp()
  end
end

-- key bindings
-- set_hotkeys(",1,2,3,df,dg,dh,dd,ds,da,")
  set_hotkeys( ",a,AI,B,c,d,e,ED,EE,EX,f,g,h"..
               ",IS,k,l,LN,LU,m,MM,Mn,MN,Mp"..
               ",ob,ol,om,oo,ot,ou,s,Sall,Sb,Se"..
               ",Sn,Sp,sw,r,t,v,w,x,z,")

  set_repeatables(",ctrl_F,")
-- set_repeatables(",,")
  set_non_repeatables(",bo,sb,se,sl,sn,so,sp,sw,to,")

-- alt-
-- esc-
a =   sol -- hot
AI =  toggle_auto_indent
b =   select_open_file -- not hot
b_squote = select_open_file
B =   buffer_prev -- hot
c =   function(n) -- hot
  local dd2 = 1
  local r = get_cur_pos()
  local sel_sr = r
  set_cur_pos(r,1)
  if is_sel_on() then
    _,sel_sr = get_sel()
    sel_sr = sel_sr + 1
    set_cur_pos(sel_sr,1)
  end
  set_sel_start()
  set_cur_pos(r+1,1)
  set_sel_end()
  global_copy(dd2)
  set_cur_pos(sel_sr,1)
  set_sel_start()
  set_cur_pos(r+1,1)
  set_sel_end()
  disp(dd)
end

-- c =   copy_line -- copy current line to paste buffer
C =   copy_line -- C5 copies 5 lines to paste buffer
Ci =  function() set_case_sensitive(0) end -- used for find/search
Cs =  set_case_sensitive -- used for find/search
d =   del_backspace
-- d =   del_line -- delete N lines (Alt+d12)
e =   cut_eol
ED =  set_edit_mode
Efc = set_enable_file_changed -- efc1 enables; efc0 disables
EE =  exit_session -- save and close current session
EX =  exit_all -- save and close all sessions
f =   word_right
g =   eol
h = find_reverse_again
I_squote = indent_scope
IS =  indent_scope
k = function() if is_sel_off()==1 then sel_word() else word_right() end end
l = find_forward_again
LN =  toggle_line_numbers
LU =  set_lua_mode
M_squote = function(name) set_mark(name); disp() end
M_squote = function(name) goto_mark(name); disp() end
m = set_nameless_mark
MM = goto_nameless_mark_prev
Mn = goto_nameless_mark_next MN = goto_nameless_mark_next
Mp = goto_nameless_mark_prev
mlft = set_min_lines_from_top
mlfb = set_min_lines_from_bot
ob =  function() set_page_offset_percent(0.99,0) end -- align cursor to bottom
ol =  function() set_page_offset_percent(0.75,0) end -- align cursor to lower
om =  function() set_page_offset_percent(0.5,0) end  -- align cursor to middle
ot =  function() set_page_offset_percent(0.01,0) end -- align cursor to top
ou =  function() set_page_offset_percent(0.25,0) end -- align cursor to upper
--oo =  cr_before   OO = cr_after
Ps =  set_pagesize -- used by page_up / page_down
Ralt = remove_all_leading_tabs
Rats = remove_all_trailing_space
Ratsall = remove_all_trailing_space_all_files
Relued = relued -- reload lued script
r =  find_reverse
Rt =  set_replace_tabs -- rt0 rt4
Rts = toggle_remove_trailing_spaces
s =   word_left
-- S =  function(n) sol_classic(1); set_sel_start(1); line_down(n); end
S = save_file
Sb =  function() set_sel_start(); sol(); end
Sall = search_all
Saveall = save_all
Se =  function() set_sel_start(); eol(); end
Si =  set_scope_indent -- si2 si3 si4
Sn =  session_next
Sow = skip_spaces
Sw =  function() word_start(1); set_sel_start(); var_end(1); set_sel_end(); disp(); end
t  =  toggle_top
up =  line_up -- up23 moves up 23 lines
v =   global_paste
w =   del_eow
x =   del_line -- hotkey cut line
X =   del_line -- Not hot key
z =   sel_toggle
_colon_w = save_file
_colon_wq = quit_session

f_squote = find
_squote = find
_fslash = find
o_squote = open_file
new_squote = new_file
p_squote = set_paste_buffer
sa_squote = save_as

num_1 = sel_toggle
num_2 = sel_word
num_3 = sel_line

ctrl_Q = quit_all
ctrl_W = quit_session
ctrl_E = spare
ctrl_R = find_and_replace
ctrl_T = spare

ctrl_Y = redo_cmd
ctrl_U = spare
ctrl_I = insert_tab -- terminal <Tab> key (do not change)
ctrl_O = open_file
ctrl_P = spare

ctrl_A = sel_all
ctrl_S = save_file
ctrl_D = del_char
ctrl_F = find_forward
ctrl_G = spare

ctrl_H = spare
ctrl_J = dont_use  -- Same as <Enter>
ctrl_K = spare
ctrl_L = spare

ctrl_Z = undo_cmd
ctrl_X = global_cut
ctrl_C = global_copy
ctrl_V = paste
ctrl_B = spare

ctrl_N = new_file
ctrl_M = dont_use -- Same as <Enter>

-- These keys produce escape sequences (escape is not pressed)
esc_backspace = del_backspace
esc_insert = toggle_overtype
esc_delete = del_char
esc_shift_delete = del_line
--function() if is_sel_on() then sol_classic(1) set_sel_start() end line_down(1,1) end
esc_up = line_up
esc_down = line_down
esc_left = char_left
esc_right = char_right
esc_home = sol
esc_end = eol
esc_pageup = page_up
esc_pagedown = page_down
esc_mouse = mouse_event
esc_pastestart = bracket_paste_start
esc_pastestop  = bracket_paste_stop

set_edit_mode(0)
if first_time == nil then
  local dd2 = 1
  first_time = 1
  os.execute("stty -ixon")
  decset(1000)
  os.execute("stty intr ''")
--  os.execute("stty intr ^A")
  os.execute("stty susp undef")
--  open_file("files/bigfile.txt", dd2)
--  open_file("files/testfile2.txt", dd2)
--  open_file("files/testfile.txt", dd2)
  set_fileid(1,dd2)
  first_line(0)
  mouse(0)
  if g_show_help==true then help(1,0) end
end


function walter()
  local r,c = get_cur_pos()
  for i=1,10 do
    for j=1,70 do
      ins_str(".",1)
    end
    ins_str("\n",1)
  end

  set_cur_pos(r,c)
  for i = 0,9 do
    set_cur_pos(r+i,2)
    del_char(1,1)
    ins_str(" ",1)
  end
  disp()
end


-- str = w('* ,+-20,=20,()8\n',20)
-- str="* ,.60,\n"
function walter2(str,n)
  n = n or 1
  local result = ""
  for word in string.gmatch(str, '([^,]+)') do
    if not string.find(str,'%d$') then
      str = str .. '1'
    end
--    local letter = string.match(word,'^(%D+)')
--    local rep = string.match(word,'(%d+)$')
    local letter = string.match(word,'(%D+)')
    local null,rrr = string.match(word,'(%D+)(%d+)')
    if rrr==nil then rrr = 1 end
    -- print ("999999",str,word,letter,rrr,"00000")
    local letters = string.rep(letter,rrr)
    result = result .. letters
  end
  local final_result = ""
  for i=1,n do
    final_result = final_result .. result
  end
  ins_str(final_result)
end

function hi()
  w('****,*10,**,*10,**,*10,\n',1)
  w('**  ,*10,  ,*10,  ,*10,\n',4)
  w('**  , 10,  ,*10,  ,*10,\n',1)
  w('**  ,*10,  ,*10,  ,*10,\n',4)
  w('****,*10,**,*10,**,*10,\n',1)
end
