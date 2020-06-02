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
--   local comment_str = g_comment
  local comment_str = lued.get_line_comment()
  ins_str(comment_str, dd2);
  if not lued.is_eol() then
    ins_str(" ",dd2)
  end
  lued.move_down_n_lines(1,dd2)
  lued.move_to_sol_classic(dd2)
  lued.disp(dd)
end


function lued.comment_selected(dd)
  if lued.is_sel_on() then
    local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
    if sel_sr==sel_er then set_sel_off() end
  end
  lued.foreach_selected(lued.comment, dd)
end


function lued.uncomment(dd)
  local dd2 = 1
  local comment_str = lued.get_line_comment()
  local comment_len = string.len(comment_str)
  lued.move_to_sol_classic(dd2)
  local line = get_line()
  if string.find(line, lued.get_line_comment(), 1, true) == 1 then
    local del_len = math.min( comment_len, #line)
    if string.find(line, comment_str.." ", 1, true) == 1 then
      del_len = comment_len + 1
    end
    lued.del_char(del_len,dd2)
  end
  lued.move_down_n_lines(1,dd)
end


function lued.uncomment_selected(dd)
  if lued.is_sel_on() then
    local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
    if sel_sr==sel_er then set_sel_off() end
  end
  lued.foreach_selected(lued.uncomment, dd)
end




