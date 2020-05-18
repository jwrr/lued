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


function lued.set_named_mark(dd)
  named_mark_hist_id = named_mark_hist_id or lued.get_hist_id()
  local hot = nil
  mark_name = lued.prompt(select_tab_hist_id, "Set Mark - Enter Name: ",hot)
  set_mark(mark_name);
  lued.disp(dd)
end


function lued.goto_named_mark(dd)
  named_mark_hist_id = named_mark_hist_id or lued.get_hist_id()
  local hot = nil
  mark_name = lued.prompt(select_tab_hist_id, "Goto Mark - Enter Name: ",hot)
  goto_mark(mark_name);
  lued.disp(dd)
end


function lued.set_nameless_mark(dd)
  local dd2 = 1
  g_nameless_stack = g_nameless_stack or 0
  set_mark("nameless_" .. g_nameless_stack)
  g_nameless_stack = g_nameless_stack + 1
  lued.disp(dd)
end


function lued.goto_nameless_mark_prev(dd)
  g_nameless_stack = g_nameless_stack or 1
  if g_nameless_stack==0 then g_nameless_stack = 1 end
  g_nameless_stack = g_nameless_stack - 1
  goto_mark("nameless_" .. g_nameless_stack)
  lued.disp(dd)
end

function lued.sel_mark_to_cursor(dd)
  local dd2 = 1
  local r1,c1 = get_cur_pos()
  lued.goto_nameless_mark_prev(dd2)
  local r2,c2 = get_cur_pos()

  if (r1 < r2) then
    -- do nothing
  elseif (r1 > r2) then
  elseif (c1 < c2) then
    -- do nothing
  elseif (c1 > c2) then
    r1,r2 = r2,r1
    c1,c2 = c2,c1
  else
    lued.disp(dd)
    return
  end

  set_cur_pos(r1,c1)
  set_sel_start()
  set_cur_pos(r2,c2)
  set_sel_end()
  lued.disp(dd)
end


function lued.del_mark_to_cursor(dd)
  local dd2 = 1
  lued.sel_mark_to_cursor(dd2)
  lued.del_sel(dd)
end


function lued.goto_nameless_mark_next(dd)
  g_nameless_stack = g_nameless_stack or 0
  g_nameless_stack = g_nameless_stack + 1
  local found = goto_mark("nameless_" .. g_nameless_stack)
  if not found then g_nameless_stack = g_nameless_stack - 1 end
  lued.disp(dd)
end


