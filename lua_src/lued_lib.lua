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


function lued.toggle_review_mode(dd)
  g_review_mode = g_review_mode or false
  g_review_mode = not g_review_mode
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


function lued.leading_ws()
  local line = get_line()
  local ws = string.match(line,"^%s+") or ""
  local ws_len = string.len(ws)
  return ws, ws_len
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


function lued.explode(subject, sep,  lim)
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


-- Dummy function, usually replaced by base.sidebar
function lued.sidebar(lines)
  return lines
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
--  if not g_show_abs_line_numbers and not styles.enable then
--    return lines
--  end

  -- subtract one because for loop adds one
  first_line_of_page = first_line_of_page-1

  -- set the first and last lines to include all lines or just current line
  local update_only_cursor_line = false -- FIXME not g_show_abs_line_numbers and styles.normal==""
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
      lines = lued.sidebar(lines)
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


function lued.set_pagesize(val,dd)
  val = val or 0 -- zero is a special case.
  g_page_size = val
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


function lued.chomp(str)
  str = str or ""
  return str:gsub("\n$","")
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

function lued.hit_cr()
  hit_cr_hist_id = hit_cr_hist_id or lued.get_hist_id()
  lued_prompt(hit_cr_hist_id, "Press <Enter> to continue...")
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


function lued.split_string (str, delimiter)
  delimiter = delimiter or "%s"
  local t={}
  for field in string.gmatch(str, "([^"..delimiter.."]+)") do
    table.insert(t, field)
  end
  return t
end



