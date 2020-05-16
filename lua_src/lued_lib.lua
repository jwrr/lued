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

lued = {}

lued.g_buffer = ""    -- The global buffer is used for lued.cut and lued.paste between multiple files.


lued.csi = {}

local fg = {}
local bg = {}
for i=0,7 do
  fg[i]      = tostring(30+i)
  fg[i+8]    = tostring(90+i)
  bg[i]      = tostring(40+i)
  bg[i+8]    = tostring(100+i)
end

lued.csi.fg = fg
lued.csi.bg = bg


function lued.prompt2(prompt)
  prompt = prompt or "--> "
  io.write(" ")
  str = io_read(nil,prompt,"",nil)
  return str
end

function lued.dbg_prompt(dbg_str)
  local str = ""
  -- repeat
    local prompt = "DBG> "..dbg_str..": "
    str = lued.prompt2(prompt)
  return str
end


function lued.set_style(fg,bg,decorations)
-- lued.csi.normal  = "0"
-- lued.csi.reset   = "0"
-- lued.csi.bold    = "1"
-- lued.csi.under   = "4"
-- lued.csi.blink   = "5"
-- lued.csi.inverse = "7"
--    local CSI = "esc["
  local CSI = string.char(27) .. '['

  local code = ""
  if decorations ~= nil then
    if type(decorations)=="table" then
      for i=1,#decorations do
        code = code=="" and CSI or code..";"
        code = code .. tostring(decorations[i])
      end
    else
      code = code=="" and CSI or code..";"
      code = code .. tostring(decorations)
    end
  end
  if fg ~= nil then
    local fg_code = tostring( fg<8 and fg+30 or fg+90-8 )
    code = code=="" and CSI or code..";"
    code = code .. fg_code
  end
  if  bg ~= nil then
    local bg_code = tostring( bg<8 and bg+40 or bg+100-8 )
    code = code=="" and CSI or code..";"
    code = code .. bg_code
  end
  code = code=="" and "" or code.."m"

--    lued.dbg_prompt("code="..code.."dec="..decorations.."xxx")
  return code;
end


local styles = {}
styles.enable               = false
styles.reset                = lued.set_style( nil, nil, 0 )
styles.normal               = lued.set_style( nil, nil, 0 )
styles.inverse              = lued.set_style( nil, nil, 7 ) -- inverse
styles.cursor               = lued.set_style( nil, nil, {1,5,7} ) -- bold,blink,inverse
--     lued.dbg_prompt("code="..styles.cursor.."xxx"); os.exit()
styles.cursor_line          = lued.set_style( nil, 8  , nil )
styles.line_number          = lued.set_style( 8,  nil , 0)
styles.cursor_line_number   = lued.set_style( 15, 8   , 0)
styles.sb_files             = lued.set_style( 7, nil   , 0)
styles.comment              = lued.set_style( 8,  nil , 0 )
styles.comment_regex        = "//[^\n]*"
styles.comment_regex2       = "%-%-[^\n]*"
styles.comment_regex3       = "%-%-[^\n]*"
styles.string               = lued.set_style( 3,  nil       , 0 )
styles.string_regex         = "[\"][^\"][\"]"

