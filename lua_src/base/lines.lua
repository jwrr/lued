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


function lued.join_lines(delim,n,dd)
  delim = delim or " "
  n = n or 1
  local dd2 = 1
  for i=1,n do
    local r,c = get_cur_pos()
    if not lued.is_eol() then
      lued.move_to_eol(dd2)
      if lued.is_space() then
        lued.del_sow() -- delete spaces
      end
    end
    lued.del_char(dd2)
    if lued.is_space() then
      lued.del_eow() -- delete spaces
    end
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





