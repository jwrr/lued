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


function lued.mouse_config(val)
  if val==nil then
    if g_decset==nil or g_decset==0 then
      val = 1000
    else
      val = 0
    end
  end

  if g_decset and g_decset~=0 and val~=g_decset then
    lued.decrst(g_decset)
  end
  if (val~=0) then -- 9 = x10 1000 = normal
    lued.decset(val)
  else
    lued.decrst(g_decset)
  end
  g_decset = val;
end


function lued.mouse_event(str)
  str = str or ""
  if g_mouse_remove_trailing_comma then
    local last_pos = #str-1
    local last_char = string.sub(str, last_pos, last_pos)
    if last_char == "," then
      str = string.sub(str, 1, last_pos)
    end
  end
  local dd2 = 0
  local Cb = string.byte(str,1) - 32
  local Cx = string.byte(str,2) - 32
  local Cy = string.byte(str,3) - 32
  print("***",str,"***",Cb,Cx,Cy)
  local r,c = get_cur_pos()
  local pr,pc = get_page_pos()
  if Cb==0 then -- mouse down
    g_mouse_down_x = Cx
    g_mouse_down_y = Cy
    set_cur_pos(pr+Cy-2,Cx)
  elseif Cb==3 then -- mouse up
    print("MUP",Cx,Cy,g_mouse_down_x,g_mouse_down_y);
    if (Cx~=g_mouse_down_x or Cy~=g_mouse_down_y) then
      set_sel_start()
      set_cur_pos(pr+Cy-2,Cx)
      -- set_sel_end()
    end
  elseif Cb==64 then  -- scroll wheel forward
    lued.move_up_n_lines(2,dd2)
  elseif Cb==65 then  -- scroll wheel backward
    lued.move_down_n_lines(2,dd2)
  else
    dd2 = 1
  end
  lued.disp(dd2)
end






