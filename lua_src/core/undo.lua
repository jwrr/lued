--[[
MIT License

Copyright (c) 2018 JWRR.COM

git clone https://github.com/jwrr/lued.git

Permission is hereby granted, free of charge, to any person obtaining a lued.copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, lued.copy, modify, merge, publish, distribute, sublicense, and/or sell
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


function lued.undo_cmd(dd)
  local last_cmd = get_last_cmd()
--  lued.dbg_prompt("last_cmd="..last_cmd.."xxx")
  -- set_ctrl_z_suspend(true);
  undo()
  lued.disp(dd)
end


function lued.redo_cmd(dd)
  redo()
  lued.disp(dd)
end


function lued.alt_z_wrapper(dd)
  local dd2 = 1;
  if g_ctrl_z_suspend then
    lued.undo_cmd(dd2)
  else
    lued.set_ctrl_z_suspend(true)
  end
  lued.disp(dd)
end




