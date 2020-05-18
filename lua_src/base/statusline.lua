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

