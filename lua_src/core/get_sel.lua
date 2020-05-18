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


function lued.get_next_line()
  local dd2 = 1
  local r,c = get_cur_pos()
  set_cur_pos(r+1,c)
  local next_line = get_line()
  set_cur_pos(r,c)
  return next_line
end


function lued.get_char(offset)
  offset = offset or 0  -- offset is useful for getting next/prev char
  local r,c = get_cur_pos()
  local pos = c + offset
  pos = math.max(1, pos)
  pos = math.min(get_line_len(), pos)
  local line = get_line() or ""
  return string.sub( line , pos, pos)
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
  

function lued.get_word(dd)
  local dd2 = 1
  lued.sel_word(dd2)
  set_sel_end(dd2)
  local sel_str, sel_sr, sel_sc, sel_er, sel_ec = lued.get_sel_str()
  lued.disp(dd)
  return sel_str
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




