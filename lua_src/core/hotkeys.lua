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


function lued.hot(key, dd)
  if key == nil then return end
  key = "," .. key .. ","
  local keys = get_hotkeys()
  if not string.find(keys, key, 1, true) then
    set_hotkeys(keys .. key)
  end
  lued.disp(dd)
end


function lued.nohot(key, dd)
  if not key then return end
  key = key .. ","
  local keys = get_hotkeys()
  keys:gsub(key,"")
  set_hotkeys(keys)
  lued.disp(dd)
end


function lued.hot_range(lower,upper)
  local hot = ""
  for ch=string.byte(lower),string.byte(upper) do
    hot = hot .. "," .. string.char(ch)
  end
  if hot ~= "" then hot = hot .. "," end
  return hot
end


function lued.spare()
  spare_hist_id = spare_hist_id or lued.get_hist_id()
  lued.prompt(spare_hist_id, "Undefined control character. Press <Enter> to continue...")
  lued.disp()
end


function lued.dont_use()
  dont_use_hist_id = dont_use_hist_id or lued.get_hist_id()
  lued.prompt(dont_use_hist_id, "Please do not use this control character. Press <Enter> to continue...")
  lued.disp()
end





