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


function lued.set_comment(dd)
  local dd2 = 1
  set_comment_hist_id = set_comment_hist_id or lued.get_hist_id()
  local comment_str = lued.prompt(set_comment_hist_id,"Enter Comment String (Default = '"..g_comment.."'): ")
  if comment_str~=nil and comment_str~="" then
    g_comment = comment_str
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
    local del_len = math.min( comment_len+1 , #line)
    lued.del_char(del_len,dd2)
  end
  lued.move_down_n_lines(1,dd)
end


function lued.uncomment_selected(dd)
  lued.foreach_selected(lued.uncomment, dd)
end




