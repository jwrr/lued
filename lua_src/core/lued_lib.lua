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

lued = {}
lued.filetypes = {}  -- maps extensions to filetypes
lued.snippets  = {}  -- contains snippets for each filetype

lued.g_buffer = ""    -- The global buffer is used for lued.cut and lued.paste between multiple files.


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


function lued.reinit(dd)
  dofile(lued.pathifier( g_lued_root .. "/lued.lua"))
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


function lued.leading_ws()
  local line = get_line()
  local ws = string.match(line,"^%s+") or ""
  local ws_len = string.len(ws)
  return ws, ws_len
end


function lued.explode(subject, sep,  lim)
  subject = subject or ""
  sep = sep or "\n"
  lim = lim or 0 -- 0 means no limit

  if (#subject==0) or (#sep==0) then
    return {} -- invalid arg: return empty array
  end

  local pieces = {}
  local done = false
  local piece_start = 1
  repeat
    local sep_pos = string.find( subject, sep, piece_start ) or #subject+1
    local piece = string.sub( subject, piece_start , sep_pos-1 )
    pieces[#pieces+1] = piece
    piece_start = sep_pos + #sep
    done = (piece_start > #subject) or (#pieces == lim)
  until done
  return pieces
end


function lued.implode(pieces, sep, trailing_sep, first, last)
  sep = sep or "\n"
  trailing_sep = trailing_sep or sep
  return table.concat(pieces,sep,first,last) .. trailing_sep
end

lued.get_cur_pos = get_cur_pos
lued.get_line    = get_line
lued.set_cur_pos = set_cur_pos
lued.set_sel_off = set_sel_off




