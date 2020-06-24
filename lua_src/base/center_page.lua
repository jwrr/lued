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

function set_recenter_screen(dd)
  lued.recenter_screen = true
  lued.disp(dd)
end

function clr_recenter_screen(dd)
  lued.recenter_screen = false
  lued.disp(dd)
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







