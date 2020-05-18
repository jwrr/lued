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



