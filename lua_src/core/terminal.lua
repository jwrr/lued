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


function lued.decset(val)
  val = val or 1000
  lued.set_min_lines_from_top(0)
  lued.set_min_lines_from_bot(0)
  local esc = string.char(27)
  local csi = esc .. "["
  io.write( csi .. "?" .. val .. "h" )
end


function lued.decrst(val)
  val = val or 1000
  lued.set_min_lines_from_top()
  lued.set_min_lines_from_bot()
  local esc = string.char(27)
  local csi = esc .. "["
  io.write( csi .. "?" .. val .. "l" )
end


-- disable/enable ctrl+S ctrl+Q XON/XOFF Flow Control
function lued.set_ctrl_s_flow_control (bool, dd)
  if bool==nil then
    g_ctrl_s_flow_control = not g_ctrl_s_flow_control
  else
    g_ctrl_s_flow_control = bool
  end
  if g_ctrl_s_flow_control==true then
    os.execute("stty ixon ixoff")
  else
    os.execute("stty -ixon -ixoff")
  end
  lued.disp(dd)
end


-- disable/enable ctrl+C abort
function lued.set_ctrl_c_abort (bool, dd)
  if bool==nil then
    g_ctrl_c_abort = not g_ctrl_c_abort
  else
    g_ctrl_c_abort = bool
  end
  if g_ctrl_c_abort==true then
    os.execute("stty intr ^C")
  else
    os.execute("stty intr undef")
  end
  lued.disp(dd)
end


-- disable/enable ctrl+Z suspend
function lued.set_ctrl_z_suspend (bool, dd)
  local change = true
  if bool==nil then
    g_ctrl_z_suspend = not g_ctrl_z_suspend
  else
    change = (g_ctrl_z_suspend ~= bool)
    g_ctrl_z_suspend = bool
  end
  if change then
    if g_ctrl_z_suspend==true then
      os.execute("stty susp ^Z")
    else
      os.execute("stty susp undef")
    end
  end
  lued.disp(dd)
  return change
end


function lued.toggle_ctrl_z_suspend (dd)
  lued.set_ctrl_z_suspend(not g_ctrl_z_suspend,dd)
end


function lued.toggle_ctrl_c_abort (dd)
  lued.set_ctrl_c_abort(not g_ctrl_c_abort,dd)
end







