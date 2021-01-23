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

lued.line_comments = {}

function lued.set_comment(dd)
  local dd2 = 1
  local comment_str = lued.get_line_comment()
  set_comment_hist_id = set_comment_hist_id or lued.get_hist_id()
  local comment_str = lued.prompt(set_comment_hist_id,"Enter Comment String (Default = '"..comment_str.."'): ")
  local filetype = lued.get_filetype()
  if filetype then
    lued.line_comments[filetype] = comment_str
  end
  lued.disp(dd)
end


function lued.comment(dd)
  local dd2 = 1
  lued.move_to_sol_classic(dd2)
  local comment_str = lued.get_line_comment()
  lued.ins_str(comment_str, dd2);
  if not lued.is_eol() then
    lued.ins_str(" ",dd2)
  end
  lued.disp(dd)
end


function lued.comment_move_down(dd)
  local dd2 = 1
  lued.comment(dd2)
  lued.move_down(dd2)
  lued.move_to_sol_classic(dd2)
end  


function lued.comment_selected(dd)
  if lued.is_sel_on() then
    local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
    if sel_sr==sel_er then set_sel_off() end
  end
  lued.foreach_selected(lued.comment_move_down, dd)
end


function lued.uncomment(dd)
  local dd2 = 1
  local comment_str = lued.get_line_comment()
  local comment_len = string.len(comment_str)
  lued.move_to_sol_classic(dd2)
  local line = get_line()
  if lued.is_comment() then
    local del_len = math.min( comment_len, #line)
    if string.find(line, comment_str.." ", 1, true) == 1 then
      del_len = comment_len + 1
    end
    lued.del_char(del_len,dd2)
  end
end

function lued.uncomment_move_down(dd)
  local dd2 = 1
  lued.uncomment(dd2)
  lued.move_down(dd)
end

function lued.uncomment_selected(dd)
  if lued.is_sel_on() then
    local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
    if sel_sr==sel_er then set_sel_off() end
  end
  lued.foreach_selected(lued.uncomment_move_down, dd)
end


function lued.is_comment(linenumber)
  local line = lued.get_line(linenumber)
  local comment_marker = lued.get_line_comment()
  local line_starts_with_comment = string.find(line, comment_marker, 1, true) == 1
  return line_starts_with_comment
end


function lued.is_blankcomment()
  local dd2 = 1
  if lued.is_lastline() then return false end
  local r,c = get_cur_pos()
  local is_comment = lued.is_comment()
  local is_blank = false
  local current_line = get_line()
  if is_comment then
    lued.uncomment(dd2)
    current_line = get_line()
    is_blank = lued.is_blankline()
    lued.comment(dd2)
  end
  set_cur_pos(r,c)
  return is_blank, current_line
end


function lued.next_is_comment()
  if lued.is_lastline() then return false end
  local r,c = get_cur_pos()
  set_cur_pos(r+1,c)
  local is_comment = lued.is_comment()
  set_cur_pos(r,c)
  return is_comment
end


function lued.next_is_blankcomment()
  local dd2 = 1
  if lued.is_lastline() then return false end
  local r,c = get_cur_pos()
  set_cur_pos(r+1,c)
  local is_comment = lued.is_comment()
  local is_blank = false
  local next_line = get_line()
  if is_comment then
    lued.uncomment(dd2)
    next_line = get_line()
    is_blank = lued.is_blankline()
    lued.comment(dd2)
  end
  set_cur_pos(r,c)
  return is_blank, next_line
end






