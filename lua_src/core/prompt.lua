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



function lued.prompt(hist_id,prompt,hot,test_str)
  hist_id = hist_id or 0
  prompt = prompt or "--> "
  hot = hot or ""
  io.write(" ")
  str = io_read(hist_id,prompt,hot,test_str)
  return str
end


function lued.dbg_prompt(dbg_str)
  local str = ""
  local prompt = "DBG> "..dbg_str..": "
  str = lued.prompt(0,prompt)
  return str
end


function lued.hit_cr()
  hit_cr_hist_id = hit_cr_hist_id or lued.get_hist_id()
  lued.prompt(hit_cr_hist_id, "Press <Enter> to continue...")
end