-- Lua Magic: (   )   .   %   +   –   *   ?   [   ^   $

styles.fg0                  = lued.set_style ( 0, nil , 0)
styles.fg1                  = lued.set_style ( 1, nil , 0)
styles.fg2                  = lued.set_style ( 2, nil , 0)
styles.fg3                  = lued.set_style ( 3, nil , 0)
styles.fg4                  = lued.set_style ( 4, nil , 0)
styles.fg5                  = lued.set_style ( 5, nil , 0)
styles.fg6                  = lued.set_style ( 6, nil , 0)
styles.fg7                  = lued.set_style ( 7, nil , 0)
styles.fg8                  = lued.set_style ( 8, nil , 0)
styles.fg9                  = lued.set_style ( 9, nil , 0)
styles.fg10                 = lued.set_style ( 10, nil , 0)
styles.fg11                 = lued.set_style ( 11, nil , 0)
styles.fg12                 = lued.set_style ( 12, nil , 0)
styles.fg13                 = lued.set_style ( 13, nil , 0)
styles.fg14                 = lued.set_style ( 14, nil , 0)
styles.fg15                 = lued.set_style ( 15, nil , 0)
styles.bg0                  = lued.set_style ( nil, 0  ,  0)
styles.bg1                  = lued.set_style ( nil, 1  ,  0)
styles.bg2                  = lued.set_style ( nil, 2  ,  0)
styles.bg3                  = lued.set_style ( nil, 3  ,  0)
styles.bg4                  = lued.set_style ( nil, 4  ,  0)
styles.bg5                  = lued.set_style ( nil, 5  ,  0)
styles.bg6                  = lued.set_style ( nil, 6  ,  0)
styles.bg7                  = lued.set_style ( nil, 7  ,  0)
styles.bg8                  = lued.set_style ( nil, 8  ,  0)
styles.bg9                  = lued.set_style ( nil, 9  ,  0)
styles.bg10                  = lued.set_style ( nil, 10  ,  0)
styles.bg11                  = lued.set_style ( nil, 11  ,  0)
styles.bg12                  = lued.set_style ( nil, 12  ,  0)
styles.bg13                  = lued.set_style ( nil, 13  ,  0)
styles.bg14                  = lued.set_style ( nil, 14  ,  0)
styles.bg15                  = lued.set_style ( nil, 15  ,  0)


-- lued.dbg_prompt("\n" ..
--            styles.fg0 .. "000000" ..
--            styles.fg1 .. "111111" ..
--            styles.fg2 .. "222222" ..
--            styles.fg3 .. "333333" ..
--            styles.fg4 .. "444444" ..
--            styles.fg5 .. "555555" ..
--            styles.fg6 .. "666666" ..
--            styles.fg7 .. "777777" .. "\n" ..
--            styles.fg8 .. "888888" ..
--            styles.fg9 .. "999999" ..
--            styles.fg10 .. "aaaaaa" ..
--            styles.fg11 .. "bbbbbb" ..
--            styles.fg12 .. "cccccc" ..
--            styles.fg13 .. "dddddd" ..
--            styles.fg14 .. "eeeeee" ..
--            styles.fg15 .. "ffffff" .. "\n" ..
--            styles.bg0 .. "0     " ..
--            styles.bg1 .. "1     " ..
--            styles.bg2 .. "2     " ..
--            styles.bg3 .. "3     " ..
--            styles.bg4 .. "4     " ..
--            styles.bg5 .. "5     " ..
--            styles.bg6 .. "6     " ..
--            styles.bg7 .. "7     " .. "\n" ..
--            styles.bg8 .. "8     " ..
--            styles.bg9 .. "9     " ..
--            styles.bg10 .. "a     " ..
--            styles.bg11 .. "b     " ..
--            styles.bg12 .. "c     " ..
--            styles.bg13 .. "d     " ..
--            styles.bg14 .. "e     " ..
--            styles.bg15 .. "f     "
--           )
--



function lued.init_lued(lued_path, bindings_file)
  lued.load_plugins( lued_path .. "/plugins" )
  dofile( bindings_file)

  local dd2 = 1
  lued.set_ctrl_s_flow_control(false,dd2)
  lued.set_ctrl_c_abort(false,dd2)
  lued.set_ctrl_z_suspend(false,dd2)
  lued.decset(1000)
  set_fileid(1,dd2)
--  set_cur_pos(1,1)
  lued.mouse_config(0)
--  if g_show_help then lued.help(1,0) end
-- end

  lued.set_edit_mode(0)
  lued.disp()
end


function lued.clr_sb_files(dd)
  g_show_sb_files = false
  set_show_line_numbers(0)
  lued.disp(dd)
end


function lued.set_sb_files(dd)
  g_show_sb_files = true
  set_show_line_numbers(0)
  lued.disp(dd)
end


function lued.clr_abs_line_numbers(dd)
  g_show_abs_line_numbers = false
  set_show_line_numbers(0)
  lued.disp(dd)
end

function lued.set_abs_line_numbers(dd)
  g_show_abs_line_numbers = true
  set_show_line_numbers(0)
  lued.disp(dd)
end


function lued.clr_rel_line_numbers(dd)
  g_show_rel_line_numbers = false
  set_show_line_numbers(0)
  lued.disp(dd)
end


function lued.set_rel_line_numbers(dd)
  g_show_rel_line_numbers = true
  set_show_line_numbers(0)
  lued.disp(dd)
end


function lued.toggle_review_mode(dd)
  g_review_mode = g_review_mode or false
  g_review_mode = not g_review_mode
  lued.disp(dd)
end


-- disable/enable ctrl+S ctrl+Q XON/XOFF Flow Control
function lued.set_ctrl_s_flow_control (bool, dd)
  if bool==nil then
    g_ctrl_s_flow_control = not g_ctrl_s_flow_control
  else
    g_ctrl_s_flow_control = bool
  end
  if g_ctrl_s_flow_control==true then
    os.execute("stty ixon ixoff")
  else
    os.execute("stty -ixon -ixoff")
  end
  lued.disp(dd)
end


-- disable/enable ctrl+C abort
function lued.set_ctrl_c_abort (bool, dd)
  if bool==nil then
    g_ctrl_c_abort = not g_ctrl_c_abort
  else
    g_ctrl_c_abort = bool
  end
  if g_ctrl_c_abort==true then
    os.execute("stty intr ^C")
  else
    os.execute("stty intr undef")
  end
  lued.disp(dd)
end


-- disable/enable ctrl+Z suspend
function lued.set_ctrl_z_suspend (bool, dd)
  local change = true
  if bool==nil then
    g_ctrl_z_suspend = not g_ctrl_z_suspend
  else
    change = (g_ctrl_z_suspend ~= bool)
    g_ctrl_z_suspend = bool
  end
  if change then
    if g_ctrl_z_suspend==true then
      os.execute("stty susp ^Z")
    else
      os.execute("stty susp undef")
    end
  end
  lued.disp(dd)
  return change
end


function lued.toggle_ctrl_z_suspend (dd)
  lued.set_ctrl_z_suspend(not g_ctrl_z_suspend,dd)
end


function lued.toggle_ctrl_c_abort (dd)
  lued.set_ctrl_c_abort(not g_ctrl_c_abort,dd)
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


function lued.bracket_paste_start(dd)
  g_bracket_paste = 1
  lued.clr_auto_indent()
end


function lued.bracket_paste_stop(dd)
  g_bracket_paste = 0
  lued.set_auto_indent(dd)
end


function lued.set_tab_size(val,dd)
  val = val or 0
  g_tab_size = val
  lued.disp(dd)
end


function lued.toggle_remove_trailing_spaces(dd)
  g_remove_trailing_spaces = not g_remove_trailing_spaces
  lued.disp(dd)
end


function lued.toggle_show_trailing_spaces(dd)
  g_show_trailing_spaces = not g_show_trailing_spaces
  lued.disp(dd)
end


function lued.set_scope_indent(val,dd)
  val = val or 1
  g_scope_indent = val
  lued.disp(dd)
end


function lued.set_min_lines_from_top(val,dd)
  if val==nil then val = 5 end
  g_min_lines_from_top = val
  lued.disp(dd)
end


function lued.set_min_lines_from_bot(val,dd)
  if val==nil then val = 7 end
  g_min_lines_from_bot = val
  lued.disp(dd)
end


function lued.toggle_enable_file_changed(dd)
  g_enable_file_changed = not g_enable_file_changed
  lued.disp(dd)
end


function lued.toggle_express_mode(dd)
  g_express_mode = not g_express_mode
  lued.disp(dd)
end

function lued.set_find_case_sensitive(dd)
  g_find_case_sensitive = true
  lued.disp(dd)
end

function lued.clr_find_case_sensitive(dd)
  g_find_case_sensitive = false
  lued.disp(dd)
end

function lued.get_find_whole_word()
  return g_find_whole_word
end

function lued.set_find_whole_word(dd)
  g_find_whole_word = true
  lued.disp(dd)
end

function lued.clr_find_whole_word(dd)
  g_find_whole_word = false
  lued.disp(dd)
end

function lued.toggle_find_whole_word(dd)
  g_find_whole_word = not g_find_whole_word
  lued.disp(dd)
end


function lued.get_overtype()
  return g_overtype
end


function lued.set_overtype(val,dd)
  val = val or 0
  g_overtype = val
  lued.disp(dd)
end


function lued.toggle_overtype(dd)
  g_overtype = g_overtype or 0
  g_overtype = (g_overtype+1) % 2
  lued.disp(dd)
end


function lued.toggle_doublespeed(dd)
  g_double_speed = g_double_speed or 0
  g_double_speed = (g_double_speed+1) % 2
  lued.disp(dd)
end


function lued.is_sol()
  local r,c = get_cur_pos()
  return c <= 1
end


function lued.is_eol()
  local r,c = get_cur_pos()
  return c > get_line_len()
end


function lued.is_sof()
  local r,c = get_cur_pos()
  return c <= 1 and r <= 1
end

-- Two modes are supported. When line string is passed in the char at `pos` is
-- checked. When line is nil then the char under the cursor is checked.
function lued.is_space(line,pos)
  local is
  if line and line ~= "" then
    is = string.match(line,"^%s",pos) and true or false
  else
    local offset = pos
    local ch = lued.get_char(offset)
    -- lued.dbg_prompt ("is_space="..ch.."xxx")
    is = string.match(ch,"^%s",1) and true or false
  end
  return is
end


function lued.is_punct(line,pos)
  pos = pos or 1
  local ch = line and string.sub(line,pos,pos) or lued.get_char()
  return string.match(ch,"^%p",pos) and true or false
end


function lued.is_word(line,pos)
  local is;
  if line then
    is = string.match(line,"^[%w_]",pos) and true or false
  else
    is = string.match(lued.get_char(),"^[%w_]",1) and true or false
  end
  return is
end


function lued.is_pattern(pattern, line,pos)
  local is;
  if line then
    is = string.match(line, "^"..pattern, pos) and true or false
  else
    is = string.match(lued.get_char(), "^"..pattern, 1) and true or false
  end
  return is
end


-- not word and not space
function lued.is_other(line,pos)
  local is = not (lued.is_word() or lued.is_space())
  return is;
end

function lued.prev_is_space()
  local dd2 = 1
  if lued.is_sol() then return false; end
  lued.move_left_n_char(1,dd2)
  local is = lued.is_space()
  lued.move_right_n_char(1,dd2)
  return is;
end


function lued.next_is_space()
  local dd2 = 1
  if lued.is_eol() then return false; end
  lued.move_right_n_char(1,dd2)
  local is = lued.is_space()
  lued.move_left_n_char(1,dd2)
  return is;
end


function lued.prev_is_word()
  local dd2 = 1
  if lued.is_sol() then return false; end
  lued.move_left_n_char(1,dd2)
  local is = lued.is_word()
  lued.move_right_n_char(1,dd2)
  return is;
end


function lued.next_is_word()
  local dd2 = 1
  if lued.is_eol() then return false; end
  lued.move_right_n_char(1,dd2)
  local is = lued.is_word()
  lued.move_left_n_char(1,dd2)
  return is;
end



function lued.prev_is_other()
  local dd2 = 1
  if lued.is_sol() then return false; end
  lued.move_left_n_char(1,dd2)
  local is = lued.is_other()
  lued.move_right_n_char(1,dd2)
  return is;
end

function lued.next_is_other()
  local dd2 = 1
  if lued.is_eol() then return false; end
  lued.move_right_n_char(1,dd2)
  local is = lued.is_other()
  lued.move_left_n_char(1,dd2)
  return is;
end



function lued.is_sow()
  local r,c = get_cur_pos()
  local line = get_line()
  local prev_boundary = (c==1) or lued.is_space(line,c-1)
  local is = prev_boundary and not lued.is_space(line,c)
  return is
end


function lued.is_firstline()
  local r,c = get_cur_pos()
  return r <= 1
end


function lued.is_lastline()
  local r,c = get_cur_pos()
  local num_lines = get_numlines()
  return r >= num_lines
end


function lued.is_eof()
  return lued.is_lastline() and lued.is_eol()
end


function lued.is_sel_on()
  return not (is_sel_off()==1)
end


function lued.is_blankline(line)
  line = line or get_line()
  local found = string.find(line,"^%s*$")
  local is = found~=nil
  return is
end


function lued.set_edit_mode(dd)
  g_lua_mode = false
  local keys = get_hotkeys()
  keys = "all" .. keys
  set_hotkeys(keys)
  lued.disp(dd)
end


function lued.set_lua_mode(dd)
  g_lua_mode = true
  local keys = get_hotkeys()
  keys = string.gsub(keys,"(all)","")
  print ("KEYS2="..keys)
  set_hotkeys(keys)
  lued.disp(dd)
end


function lued.remove_trailing_spaces(next_row,next_col,force,dd)
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
      if not lued.is_eol() then
        lued.del_eol(dd2)
      end
    end
  end
  if next_row > 0 and next_col > 0 then
    set_cur_pos(next_row,next_col)
    local numlines = get_numlines()
    if next_row > numlines then
      next_row = numlines
      lued.move_to_eol(dd2);
    end
    if (next_row ~= row) then
      saved_line = get_line()
    end
  else
    saved_line = ""
  end
  lued.disp(dd)
end


function lued.remove_all_trailing_space(dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  local pr,pc = get_page_pos()
  local numlines = get_numlines()
  for i=1,numlines do
    set_cur_pos(i,1)
    lued.remove_trailing_spaces(0,0,true,dd2)
  end
  set_cur_pos(r,c)
  set_page_pos(pr,pc)
  lued.disp(dd)
end


function lued.remove_all_trailing_space_all_files(dd)
  local dd2 = 1
  local fileid = get_fileid()
  local num_sessions = get_numsessions()
  for i=1,num_sessions do
    lued.session_sel(i,dd2)
    lued.remove_all_trailing_space(dd2)
  end
  lued.session_sel(fileid,dd)
end


function lued.remove_all_leading_tabs(tab_size,dd)
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
      lued.del_sel(dd2)
      ins_str(leading_ws,dd2)
    end
  end -- for
  set_cur_pos(r,c)
  lued.disp(dd)
end


function lued.leading_ws()
  local line = get_line()
  local ws = string.match(line,"^%s+") or ""
  local ws_len = string.len(ws)
  return ws, ws_len
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


-- \brief Make next line's leading whitespace the same as current line's leading whitespace.
function lued.align_start_of_next_line(dd)
  local dd2 = 1
  local ws1,ws1_len = lued.leading_ws()
  lued.move_down_n_lines(1,dd2)
  lued.move_to_sol_classic(dd2)
  local ws2,ws2_len = lued.leading_ws()
  lued.del_char(ws2_len,dd2)
  ins_str(ws1,dd2)
  lued.disp(dd)
end


-- \brief Fix jagged left edges by making leading white space of all selected lines the same as first selected line.
function lued.align_selected(dd)
  lued.foreach_selected(lued.align_start_of_next_line, dd)
end


function lued.replace_line(newline,dd)
  newline = newline or ""
  local dd2 = 1
  local line = get_line() or ""
  if newline ~= line then
    lued.move_to_sol_classic(dd2)
    ins_str(newline,dd2);
    lued.del_eol(dd2);
  end
  lued.disp(dd)
end


function lued.get_next_line()
  local dd2 = 1
  local r,c = get_cur_pos()
  set_cur_pos(r+1,c)
  local next_line = get_line()
  set_cur_pos(r,c)
  return next_line
end


-- \brief Align delimiter of next line with the same delimiter on current line
function lued.align_delimiter_of_next_line(delim, dd)
  g_align_delimiter_of_next_line = g_align_delimiter_of_next_line or "="
  delim = delim or "="
  local dd2 = 1
  local delim_pos1 = string.find( get_line(), g_align_delimiter_of_next_line, 1, true)
  if delim_pos1 then
    lued.move_down_n_lines(1,dd2)
    local line = get_line() or ""
    local delim_pos2 = string.find( line, g_align_delimiter_of_next_line, 1, true)
    if delim_pos2 then
      local r,c = get_cur_pos()
      set_cur_pos(r,delim_pos2)
      local delta = delim_pos1 - delim_pos2
      if delta > 0 then
        local ws = string.rep(" ", delta)
        ins_str(ws, dd2)
      elseif delta < 0 then
        delta = -1 * delta
        for i = 1, delta do
          if lued.is_sol() then break end
          lued.move_left_n_char(1,dd2)
          if not lued.is_space() then break end
          lued.del_char(1,dd2)
        end
      end
    end
  end
  lued.disp(dd)
end


function lued.get_char(offset)
  offset = offset or 0  -- offset is useful for getting next/prev char
  local r,c = get_cur_pos()
  local pos = c + offset
  pos = math.max(1, pos)
  pos = math.min(get_line_len(), pos)
  return string.sub( get_line() , pos, pos)
end


-- \brief Align delimiter in selected region
function lued.align_delimiter_selected(delim, dd)
  align_delimiter_selected_hist_id = align_delimiter_selected_hist_id or lued.get_hist_id()
  g_align_delimiter_of_next_line = delim or lued_prompt(align_delimiter_selected_hist_id, "Enter string to align: ") or "="
  lued.foreach_selected(lued.align_delimiter_of_next_line, dd)
end


function lued.align_cur_char(dd)
  local dd2 = 1
  local cur_char = lued.get_char()
  local r1,c1 = get_cur_pos()
  lued.move_down_n_lines(1,dd2)
  lued.move_to_sol_classic(dd2)
  found = lued.find_forward(cur_char,true,false,true,"",dd2)
  if not found then
    lued.disp(dd)
    return
  end

  set_sel_off()
  local r2,c2 = get_cur_pos();
  local done = c2 == c1
  local cnt = 0
  while not done do
    if c2 < c1 then
      ins_str(" ",dd2)
    else
      if lued.is_sol() or not lued.is_space("",-1) then
        done = true
      else
        lued.del_backspace(1,dd2)
        if not lued.is_space("",-1) then
          ins_str(" ",dd2)
          done = true
        end
      end
    end
    r2,c2 = get_cur_pos();
    cnt = cnt + 1
    done = done or (c2 == c1) or (cnt > 200)
  end
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


function lued.hot_range(lower,upper)
  local hot = ""
  for ch=string.byte(lower),string.byte(upper) do
    hot = hot .. "," .. string.char(ch)
  end
  if hot ~= "" then hot = hot .. "," end
  return hot
end


function lued_prompt(hist_id,prompt,hot,test_str)
  -- io.write(prompt)
  -- str = io.read()
  hist_id = hist_id or 0
  prompt = prompt or "--> "
  hot = hot or ""
  io.write(" ")
  str = io_read(hist_id,prompt,hot,test_str)
  return str
end


function lued.get_hist_id()
  get_hist_id_cnt = get_hist_id_cnt or 0
  get_hist_id_cnt = get_hist_id_cnt + 1
  return get_hist_id_cnt;
end


function lued.get_yesno(prompt,default)
  local yes = false
  local no = false
  local quit = false
  local all = false
  local valid_answer = false
  local answer = ""
  get_yesno_hist_id = get_yesno_hist_id or lued.get_hist_id()
  repeat
    answer = lued_prompt(get_yesno_hist_id,prompt .. " ")
    if default~=nil and answer==nil or answer=="" then answer = default end
    answer = string.upper(answer)
    yes = answer=="Y"
    no  = answer=="N"
    quit = answer=="Q"
    all = answer=="A"
    valid_answer = yes or no or quit or all
    if not valid_answer then
      io.write("'"..answer.."' is not valid. ")
    end
  until (valid_answer)
  return answer
end


function lued.esc_clear_screen()
  local ESC = string.char(27)
  local ESC_CLR_ALL  = ESC .. "[2J"
  local ESC_GO_HOME  = ESC .. "[H"
  io.write(ESC_CLR_ALL .. ESC_GO_HOME)
end


function lued.esc_rev(str)
  local ESC = string.char(27)
  local ESC_REVERSE  = ESC .. "[7m"
  local ESC_NORMAL   = ESC .. "[0m"
  return ESC_REVERSE .. str .. ESC_NORMAL
end


function lued.get_cur_filename()
  local id = get_fileid()
  local filename = get_filename(id)
  return filename
end

function lued.display_status_in_lua(lua_mode)
  lued.esc_clear_screen()
  set_sel_end(0)
  -- if not g_status_line_on then return end
  local id = get_fileid()
  local filename = get_filename(id)
  local save_needed = is_modified()
  local row,col = get_cur_pos()
  local trow,tcol = get_termsize()

  local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()

  local stay_selected = ((row == sel_er) and (col == sel_ec)) or
                        ((row == sel_sr) and (col == sel_sc))
  if (not stay_selected) then
    set_sel_off()
  end

  local mode_str = lua_mode and "LUA MODE" or "ED MODE"
  g_review_mode = g_review_mode or false
  if g_review_mode then
    mode_str = "REVIEW MODE"
  else
    mode_str = "EDIT MODE"
  end

  local cmd_str = get_last_cmd() or ""
  local max_cmd_len = 20
  cmd_str = string.sub(cmd_str,1,max_cmd_len)
  local pad_len = max_cmd_len - string.len(cmd_str);
  cmd_str = cmd_str .. string.rep(" ",pad_len)

  local save_str = save_needed and "*" or " "
  local stay_selected_int = stay_selected and 1 or 0

  local status_line = string.format(
          "%s - %s File (%d) %s%s Line: %d, Col: %d, Sel: %d Cmd: %s - sr=%d sc=%d er=%d ec=%d, staysel=%d\n",
          g_lued_version, mode_str, id, filename, save_str, row, col, sel_state, cmd_str, sel_sr, sel_sc, sel_er, sel_ec, stay_selected_int)
  status_line = string.sub(status_line,1,tcol)
  if g_status_line_reverse then
    status_line = lued.esc_rev(status_line)
  end
  io.write(status_line)
end


function explode (subject, sep,  lim)
  local sep = sep or "\n"
  lim = lim or -1 -- -1 means no limit
  local pieces = { }
  local subject_len = string.len(subject)
  local sep_len = string.len(sep)
  if (subject_len==0) or (sep_len==0) or (lim==0) then
    return pieces -- invalid arg: return empty array
  end

  local done = false
  local piece_start = 1
  repeat
    local sep_pos = string.find( subject, sep, piece_start )
    local found = sep_pos ~= nil
    if not found then
      piece_stop = subject_len
    else
      piece_stop = sep_pos - 1
    end

    local piece = string.sub( subject, piece_start , piece_stop )
    table.insert( pieces, piece)
    piece_start = sep_pos + sep_len
    local subject_end_reached = piece_start > subject_len
    local limit_reached = (lim > 0) and (#pieces == lim)
    done = limit_reached or subject_end_reached
  until done
  return pieces
end


function lued.implode(pieces, sep, trailing_sep, first, last)
  sep = sep or "\n"
  trailing_sep = trailing_sep or sep
  return table.concat(pieces,sep,first,last) .. trailing_sep
end

-- @description replace plain text string. Similar to string.gsub, except with
-- plain text.
-- @param subject is the string to modify
-- @param from is the plain text string to find
-- @param to is the plain text replacement string
-- @param index is the starting offset. default to 1
-- @param lim is the max number of substitutions. nil is no limit.
-- @return result count start stop
-- @return result is modified string
-- @return count is the number of replacements performed
-- @return start is the first offset modied
-- @return stop is the last offset modified in the new string
function lued.psub(subject, from, to, index, lim)
  lim = lim or 0
  index = index or 1
  if not subject or not from or from=="" or not to or to=="" then
    return subject
  end
  subject_len = string.len(subject)
  from_len = string.len(from)
  local to_len = string.len(to)
--   if true then return subject  end
  local plain = true
  local count = 0
  local start
  local stop
  local offset = 1
  local result = subject
  local lim_reached = false
  repeat
    local pos = string.find( result, from, offset, plain)
    if not pos then break end
    offset = pos + to_len
    local front_exists = pos>1
    local front = front_exists and string.sub(result, 1, pos-1) or ''
    local back_start = pos+from_len
    local back_exists = back_start <= string.len(result)
    local back = back_exists and string.sub(result , back_start) or ''
    result = front .. to .. back
    count = count + 1
    start = start or pos
    stop = pos + to_len - 1
  until count==lim
  return result, count, start, stop
end


function lued.style_page(lines, first_line_of_page, row_offset)

  -- ensure all styles are define
  styles.enable = styles.enable or false
  styles.normal = styles.normal or ""
  styles.cursor_line = styles.cursor_line or ""
  styles.line_number = styles.line_number or ""
  styles.cursor_line_number = styles.cursor_line_number or ""
  styles.cursor = styles.cursor or ""


  -- do nothing if not showing lnum and no style
  if not g_show_abs_line_numbers and not styles.enable then
    return lines
  end

  -- subtract one because for loop adds one
  first_line_of_page = first_line_of_page-1

  -- set the first and last lines to include all lines or just current line
  local update_only_cursor_line = not g_show_abs_line_numbers and styles.normal==""
  local start_line = update_only_cursor_line and row_offset or 1
  local stop_line = update_only_cursor_line and row_offset or #lines

  local comment_from = "(" .. styles.comment_regex .. ")";
  local comment_to = styles.comment .. "%1" .. styles.normal
  local string_from = "(" .. styles.string_regex .. ")"
  local string_to   = styles.comment .. "%1" .. styles.normal

  for ii=start_line,stop_line do
    local line_style = styles.enable and styles.normal or ""
    local lnum_style = styles.enable and styles.line_number or ""

    if ii==row_offset then
      local curs_style = styles.enable and styles.cursor or ""
      if curs_style~="" then
        lines[ii] = lued.psub(lines[ii], styles.inverse, curs_style, 1)
      end

      line_style = styles.enable and line_style .. styles.cursor_line or ""
      lnum_style = styles.enable and styles.cursor_line_number or ""
    else

      if styles.comment~="" then
        lines[ii] = string.gsub(lines[ii], comment_from, comment_to )
      end

      if styles.string~="" then
        lines[ii] = string.gsub(lines[ii], string_from, string_to )
      end
    end

    local t={}
    if line_style~="" then
     lines[ii] = line_style .. lued.psub(lines[ii], styles.reset, line_style) .. styles.normal
    end
    
    if g_show_abs_line_numbers or g_show_rel_line_numbers then
      local abs_ln = first_line_of_page+ii
      local rel_ln = math.abs(row_offset-ii) 
      local tmp = g_show_abs_line_numbers and abs_ln or rel_ln
      tmp = tmp==0 and abs_ln or tmp
      local linenum_str = string.format("  %4d  ", tmp)
      lines[ii] = lnum_style .. linenum_str .. styles.reset .. lines[ii]
    end
    
    if g_show_sb_files then
      local found, files = lued.select_tab_menu(nil,true) 
      local files_str = files[ii] or ""
      local sb_file_width = 20
      files_str = string.sub(files_str, 1, sb_file_width)
      files_str = files_str .. string.rep(" ",sb_file_width-#files_str) .. " | "
      lines[ii] = styles.sb_files .. files_str .. styles.reset .. lines[ii]
    end
    

    lines[ii] = styles.reset .. lines[ii]

  end -- for each line
  return lines
end


function lued.make_line_bold_orig(lnum1,lnum2)
  local esc_bold = ""
  if g_bold_current_line and lnum1==lnum2 then
    esc_bold = string.char(27) .. "[1m"
  end
  return esc_bold
end


function lued.insert_line_numbers_orig(text)
  linenum,col = get_cur_pos()

  -- replace every newline except for the last
  return  string.gsub (text, "\n.", function (str)
           g_lnum = g_lnum + 1
           local linenum = get_cur_pos()
           local esc_bold = ""
           if g_bold_current_line then
             esc_bold = lued.make_line_bold_orig(linenum,g_lnum)
           end
           local esc_normal = string.char(27).."[0m"
           if g_show_abs_line_numbers then
             return string.format(esc_normal .. str .. esc_bold .. "%4d: ", g_lnum)
           else
             return string.format(esc_normal .. str .. esc_bold)
           end
         end )
end


function lued.display_page_in_lua1(lua_mode, highlight_trailing_spaces)
  lued.display_status_in_lua(lua_mode)
  local prow,pcol = get_page_pos() -- FIXME -1 to adjust from c to lua
  local crow,ccol = get_cur_pos()
  local row_offset = crow - prow + 1
  local text = get_page(prow-1,highlight_trailing_spaces)
  local lines = lued.style_page( explode(text) , prow, row_offset)
  text = lued.implode(lines)

  -- text = lued.insert_line_numbers_orig(text)
  -- text = string.char(27) .. "[1m" .. text;

  io.write (text)
end

function lued.display_page_in_lua(lua_mode, highlight_trailing_spaces)
  lued.display_status_in_lua(lua_mode)
  local prow,pcol = get_page_pos() -- FIXME -1 to adjust from c to lua
  local crow,ccol = get_cur_pos()
  local row_offset = crow - prow + 1
  local text = get_lines(prow,1,prow+20,0)
  local lines = lued.style_page( explode(text) , prow, row_offset)
  text = lued.implode(lines)

  -- text = lued.insert_line_numbers_orig(text)
  -- text = string.char(27) .. "[1m" .. text;

  io.write (text)
end


function lued.disp(dd,center)
   dd = dd or g_dont_display
   center = center or false

   local dd2 = 1
   local r,c = get_cur_pos()
   local pr,pc = get_page_pos()

   if g_enable_file_changed then

     local id = get_fileid()
     local filename = get_filename(id)
     local file_has_changed = false
     local mtime, ts
     if lued.file_exists(filename) then
       file_has_changed,mtime,ts = is_file_modified(0)
     end

     if file_has_changed==1 then
       io.write("\n\n=======================================\n\n")
       local prompt = "File '" .. filename .. "' has changed. Do you want to reload <y/n>?"
       local reload = lued.get_yesno(prompt)=="Y"
       if reload then
         reopen()
       else
         g_enable_file_changed = false -- stop telling me the file has changed. I don't care
       end
     end
   end
   local tr,tc = get_termsize()
   local page_offset_changed = false
   local half = math.floor(tr / 2)

   -- if center then lued.dbg_prompt("CENTER") end

   if (r-pr) < g_min_lines_from_top then
     local new_offset = g_min_lines_from_top
     if center then
       new_offset = half
       lued.dbg_prompt("new_offset1="..new_offset)
     end
     lued.set_page_offset_percent(new_offset,dd2)
   end
   if (pr+tr-r < g_min_lines_from_bot) then
     local new_offset = -g_min_lines_from_bot
     if center then
       new_offset = half
     end
     if center then lued.dbg_prompt("new_offset2="..new_offset) end
     lued.set_page_offset_percent(new_offset,dd2)
   end

   if center then
     local new_offset = half
     lued.set_page_offset_percent(new_offset,dd2)
   end

   if dd == 0 then
     g_command_count = g_command_count or 0
     g_command_count = g_command_count + 1

     g_prev_pos = g_cur_pos or nil;
     g_cur_pos = get_cur_pos();

     if g_lua_mode == nil then return end
     local lua_mode = 0
     if g_lua_mode then
       lua_mode = 1
     end
     lued.display_page_in_lua1(lua_mode,g_show_trailing_spaces)
     -- display_status(lua_mode)
     -- display_text(lua_mode,g_show_trailing_spaces)
   end
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
      lued.move_down_n_lines(1,dd2)
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


function lued.halfsy_left(dd)
  local r,c = get_cur_pos()
  g_halfsy_right = c
  if g_command_count ~= g_halfsy_command_count or g_halfsy_left==nil then
    g_halfsy_left = 1
  end
  g_command_count = g_command_count or 1
  g_halfsy_command_count = g_command_count+1
  local next_c = c - math.ceil( (c-g_halfsy_left) / 2)
  set_cur_pos(r,next_c)
  g_halfsy_right = c
  lued.disp(dd)
end


function lued.halfsy_right(dd)
  local r,c = get_cur_pos()
  local len = get_line_len()
  g_halfsy_left = c
  if g_command_count ~= g_halfsy_command_count or g_halfsy_right==nil then
    g_halfsy_right = len+1
  end
  g_command_count = g_command_count or 1
  g_halfsy_command_count = g_command_count+1
  local next_c = c + math.ceil( (g_halfsy_right-c) / 2)
  set_cur_pos(r,next_c)
  lued.disp(dd)
end


function lued.move_left_n_words(n,dd)
  n = n or 1
  local dd2 = 1
  for i=1,n do
    if lued.is_sof() then break end
    if lued.is_sol() then
      lued.move_up_n_lines(1,dd2)
      lued.move_to_eol(dd2)
      break
    end
    local line = get_line()
    local r,c = get_cur_pos()
--    while lued.is_space(line,c-1) do c = c - 1 end -- back through spaces
    while not lued.is_word(line,c-1) do
      if c == 1 then break end
      c = c - 1
    end -- back through spaces
    while lued.is_word(line,c-1) do
      if c == 1 then break end
      c = c - 1
    end -- back through alphanums
    -- while not lued.is_space(line,c-1) do c = c - 1 end -- back through alphanums
    set_cur_pos(r,c)
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


function lued.set_pagesize(val,dd)
  val = val or 0 -- zero is a special case.
  g_page_size = val
  lued.disp(dd)
end


function lued.get_pagesize()
  rows, cols = get_termsize()
  if g_page_size==nil or g_page_size==0 then
    return rows
  elseif g_page_size < 1 then
    return math.floor(rows*g_page_size*100 + 0.5) / 100;
  else
    return g_page_size
  end
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
      lued.move_down_n_lines(1,dd2)
    end
    local r,c = get_cur_pos()
    local line_len = get_line_len()
    set_cur_pos(r,line_len+1)
  end
  lued.disp(dd)
end


function lued.session_sel(session_id,dd)
  if session_id then
    local fileid = get_fileid()
    if session_id ~= fileid then
      g_tab_prev = fileid
    end
    set_fileid(session_id)
  end
  lued.disp(dd)
end


function lued.tab_next(dd)
  local num_sessions = get_numsessions()
  local next_session = (get_fileid() % num_sessions)+1
  lued.session_sel(next_session, dd)
  return get_fileid()
end


function lued.tab_prev(dd)
  local num_sessions = get_numsessions()
  local next_session = get_fileid()-1
  if next_session<1 then
    next_session = num_sessions
  end
  lued.session_sel(next_session, dd)
  return get_fileid()
end


function lued.tab_toggle(dd)
  local num_sessions = get_numsessions()
  local this_session = get_fileid()
  if g_tab_prev == nil and get_numsessions() > 1 then
    if this_session < num_sessions then
      g_tab_prev = this_session + 1
    else
      g_tab_prev = this_session - 1
    end
  end
  lued.session_sel(g_tab_prev, dd)
end


function lued.move_to_line(n,dd)
  local r,c = get_cur_pos()
  if n == nil then
    move_to_line_hist_id = move_to_line_hist_id or lued.get_hist_id()
    local n_str = lued_prompt(move_to_line_hist_id,"Goto Linenumber: ")
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


function lued.get_sel_str()
  local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
  local sel_str = ""
  if sel_state~=0 then
    sel_str = get_str(sel_sr,sel_sc,sel_er,sel_ec)
  end
  return sel_str, sel_sr, sel_sc, sel_er, sel_ec
end


-- Not used anymore FIXME DELETE ME
-- function find(str,dd)
--   local dd2 = 1
--   local r,c = get_cur_pos()
--   local found,r2,c2 = find_str(str)
--   if found==0 then
--     lued.move_to_first_line(dd2)
--
--     found,r2,c2 = find_str(str)
--     set_cur_pos(r,c)
--   end
--   if found ~= 0 then
--     -- lued.remove_trailing_spaces(r2,c2,false,dd2)
--     local pr,pc = get_page_pos()
--     local tr,tc = get_termsize()
--     local lr = pr+tr
--     local page_change = r2 > lr-third or r2 < pr+third
--     if page_change==true then
--       lued.set_page_offset_percent(third,dd2)
--     end
--   end
--   lued.disp(dd)
-- end


function lued.find_prompt(test_str)
  test_str = test_str or ""
  local str = ""
  -- repeat
    local default_str = ""
    if g_find_str and g_find_str~="" then
      default_str = " (default='"..g_find_str.."')"
    end

    local prompt = "String to Find"..default_str..": "

    find_prompt_hist_id = find_prompt_hist_id or lued.get_hist_id()

    local hot=""
    str = lued_prompt(find_prompt_hist_id, prompt, hot, test_str)
--    str = find_read(0,prompt)
    if str==nil or str=="" and g_find_str and g_find_str~="" then
      str = g_find_str
    else
      lued.disp()
    end
  -- until str and str ~= ""
  if (str=="/*") then str = "/" .. "\\" .. "*" end
  return str
end


function lued.replace_prompt()
  local str = ""
  -- repeat
    local default_str = ""
    if g_replace_str and g_replace_str~="" then
      default_str = " (default='"..g_replace_str.."')"
    end

    local prompt = "String to Replace"..default_str..": "
    replace_prompt_hist_id = replace_prompt_hist_id or lued.get_hist_id()
    str = lued_prompt(replace_prompt_hist_id, prompt)
--    str = replace_read(prompt)
    if str==nil or str=="" and g_replace_str and g_replace_str~="" then
      str = g_replace_str
    else
      lued.disp()
    end
  -- until str and str ~= ""
  return str
end


g_find_jump_back_stack = {}
g_find_jump_forward_stack = {}
function lued.push_jump_stack(stack, fileid, row, col)
  local entry = {fileid, row, col}
  table.insert(stack, entry)
end


function lued.pop_jump_stack(stack)
  if #stack == 0 then
    return 0, 0, 0
  end
  local entry = stack[#stack] or {0,0,0}
  table.remove(stack)
  local fileid = entry[1] or 0
  local row = entry[2] or 0
  local col = entry[3] or 0
  return fileid, row, col
end


function lued.jump_back(jump_back_stack, jump_forward_stack, dd)
  local dd2 = 1

  local fileid = get_fileid()
  local r, c = get_cur_pos()
  lued.push_jump_stack(jump_forward_stack, fileid, r, c)


  local fileid, row, col = lued.pop_jump_stack(jump_back_stack)
  if fileid ~= get_fileid() then
    lued.session_sel(fileid, dd2)
  end
  if row ~= 0 then
    set_cur_pos(row, col)
  end
  lued.disp(dd)
end


function lued.jump_forward(jump_back_stack, jump_forward_stack, dd)
  local dd2 = 1

  local fileid = get_fileid()
  local r, c = get_cur_pos()
  lued.push_jump_stack(jump_back_stack, fileid, r, c)

  local fileid, row, col = lued.pop_jump_stack(jump_forward_stack)
  if fileid ~= get_fileid() then
    lued.session_sel(fileid, dd2)
  end
  if row ~= 0 then
    set_cur_pos(row, col)
  end
  lued.disp(dd)
end


function lued.find_jump_back(dd)
  lued.jump_back(g_find_jump_back_stack, g_find_jump_forward_stack, dd)
end


function lued.find_jump_forward(dd)
  lued.jump_back(g_find_jump_back_stack, g_find_jump_forward_stack, dd)
end


function lued.find_all_on_line(line,str)
  local matchi = {}
  local s,e = 1,1
  local match_count = 0
  g_find_plaintext = g_find_plaintext or false

  find_plaintext = g_find_plaintext and not g_find_whole_word


  if g_find_whole_word then
    str2 = "%f[%w_]" .. str .. "%f[^%w_]"
  else
    str2 = str
  end

  repeat
    s,e = string.find(line,str2,e,find_plaintext)
    if s ~= nil then
     match_count = match_count + 1
     matchi[match_count] = s
      e = e + 1
    end
  until (s == nil)
  return matchi
end


function lued.get_last_match(matches, maxc)
  if matches==nil then return end
  local last_match
  for i=1,#matches do
    if matches[i] < maxc then
      last_match = matches[i]
    end
  end
  return last_match
end


function lued.find_reverse(str,dd)
  local dd2 = 1
  if (str==nil or str=="") then
    g_find_str = lued.find_prompt()
  else
    g_find_str = str
  end
  if g_find_str == "" then
    lued.disp(dd)
    return
  end

  local g_find_str2 = g_find_str
  if not g_find_case_sensitive then
    g_find_str2 = string.lower(g_find_str)
  end

  local r,c = get_cur_pos()
  local pr,pc = get_page_pos()
  c = c-1
  local numlines = get_numlines()
  local match_found = false
  for k=numlines,1,-1 do
    i = (r+k-numlines) % numlines
    local line = get_line()
    if not g_find_case_sensitive then
      line = string.lower(line)
    end
    local matches = lued.find_all_on_line(line,g_find_str2)
    local maxc = i==r and c or string.len(line)+1
    local match_c = lued.get_last_match(matches,maxc)
    for j=1,#matches do matches[j] = nil end
    match_found = (match_c ~= nil)
    if match_found then
      local cfileid = get_fileid()
      local cr, cc = get_cur_pos()
      if not dd then
        lued.push_jump_stack(g_find_jump_back_stack, cfileid, cr, cc)
      end

      local match_str = string.match(line,g_find_str2,match_c)
      local match_len = string.len(match_str)
      set_cur_pos(i,match_c)
      set_sel_start()
      set_cur_pos(i,match_c+match_len)
      set_sel_end()
      set_cur_pos(i,match_c)
      break
    else
      if k==1 then
        set_cur_pos(r,c+1)
        set_page_pos(pr,pc)
      else
        set_cur_pos(i-1,1)
      end
    end
  end
  lued.disp(dd)
  return match_found
end


function lued.find_reverse_again(dd)
  local dd2 = 1
  local skip = g_find_str==nil or g_find_str==""
  if not skip then
    lued.find_reverse(g_find_str,dd2)
  end
  lued.disp(dd)
end


function lued.find_reverse_selected(dd)
  local dd2 = 1
  local initial_r,initial_c = get_cur_pos()
  local pr,pc = get_page_pos()

  local sel_str, sel_sr, sel_sc = lued.get_sel_str()
  local found = false
  if sel_str~="" then
    g_find_str = sel_str
--  lued.dbg_prompt("DBG sel_sr="..sel_sr.." initial_r="..initial_r)
    set_cur_pos(sel_sr,sel_sc)
    found = lued.find_reverse(g_find_str,dd2)
    if found then
      local new_r,new_c = get_cur_pos()
      local delta_r = initial_r - new_r
    else
      set_cur_pos(initial_r,initial_c)
    end
  end
  local center = true
  lued.disp(dd, center)
  return found
end


function lued.get_first_match(matches, minc)
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

-- found = lued.find_forward(str,true,false,false,'',dd2)
function lued.find_forward(str,nowrap,search_all,replace,test_str,dd)
  test_str = test_str or ""
  local dd2 = 1

  local cfileid = get_fileid()
  local cr, cc = get_cur_pos()

  local found = false
  if test_str ~= "" then
    g_find_str = lued.find_prompt(test_str)
  elseif str==nil or str=="" then
    g_find_str = lued.find_prompt()
  else
    g_find_str = str
  end
  if g_find_str == "" then
    lued.disp(dd)
    return
  end

  local g_find_str2 = g_find_str
  if not g_find_case_sensitive then
    g_find_str2 = string.lower(g_find_str2)
  end

  if replace and (str==nil or str=="") then
    g_replace_str = lued.replace_prompt()
  end

  local r,c = get_cur_pos()
  local pr,pc = get_page_pos()
  local numlines = get_numlines()
  local i = 0
  for k=1,numlines,1 do
    local ibefore = i
    i = (((r+k-1)-1) % numlines)+1
    local wrap = i < ibefore
    if wrap==true and nowrap==true then break end
    set_cur_pos(i,1)
    local line = get_line()
    if not g_find_case_sensitive then
      line = string.lower(line)
    end
    local matches = lued.find_all_on_line(line,g_find_str2)
    local minc = 0
    if i==r and not search_all then
      minc = c
    end
    local match_c = lued.get_first_match(matches,minc)
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
      lued.push_jump_stack(g_find_jump_back_stack, cfileid, cr, cc)

      local match_str = string.match(line,g_find_str2,match_c) or ""
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
  lued.disp(dd)
  return found
end


function lued.find_and_replace(from,to,options,dd)
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
  local resp = "y"
  repeat

    local test_str = ""
    found = lued.find_forward(str,true,false,true,test_str,dd2)
    str = str or g_find_str
    g_find_str = str
    if found then
      resp = "y"
      if not replace_all then
        lued.disp(0)
        r,c = get_cur_pos()
        find_and_replace_hist_id = find_and_replace_hist_id or lued.get_hist_id()
        resp = lued_prompt(find_and_replace_hist_id,"Replace <y/n/j/a/q/s>?", ",y,n,j,a,q,s,")
        -- Y = yes and goto next
        -- N = no and goto next
        -- J = Jagged. Yes + Fix jagged alignment after replace
        -- A = replace All
        -- Q = quit and return cursor to beginning
        -- S = Stop (Yes, quit and Stop at current position)
        resp = string.lower( string.sub(resp,1,1) )
        resp = string.match(resp,"[ynjaqs]") or "q"
        replace_all = resp=="a"
      end

      if resp=="y" or resp=="j" or resp=="a" or resp=="s" then
        g_replace_str = g_replace_str or ""
        local to = g_replace_str
        local to_is_lower = to == to:lower()
        local to_is_upper = to == to:upper()
        if not to_is_lower and not to_is_upper then
          local sel_str, sel_sr, sel_sc = lued.get_sel_str()
          local from_is_lower = sel_str == sel_str:lower()
          local from_is_upper = sel_str == sel_str:upper()
          if from_is_lower then
            to = to:lower()
          elseif from_is_upper then
            to = to:upper()
          end
        end
        lued.ins_string(to, dd2)
        if resp=="j" then
          lued.insert_tab(dd2)
        end
        if resp=="s" then break end
      elseif resp=="n" then
        lued.move_right_n_char(1,dd2)
      else -- q or invalid response
        break
      end

    end
  until not found
  if resp~="s" then
    set_cur_pos(initial_r,initial_c)
    lued.recenter(dd2)
  end
  lued.disp(dd)
end


function lued.replace_again(dd)
  local dd2 = 1
  lued.find_and_replace(g_find_str,g_replace_str,"",dd)
end


function lued.paste_and_find_forward(dd)
  local dd2 = 1
  lued.global_paste(dd2)
  lued.find_forward_again(dd)
end


function lued.paste_and_find_reverse(dd)
  local dd2 = 1
  lued.global_paste(dd2)
  lued.find_reverse_again(dd)
end


function lued.search_all_files(str,dd)
  local dd2 = 1
  str = str or ""

  local sel_str, sel_sr, sel_sc = lued.get_sel_str()
  if sel_str ~= "" then
    g_find_str = sel_str
    set_sel_off()
  end

  local save_g_tab_prev = g_tab_prev;
  local test_str = ""
  local match = lued.find_forward(str,true,false,false,sel_str,dd2)
  local start_session = get_fileid()
  if not match then
    save_g_tab_prev = start_session
  end
  while not match do
    local session_id = lued.tab_next(dd2)
    if session_id == start_session then break end
    local r,c = get_cur_pos()
    lued.move_to_first_line(dd2)
    lued.move_to_sol_classic(dd2)
    match = lued.find_forward(g_find_str,true,true,false,test_str,dd2)
    if not match then -- restore cur_pos
      set_cur_pos(r,c)
    end
  end
  g_tab_prev = save_g_tab_prev
  g_search_all_files = true
  lued.disp(dd)
  return match
end


function lued.find_forward_again(dd)
  local dd2 = 1
  local initial_r,initial_c = get_cur_pos()
  if g_search_all_files then
    return lued.search_all_files(str,dd)
  end
  local test_str = ""
  local found = lued.find_forward(g_find_str,false,false,false,test_str,dd2)
  if not found then
    set_cur_pos(initial_r,initial_c)
  end
  lued.disp(dd)
  return found
end


function lued.find_word(dd)
  local dd2 = 1
  set_sel_off()
  lued.sel_word(dd2)
  set_sel_end()
  local sel_str = lued.get_sel_str()
  lued.find_forward_selected(dd)
end


function lued.find_reverse_word(dd)
  local dd2 = 1
  set_sel_off()
  lued.sel_word(dd2)
  set_sel_end()
  lued.find_reverse_selected(dd)
end


function lued.find_forward_selected(dd)
  local dd2 = 1
  g_search_all_files = false
  local initial_r,initial_c = get_cur_pos()
  local sel_str, sel_sr, sel_sc = lued.get_sel_str()
  if sel_str~="" then
    lued.move_right_n_char(1,dd2)
    g_find_str = sel_str
    set_sel_off()
  else
    g_find_str = sel_str
  end
  local found = lued.find_forward(g_find_str,false,false,false,sel_str,dd2)
  if not found then
    set_cur_pos(initial_r,initial_c)
  end
  lued.disp(dd)
  return found
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


function lued.sel_n_char(n,dd)
  n = n or 1
  set_sel_start()
  lued.move_right_n_char(n, dd)
end


function lued.sel_word(dd)
  local dd2 = 1
  if is_sel_off()==1 then
    lued.word_start(dd2)
    lued.var_start(dd2)
    set_sel_start()
  else
    if lued.is_blankline() then
      lued.move_down_n_lines(1,dd2)
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
  local rlast = r + n - 1
  if is_sel_off()==1 then
    set_cur_pos(r,1)
    set_sel_start()
  end
  set_cur_pos(rlast+1,1)
  set_cur_pos(rlast+1,1)
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


function lued.del_sof(dd)
  local dd2 = 1
  lued.sel_sof(dd2)
  set_sel_end()
  lued.cut(dd)
end


function lued.del_eof(dd)
  local dd2 = 1
  lued.sel_eof(dd2)
  set_sel_end()
  lued.cut(dd)
end


function lued.del_all(dd)
  local dd2 = 1
  lued.sel_all(dd2)
  lued.cut(dd)
end


function lued.sel_toggle(dd)
  if is_sel_off()==1 then
    set_sel_start()
  else
    set_sel_off()
  end
  lued.disp(dd)
end


function lued.del_sel(dd)
  delete_selected()
  lued.disp(dd)
end


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
    lued.cut(dd)
  end
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


function lued.del_sow(dd)
  local dd2 = 1
  lued.sel_sow(dd2)
  lued.del_sel(dd)
end


function lued.sel_eow(dd)
  local dd2 = 1
  set_sel_start()
  if lued.is_space() then
    while lued.is_space() and not lued.is_eol()  do
      lued.move_right_n_char(1,dd2)
    end
  elseif lued.is_punct() then
    while lued.is_punct() and not lued.is_eol() do
      lued.move_right_n_char(1,dd2)
    end
  elseif lued.is_word() then
    while lued.is_word() and not lued.is_eol() do
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


function lued.del_eow(dd)
  local dd2 = 1
  lued.sel_eow(dd2)
  lued.del_sel(dd)
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
  lued.cut(dd)
end


-- Remove spaces from cursor to start of next word.  If cursor is not over a
-- space then go to next line and then delete the spaces.
function lued.del_spaces_next_line(dd)
  local dd2 = 1
  if not lued.is_space() then
    lued.move_down_n_lines(1,dd2)
  end
  local r,c = get_cur_pos()
  set_sel_start()
  lued.skip_spaces(dd2)
  set_sel_end()
--  set_cur_pos(r,c)
  lued.cut(dd)
end


function lued.del_spaces_selected(dd)
  lued.foreach_selected(lued.del_spaces_next_line, dd)
end


function lued.del_word(n,dd)
  local dd2 = 1
  if lued.is_word() then
    lued.sel_word(dd2)
    set_sel_end()
    lued.cut(dd)
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
    lued.move_down_n_lines(1,dd2)
  end
  if not lued.is_eol() then
    lued.sel_eol(dd2)
    set_sel_end()
    lued.cut(dd2)
  end
  lued.disp(dd)
end


function lued.del_eol_selected(dd)
  lued.foreach_selected(lued.del_eol, dd)
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
    lued.cut(dd)
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
  if (g_command_count == g_cut_line_command_count) then
    lued.global_cut_append(dd2)
  else
    lued.global_cut(dd2)
  end
  g_cut_line_command_count = g_command_count
  lued.disp(dd)
end

function lued.cut_line(n,dd)
  n = n or 1
  local dd2 = 1
  if is_sel_off()==1 then
    lued.del_line(n,dd)
  else
    lued.global_cut(dd)
  end
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


function lued.indent1(n, ch, goto_next, dd)
  local dd2 = 1

  local spaces = string.rep(ch,n)
  local r,c = get_cur_pos()
  set_cur_pos(r,1)
  ins_str(spaces,dd2)
  if goto_next then
    lued.move_down_n_lines(1,dd2)
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
    lued.move_down_n_lines(1,dd2)
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
      lued.move_down_n_lines(1,dd2)
    else
      lued.unindent1(g_indent_size, g_indent_char, goto_next_line, dd2)
    end
  end
  lued.disp(dd)
end


function lued.line_contains(needles, line)
  local line = line or get_line()
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


function lued.ins_string(str, dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
  local first_line = sel_sr<=1
  local inhibit_cr = sel_state~=0 and not first_line
  lued.del_sel(dd2)

  is_start_of_block = lued.line_contains(g_block_start)
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

    if is_inside_braces then
      insert_str(str)
      lued.move_up_n_lines(1,dd2)
      lued.indent1(g_indent_size, g_indent_char, false, dd2)
    elseif is_start_of_block then
      lued.indent1(g_indent_size, g_indent_char, false, dd2)
    end

    local r2,c2 = get_cur_pos()
    set_cur_pos(r,c)
    lued.remove_trailing_spaces(r2,c2,false,dd2)
  else
    local brace_closed = false
    if g_self_closing_braces then
      if str=='{' then str= '{}'; brace_closed = true; end
      if str=='(' then str= '()'; brace_closed = true; end
      if str=='[' then str= '[]'; brace_closed = true; end
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


function lued.insert_tab_classic(dd)
  local t = (g_tab_size > 0) and string.rep(' ',g_tab_size) or "\t"
  ins_str(t,dd)
end


function lued.get_token(str,ii)
  ii = ii or 1
  local str = str or ""
  local len = str:len()
  local token = ''
  while ii <= len and lued.is_space(str,ii) do
    ii = ii + 1
  end
  if ii <= len and lued.is_word(str,ii) then
    while ii <= len and lued.is_word(str,ii) do
      token = token .. str:sub(ii,ii)
      ii = ii + 1
    end
  elseif lued.is_punct then
    token = str:sub(ii,ii)
    ii = ii + 1
  end
  return token, ii    
end
  

function lued.handle_snippets(dd)
  local dd2 = false
  local r,c=get_cur_pos()
  lued.sel_left_pattern( "[%w.#*()^>+*:]"  , dd2)
--   lued.sel_sow(dd2)
  local sel_str, sel_sr, sel_sc = lued.get_sel_str()
  if sel_str==nil or sel_str=='' then
    return false
  end
  
  local filetype = 'html'
  
  s1 = snips and "snips exists," or "snips NOT"
  s2 = snips[filetype] and "html exists" or "html NOT"
  --s3 = snips[filetype]['exec']  and "exec exists" or "exec NOT"
  
  local snip_routine = snips[filetype].main
  if snip_routine == nil then
    set_sel_off()
    set_cur_pos(r,c)
    return false
  end
  lued.del_sel(dd2)
  set_cur_pos(sel_sr,sel_sc)
  g_dont_display = 1
  
  local tok = ""
  local ii = 1
  local cnt = 1
  repeat
    tok, ii = lued.get_token(sel_str,ii)
    snip_routine(tok)
    tok, ii = lued.get_token(sel_str,ii)
    cnt = cnt + 1
  until tok == "" or cnt == 5
  
  g_dont_display = 0
  
  lued.disp(dd)
  return true
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


function lued.swap_line_with_prev(dd)
  local dd2 = 1
  lued.cut_line(1,dd2)
  lued.move_up_n_lines(1,dd2)
  lued.paste_line_before(dd)
end


function lued.swap_line_with_next(dd)
  local dd2 = 1
  lued.cut_line(1,dd2)
  lued.move_down_n_lines(1,dd2)
  lued.paste_line_before(dd2)
  lued.move_up_n_lines(2,dd)
end


function lued.bubble_line_up(dd)
  local dd2 = 1
  lued.swap_line_with_prev(dd2)
  lued.move_up_n_lines(1,dd)
end


function lued.set_sel_from_to(sel_sr,sel_sc,sel_er,sel_ec,dd)
  local dd2 = 1
  set_cur_pos(sel_sr,sel_sc)
  set_sel_start()
  set_cur_pos(sel_er,sel_ec)
  set_sel_end()
  lued.disp(dd)
end


function lued.bubble_selected_lines_up(dd)
  local dd2 = 1
  if lued.is_sel_on() then
    local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
    if sel_sr > 1 then
      lued.global_cut(dd2)
      lued.move_up_n_lines(1,dd2)
      lued.paste_line_before(dd)
      lued.set_sel_from_to(sel_sr-1, 1, sel_er-1, 1, dd)
    end
    lued.disp(dd)
  else
    lued.bubble_line_up(dd)
  end
end


function lued.bubble_line_down(dd)
  local dd2 = 1
  lued.swap_line_with_next(dd2)
  lued.move_down_n_lines(1,dd)
end


function lued.bubble_selected_lines_down(dd)
  local dd2 = 1
  if lued.is_sel_on() then
    local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
    lued.global_cut(dd2)
    lued.move_down_n_lines(1,dd2)
    lued.paste_line_before(dd)
    lued.set_sel_from_to(sel_sr+1, 1, sel_er+1, 1, dd)
    lued.disp(dd)
  else
    lued.bubble_line_down(dd)
  end
end


function lued.bubble_word_right(dd)
  local dd2 = 1
  lued.sel_word(dd2)
  lued.skip_spaces(dd2)
  set_sel_end()
  lued.del_word(1,dd2)
  lued.move_right_n_words(1,dd2)
  lued.paste(dd2)
  lued.move_left_n_words(1,dd2)
  lued.disp(dd)
end


function lued.bubble_word_left(dd)
  local dd2 = 1
  lued.sel_word(dd2)
  lued.skip_spaces(dd2)
  set_sel_end()
  lued.del_word(1,dd2)
  lued.move_left_n_words(1,dd2)
  lued.paste(dd2)
  lued.move_left_n_words(1,dd2)
  lued.disp(dd)
end


function lued.hot(key, dd)
  if key == nil then return end
  key = "," .. key .. ","
  local keys = get_hotkeys()
  if not string.find(keys, key, 1, true) then
    set_hotkeys(keys .. key)
  end
  lued.disp(dd)
end


function lued.nohot(key, dd)
  if not key then return end
  key = key .. ","
  local keys = get_hotkeys()
  keys:gsub(key,"")
  set_hotkeys(keys)
  lued.disp(dd)
end


function lued.save_file(dd)
  if g_review_mode then
    lued.save_as(nil, dd)
  end

  local r,c = get_cur_pos()
  local id = get_fileid()
  local filename = get_filename(id)
  local file_has_changed = false
  local mtime, ts
  if lued.file_exists(filename) then
    file_has_changed,mtime,ts = is_file_modified(1)
   end

  if file_has_changed==1 then
    local id = get_fileid()
    local filename = get_filename(id)
    io.write("\n\n=======================================\n\n")
    local overwrite = lued.get_yesno("File '" .. filename .. "' has changed. Do you want to overwrite <y/n>?")=="Y"
    if overwrite then
      save_session()
    end
  else
    save_session()
  end
  set_cur_pos(r,c)
  lued.disp(dd)
end


function lued.save_as(filename, dd)
  if filename == nil then
    save_as_hist_id = save_as_hist_id or lued.get_hist_id()
    local done = false
    repeat
      filename = lued_prompt(save_as_hist_id,"Save As Filename: ")
      if lued.file_exists(filename) then
        local response = lued.get_yesno
        local prompt = "File '" .. filename .. "' exists. Overwrite <y/n/a for abort (don't save)>?";
        local what_should_i_do = lued.get_yesno(prompt, "N")
        if what_should_i_do == "N" then
          lued.disp(dd)
          done = false
        elseif what_should_i_do == "Y" then
          done = true
        else -- abort
          lued.disp(dd)
          return
        end
      else
        done = true
      end
    until done
  end

  set_filename(filename)
  save_session()
  lued.disp(dd)
end


function lued.save_all(dd)
  local dd2 = 1
  local fileid = get_fileid()
  local numsessions = get_numsessions()
  for i=1,numsessions do
    lued.session_sel(i)
    if is_modified()==1 then
      save_session(dd2)
    end
  end
  lued.session_sel(fileid,dd)
end


function lued.exit_session(dd)
  save_session()
  close_session()
  lued.disp(dd)
end


function lued.exit_all(dd)
  local dd2 = 1
  while (true) do
     lued.exit_session(dd2)
  end
end


function lued.quit_session(force,dd)
  force = force or false
  local not_saved_yet = is_modified()
  local numsessions = get_numsessions()
  local what_should_i_do = "Y"
  if not force and not_saved_yet==1 and numsessions>0 then
    local id = get_fileid()
    local prompt = "Save '" .. get_filename(id) .. "' <y/n/a for abort (don't quit)>?";
    what_should_i_do = lued.get_yesno(prompt, "A")
    if what_should_i_do=="Y" then
      save_session()
    end
  end
  local abort = what_should_i_do=="A"
  if not abort then
    close_session()
    if (numsessions==1) then
      close_session()
    end
  end
  lued.disp(dd)
  return abort
end


function lued.quit_all(force, dd)
  local dd2 = 1
  force = force or false
  local abort = false
  while (not abort) do
     abort = lued.quit_session(force, dd2)
  end
  if abort then
    lued.disp(dd)
  end
end


function lued.pathifier(filename)
    filename = string.gsub(filename, "^~", os.getenv("HOME") )
    local env_name = string.match(filename,"%${?([%w_]+)}?")
    while env_name ~= nil do
      local env_value = os.getenv(env_name)
      filename = string.gsub(filename, "%${?" .. env_name .. "}?", env_value)
      env_name = string.match(filename,"%${?([%w_]+)}?")
    end
    return filename
end


function lued.os_cmd(cmd)
  local stream  = assert(io.popen(cmd, "r"))
  local output_string  = assert(stream:read("*all"))
  stream:close()
  return output_string
end


function lued.read_dir(glob)
  glob = glob or "*"
  local files = lued.os_cmd("ls " .. glob)
  return files
end


function lued.get_longest_word(words)
  local longest_word = "";
  for word in words:gmatch("(%S+)") do
    local len = word:len()
    if (len > longest_word:len()) then
      longest_word = word
    end
  end
  return longest_word
end


function lued.basename(full_path)
  full_path = full_path or ""
  local basename_str = full_path:match("[^/]+$") or ""
  return basename_str
end


function lued.dirname(full_path)
  full_path = full_path or ""
  local dirname_str  = full_path:match("^.*[/]") or ""
--  if dirname_str:len() > 1 then
--    dirname_str  = dirname_str:sub(1,-2) -- remove trailing backslash
--  end
  return dirname_str
end


function lued.is_glob(filename)
  filename = filename or     ""
  local contains_wildcard = filename:match("[*]")
  if filename:match("[*]") then
    return true
  end
  return false
end


function lued.is_dir(filename)
  filename = filename or ""
  if filename == "" then
    return false
  end
  if lued.is_glob(filename) then
    return false
  end
  local file_type = lued.os_cmd("stat -c%F " .. filename) or ""
  if file_type:match("directory") then
    return true
  end
  return false
end


function lued.file_exists(filename)
   local handle=io.open(filename,"r")
   local exists = handle~=nil
   if exists then
     io.close(handle)
   end
   return exists
end


function lued.ls_dir(glob)
  ls_dir_hist_id = ls_dir_hist_id or lued.get_hist_id()
  glob = glob or lued_prompt(ls_dir_hist_id, "Enter path, glob or filename. ctrl-A selects All: ")
  glob = glob or ""

  if glob == "ctrl_A" then
    return glob
  end

  local path  = lued.dirname(glob)
  local globname = lued.basename(glob)
  if lued.is_dir(glob) then
    path = glob
    if path:match("[/]$")==nil then
      path = path .. "/"
    end
    globname = ""
  end

  local file_count = 0
  local return_filename = ""
  local filenames = lued.read_dir(glob)
  if filenames ~= "" then
    print ("")
    local str = "path: " .. path
    if globname and globname~="" then
      str = str .. " glob: " .. globname
    end
    print (str)

    local longest_filename = lued.get_longest_word(filenames);
    local col_width = longest_filename:len() + 2
    local prepend_path = path ~= nil and longest_filename:match("[/]")==nil
    if (prepend_path) then
      col_width = col_width + path:len()
    end
    local tr,tc = get_termsize()
    local num_col_per_line = math.floor(tc / col_width)
    local col_cnt = 0
    local line = ""
    for filename in filenames:gmatch("(%S+)") do
      file_count = file_count + 1
      if prepend_path then
        filename = path .. filename
      end
      local filename_len = filename:len()
      local pad_len = col_width - filename_len
      local spaces = string.rep(' ', pad_len);
      line = line .. filename .. spaces
      col_cnt = col_cnt + 1
      if col_cnt == num_col_per_line then
        print(line)
        col_cnt = 0
        line = ""
      end
    end
    if line ~= "" then
      print(line)
    end
  end
  return glob
end


function lued.chomp(str)
  str = str or ""
  return str:gsub("\n$","")
end


function lued.exactly_one_file_matches(glob)
  local filenames = lued.read_dir(glob)
  local _,count = filenames:gsub("%S+","")
  if count==1 then
    return lued.chomp(filenames)
  end
  return nil
end


function lued.is_empty(str)
  return str==nil or str==""
end


function lued.cd_change_dir(dd)
  local tmp_path = ""
  tmp_path = lued.ls_dir("")
  local previous = tmp_path
  local filename = ""
  repeat
    if tmp_path == "ctrl_A" then -- select all
      if lued.is_dir(previous) then
        previous = previous .. "/*"
      end
      local filenames = lued.read_dir(previous)

      return filenames
    end

    filename = lued.exactly_one_file_matches(tmp_path)
    if not lued.is_empty(filename) then
      return filename
    end
    previous = tmp_path
    tmp_path = lued.ls_dir()
  until tmp_path==""
  lued.disp(dd)
  return nil
end


function lued.is_open(filename)
  local dd2 = 1
  filename = filename or ""
  if lued.is_empty(filename) then
    return nil
  end
  local id = get_fileid()
  local found = false
  for i=1,get_numsessions() do
    set_fileid(i)
    found = filename == get_filename(i)
    if found then
      set_fileid(id,dd2)
      return i
    end
  end
  set_fileid(id,dd2)
  return nil
end


function lued.open_file(filenames,dd)
  local dd2 = 1
  if filenames==nil then
    filenames = lued.cd_change_dir(dd2)
  end
  if filenames==nil then
    open_file_hist_id = open_file_hist_id or lued.get_hist_id()
    filenames = lued_prompt(open_file_hist_id, "Enter Filename: ")
    local home = os.getenv("HOME")
    filenames = string.gsub(filenames,"^~",home)
    local env_name = string.match(filenames,"%${?([%w_]+)}?")
    while env_name ~= nil do
      local env_value = os.getenv(env_name)
      filenames = string.gsub(filenames, "%${?" .. env_name .. "}?", env_value)
      env_name = string.match(filenames,"%${?([%w_]+)}?")
    end
  end

  local filename_list,count = filenames:gmatch("(%S+)")

  for filename1 in filename_list do
    local existing_fileid = lued.is_open(filename1)
    if existing_fileid then
       g_tab_prev = get_fileid()
      set_fileid(existing_fileid,dd2)
    elseif filename1~=nil and filename1~="" and lued.file_exists(filename1) and not lued.is_dir(filename1) and not lued.is_open(filename1) then
      local prev = get_fileid()
      local fileid = lued_open(filename1)
      if fileid~=nil and fileid~=0 then
        g_tab_prev = prev
        set_fileid(fileid)
        lued.move_to_first_line(dd2)
      end
    end
  end
  lued.disp(dd)
end


function lued.ls_recursive(path,filter)
  path = path or "."
  filter = filter or ""
  local filenames_str = lued.os_cmd("find "..path.." -type f -iname '*"..filter.."*'")
  local filenames_table = {}
  for filename in filenames_str:gmatch('[^\n]+') do
    table.insert(filenames_table, filename)
  end
  return filenames_table
end


function lued.open_partial_filename(dd)
  local dd2 = 1
  local file_filter = ""
  open_partial_filename_hist_id = open_partial_filename_hist_id or lued.get_hist_id()
  file_filter = lued_prompt(open_partial_filename_hist_id, "Enter Partial Filename: ")
  print("\n")
  local filenames_table = lued.ls_recursive(".", file_filter)
  for i, f in pairs(filenames_table) do
    print(i..": "..f)
  end
  local filename = nil
  if #filenames_table == 1 then
    filename = filenames_table[1]
  end
  lued.open_file(filename,dd)
end


function lued.open_file_bindings(dd)
  lued.open_file(g_bindings_file,dd)
end


function lued.reload_file(dd)
  reopen()
  g_enable_file_changed = true -- tell me when the file has changed.
  lued.disp(dd)
end


function lued.open_filelist(filelist,dd)
  local dd2 = 1
  if filelist==nil then
    open_filelist_hist_id = open_filelist_hist_id or lued.get_hist_id()
    filelist = lued_prompt(open_filelist_hist_id, "Enter Filelist: ")
  end
  if (filelist~=nil and filelist~="") then
    local file = io.open(filelist, "r");
    if file~=nil then
      for filename in file:lines() do
        lued.open_file(filename)
      end
    end
  end
  lued.disp(dd)
end


function lued.new_file(filename, dd)
  local dd2 = 1
  local fileid = lued_open("")
  if filename == nil then
    local default_filename = "lued_untitled_"..fileid..".txt"
    new_file_hist_id = new_file_hist_id or lued.get_hist_id()
    filename = lued_prompt(new_file_hist_id,  "Enter Filename (default: '"..default_filename.."'): ")
    if filename == nil or filename=="" then
      filename = default_filename
    end
  end
  set_fileid(fileid)
  lued.save_as(filename,dd)
end


function lued.set_page_offset_percent(offset,dd)
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
  offset = math.ceil(offset)
  set_page_offset(offset,0)
  g_page_offset = offset
  if (dd==0) then lued.disp(dd) end
end


function lued.recenter(dd)
  local dd2 = 1
  lued.set_page_offset_percent(0.50,dd)
  lued.disp(dd)
end


function lued.recenter_top(dd)
  local dd2 = 1
  lued.set_page_offset_percent(0.10,dd2)
  lued.disp(dd)
end


function lued.move_down_and_repeat(dd)
  local dd2 = 1
  if g_prev_pos ~= nil then
    local prev_r, prev_c = g_prev_pos;
    local prev_cmd = get_last_cmd() or ""
    set_cur_pos(prev_r, prev_c);
    lued.move_down_n_lines(1,dd2)


  end
  lued.disp(dd)
end


function lued.undo_cmd(dd)
  local last_cmd = get_last_cmd()
--  lued.dbg_prompt("last_cmd="..last_cmd.."xxx")
  -- set_ctrl_z_suspend(true);
  undo()
  lued.disp(dd)
end

function lued.redo_cmd(dd)
  redo()
  lued.disp(dd)
end


function lued.alt_z_wrapper(dd)
  local dd2 = 1;
  if g_ctrl_z_suspend then
    lued.undo_cmd(dd2)
  else
    lued.set_ctrl_z_suspend(true)
  end
  lued.disp(dd)
end


function lued.set_named_mark(dd)
  named_mark_hist_id = named_mark_hist_id or lued.get_hist_id()
  local hot = nil
  mark_name = lued_prompt(select_tab_hist_id, "Set Mark - Enter Name: ",hot)
  set_mark(mark_name);
  lued.disp(dd)
end


function lued.goto_named_mark(dd)
  named_mark_hist_id = named_mark_hist_id or lued.get_hist_id()
  local hot = nil
  mark_name = lued_prompt(select_tab_hist_id, "Goto Mark - Enter Name: ",hot)
  goto_mark(mark_name);
  lued.disp(dd)
end


function lued.set_nameless_mark(dd)
  local dd2 = 1
  g_nameless_stack = g_nameless_stack or 0
  set_mark("nameless_" .. g_nameless_stack)
  g_nameless_stack = g_nameless_stack + 1
  lued.disp(dd)
end


function lued.goto_nameless_mark_prev(dd)
  g_nameless_stack = g_nameless_stack or 1
  if g_nameless_stack==0 then g_nameless_stack = 1 end
  g_nameless_stack = g_nameless_stack - 1
  goto_mark("nameless_" .. g_nameless_stack)
  lued.disp(dd)
end

function lued.sel_mark_to_cursor(dd)
  local dd2 = 1
  local r1,c1 = get_cur_pos()
  lued.goto_nameless_mark_prev(dd2)
  local r2,c2 = get_cur_pos()

  if (r1 < r2) then
    -- do nothing
  elseif (r1 > r2) then
  elseif (c1 < c2) then
    -- do nothing
  elseif (c1 > c2) then
    r1,r2 = r2,r1
    c1,c2 = c2,c1
  else
    lued.disp(dd)
    return
  end

  set_cur_pos(r1,c1)
  set_sel_start()
  set_cur_pos(r2,c2)
  set_sel_end()
  lued.disp(dd)
end


function lued.del_mark_to_cursor(dd)
  local dd2 = 1
  lued.sel_mark_to_cursor(dd2)
  lued.del_sel(dd)
end


function lued.goto_nameless_mark_next(dd)
  g_nameless_stack = g_nameless_stack or 0
  g_nameless_stack = g_nameless_stack + 1
  local found = goto_mark("nameless_" .. g_nameless_stack)
  if not found then g_nameless_stack = g_nameless_stack - 1 end
  lued.disp(dd)
end

function lued.decset(val)
  val = val or 1000
  lued.set_min_lines_from_top(0)
  lued.set_min_lines_from_bot(0)
  local esc = string.char(27)
  local csi = esc .. "["
  io.write( csi .. "?" .. val .. "h" )
end

function lued.decrst(val)
  val = val or 1000
  lued.set_min_lines_from_top()
  lued.set_min_lines_from_bot()
  local esc = string.char(27)
  local csi = esc .. "["
  io.write( csi .. "?" .. val .. "l" )
end

function lued.mouse_config(val)
  if val==nil then
    if g_decset==nil or g_decset==0 then
      val = 1000
    else
      val = 0
    end
  end

  if g_decset and g_decset~=0 and val~=g_decset then
    lued.decrst(g_decset)
  end
  if (val~=0) then -- 9 = x10 1000 = normal
    lued.decset(val)
  else
    lued.decrst(g_decset)
  end
  g_decset = val;
end


function lued.mouse_event(str)
  str = str or ""
  if g_mouse_remove_trailing_comma then
    local last_pos = #str-1
    local last_char = string.sub(str, last_pos, last_pos)
    if last_char == "," then
      str = string.sub(str, 1, last_pos)
    end
  end
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
  elseif Cb==64 then  -- scroll wheel forward
    lued.move_up_n_lines(2,dd2)
  elseif Cb==65 then  -- scroll wheel backward
    lued.move_down_n_lines(2,dd2)
  else
    dd2 = 1
  end
  lued.disp(dd2)
end

function lued.relued(dd)
  dofile(lued.pathifier( g_lued_root .. "/lued.lua"))
  lued.disp(dd)
end

function lued.spare()
  spare_hist_id = spare_hist_id or lued.get_hist_id()
  lued_prompt(spare_hist_id, "Undefined control character. Press <Enter> to continue...")
  lued.disp()
end

function lued.dont_use()
  dont_use_hist_id = dont_use_hist_id or lued.get_hist_id()
  lued_prompt(dont_use_hist_id, "Please do not use this control character. Press <Enter> to continue...")
  lued.disp()
end

function lued.logo()
  -- lued.logo generated by:
  -- http://patorjk.com/software/taag/#p=display&f=Big&t=LuEd%20v0%20.%2010


  local logo_str = [=[

  _           ______    _          ___        __  ___
 | |         |  ____|  | |        / _ \      /_ |/ _ \
 | |    _   _| |__   __| | __   _/ | | \      | | | | |
 | |   | | | |  __| / _` | \ \ / / | |        | | | | |
 | |___| |_| | |___| (_| |  \ V /\ |_| /  _   | | |_| |
 |______\__,_|______\__,_|   \_/  \___/  (_)  |_|\___/
]=]

return logo_str
end

function lued.help(n,dd)
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
- Ctrl+x / Ctrl+c / Ctrl+v lued.cut, lued.copy and lued.paste as expected.
- A common lued.cut and lued.paste sequence is Alt+z, move, Ctrl+c, move Ctrl+v
- Ctrl+d is the same as the delete key; Alt+d is the same as backspace key

Try the Scroll Wheel... It should work
Try Mouse select, right mouse button to lued.copy/lued.paste... It should work too.

More Help
- Alt+help2 shows more lued.help
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
- Alt+c copies current line to lued.paste buffer. Repeat to lued.copy more lines.

- Alt+l420<enter> goes to line 420

Multiple Files
- Ctrl+o opens a file and Ctrl-N creates a new file
- Ctrl+b shows a selectable list of all file buffers
- Alt+Shift+B goes to previous file buffer (useful when working with two files)

More Help
- <alt>lued.help for basic edit commands
- <alt>help3 for less lued.help
]]

local lua_help = [[

tbd...
More Help
- <alt>lued.help for basic edit commands
- <alt>help2 for more features
]]

  lued.disp(dd)
  if (n==1) then
    print (lued.logo())
    print (basic_help)
  elseif (n==2) then
    print (lued.logo())
    print (advanced_help)
  else
    print (lued.logo())
    print (lua_help)
  end
  lued.hit_cr()
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


function lued.duplicate_line(dd)
  local dd2 = 1
  lued.cut_line(1,dd2)
  lued.global_paste(dd2)
  lued.global_paste(dd2)
  lued.move_up_n_lines(1,dd)
end


function lued.hit_cr()
  hit_cr_hist_id = hit_cr_hist_id or lued.get_hist_id()
  lued_prompt(hit_cr_hist_id, "Press <Enter> to continue...")
end


function lued.save_session_file(dd)
  local n = get_numsessions()
  local id = get_fileid()
  local seshfile = io.open("session.lued","w")
  for i=1,n do
    local is_changed = is_modified(i) and "* " or "  "
    local is_current = i==g_tab_prev and "TT" or "  "
    is_current = i==id and "->" or is_current
--  local line = is_current..i..is_changed..get_filename(i)
    local line = get_filename(i)
    seshfile:write(line.."\n")
  end
  seshfile:close()
  lued.disp(dd)
end


function lued.load_session_file(dd)
  local sesh_file = io.open("session.lued","r")
  local all_files = sesh_file:read("*all")
  lued.open_file(all_files, dd)
end


function lued.select_tab_menu(filter,dont_print)
  dont_print = dont_print or false
  local n = get_numsessions()
  local t = { "Open Files" }
  local id = get_fileid()
  local found_i = 0
  local found_count = 0
  g_tab_prev = g_tab_prev or 1
  for i=1,n do
    local is_changed = is_modified(i) and "* " or "  "
    local is_current = i==g_tab_prev and "TT" or "  "
    is_current = i==id and "->" or is_current
    local line = is_current..i..is_changed..get_filename(i)
    if filter==nil or string.find(line,filter) then
      if id==n and found_i==0 or id~=n and found_i <= id then
        found_i = i
      end
      found_count = found_count + 1
      t[#t+1]=line
    end
  end
  print( "\n" .. table.concat(t, "\n") .. "\n" )   
  if found_count > 1 then found_i = 0 end
  return found_i, t
end


function lued.select_tab(filter)
  local id = get_fileid()
  local new_id = id
  local found_i = 0
  repeat
    found_i = lued.select_tab_menu(filter)
    if found_i ~= 0 then
      new_id = found_i
    else
      local hot = nil -- lued.hot_range('a','z') .. hot_range('A','Z') .. ",-,_,"
      -- print (hot); io.read()
      select_tab_hist_id = select_tab_hist_id or lued.get_hist_id()
      new_id = lued_prompt(select_tab_hist_id, "Enter File Id Number, 'tt' or portion of filename: ",hot)
      if new_id==nil or new_id=="" then
        lued.tab_toggle(dd)
        return
      end
      local new_id_int = tonumber(new_id)
      if new_id == 'tt' then
        new_id = g_tab_prev
        found_i = g_tab_prev
      elseif new_id_int==nil then
        filter = new_id
      elseif new_id_int==0 then
        new_id = id
        found_i = id
      else
        found_i = new_id_int
      end
    end
  until found_i > 0
  if (tonumber(new_id)~=id) then
    lued.session_sel(new_id)
  else
    lued.disp()
  end
end


function lued.set_comment(dd)
  local dd2 = 1
  set_comment_hist_id = set_comment_hist_id or lued.get_hist_id()
  local comment_str = lued_prompt(set_comment_hist_id,"Enter Comment String (Default = '"..g_comment.."'): ")
  if comment_str~=nil and comment_str~="" then
    g_comment = comment_str
  end
  lued.disp(dd)
end


function lued.set_indent_size(dd)
  local dd2 = 1
  set_indent_size_hist_id = set_indent_size_hist_id or lued.get_hist_id()
  local  indent_size = lued_prompt(set_indent_size_hist_id,"Enter Indent Size (Default = '"..g_indent_size.."'): ")
  if indent_size ~= nil and tonumber(indent_size) > 0 then
    g_indent_size = indent_size
  end
  lued.disp(dd)
end


function lued.join_lines(delim,n,dd)
  delim = delim or " "
  n = n or 1
  local dd2 = 1
  for i=1,n do
    local r,c = get_cur_pos()
    if not lued.is_eol() then
      lued.move_to_eol(dd2)
    end
    lued.del_char(dd2)
    ins_str(delim,dd2);
    set_cur_pos(r,c)
  end
  lued.disp(dd)
end


function lued.wrap_line(wrap_col,wrap_delim,dd)
  wrap_col = wrap_col or 60
  wrap_delim = wrap_delim or " "
  local dd2 = 1
  lued.move_to_eol(dd2)
  local r,c = get_cur_pos()
  while c > wrap_col do
    lued.move_left_n_words(dd2)
    r,c = get_cur_pos()
  end
  lued.ins_string("\n",dd2)
  if get_line_len() <= wrap_col then
    lued.join_lines(wrap_delim,dd2)
  end
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


function lued.comment(dd)
  local dd2 = 1
  lued.move_to_sol_classic(dd2)
  ins_str(g_comment,dd2);
  if not lued.is_eol() then
    ins_str(" ",dd2)
  end
  lued.move_down_n_lines(1,dd2)
  lued.move_to_sol_classic(dd2)
  lued.disp(dd)
end


function lued.comment_selected(dd)
  lued.foreach_selected(lued.comment, dd)
end


function lued.uncomment(dd)
  local dd2 = 1
  local comment_len = string.len(g_comment)
  lued.move_to_sol_classic(dd2)
  local line = get_line()
  if string.find(line,g_comment,1,true) == 1 then
    lued.del_char(comment_len+1,dd2)
  end
  lued.move_down_n_lines(1,dd)
end


function lued.uncomment_selected(dd)
  lued.foreach_selected(lued.uncomment, dd)
end


function lued.load_plugins(plugin_path)
  plugin_path = lued.pathifier(plugin_path)
  local plugins = lued.read_dir(plugin_path .. "/*.lua")
  for plugin in plugins:gmatch("(%S+)") do
    if (plugin ~= "") then
      dofile(plugin)
    end
  end
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


function lued.split_string (str, delimiter)
  delimiter = delimiter or "%s"
  local t={}
  for field in string.gmatch(str, "([^"..delimiter.."]+)") do
    table.insert(t, field)
  end
  return t
end


function lued.is_number(str)
  return (tonumber(str) ~= nil)
end


function lued.get_word(dd)
  local dd2 = 1
  lued.sel_word(dd2)
  set_sel_end(dd2)
  local sel_str, sel_sr, sel_sc, sel_er, sel_ec = lued.get_sel_str()
  lued.disp(dd)
  return sel_str
end


function lued.is_digit(ch)
  ch = ch or lued.get_char()
  return ( string.match(ch, "%d") )
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


function lued.get_number(dd)
  local dd2 = 1
  lued.sel_number(dd2)
  if is_sel_off() then
    lued.disp(dd)
    return nil
  end
  local sel_str, sel_sr, sel_sc = lued.get_sel_str()
  lued.disp(dd)
  return sel_str
end

-- go down 1 line and replace number with increment
function lued.incr(step_size, dd)
  g_incr_step = g_incr_step or 1
  step_size = step_size or g_incr_step
  local dd2 = 1
  local r,c = get_cur_pos()
  local tmp_str = lued.get_number(dd2)
  if tmp_str == nil then
    lued.disp(dd)
    return
  end
  local num = tonumber( tmp_str ) + step_size
  local num_str = tostring ( num )
  set_cur_pos(r,c)
  lued.move_down_n_lines(1,dd2)
  lued.sel_number(dd2)
  if lued.is_sel_on() then
    ins_str(num_str,dd2)
    set_cur_pos(r+1, c)
  end
  lued.disp(dd)
end

-- go down 1 line replace number with decrement
function lued.decr(step_size,dd)
  g_decr_step = g_decr_step or 1
  step_size = step_size or g_decr_step
  lued.incr(-1*step_size,dd)
end

