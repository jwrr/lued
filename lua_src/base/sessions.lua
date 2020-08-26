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


function lued.save_session_file(dd)
  local n = get_numsessions()
  if n == 1 then
    return
  end
  local resp = lued.get_yesno("Save session <y/N>? ","N")
  if resp ~= 'Y' then
    return
  end
  local id = get_fileid()
  local sf = io.open("session.lua", "w")
  if sf == nil then
    return
  end
  for i=1,n do
    local filename, r, c = lued.get_filenamerc(i)
    local str = "lued.open_filerc('" .. filename .. "', " .. tonumber(r) .. ", " .. tonumber(c) .. ")\n"
    sf:write(str) io.write(str)
  end
  local str = "lued.select_tab('" .. lued.get_filename(id) .. "')\n"
  sf:write(str) io.write (str)
  sf:close()
--   io.read()
--   lued.disp(dd)
end


function lued.load_session_file(dd)
  local sesh_file = io.open("session.lua","r")
  local all_files = sesh_file:read("*all")
  lued.open_file(all_files, dd)
end


function lued.session_sel(session_id,dd)
  if session_id then
    local fileid = get_fileid()
    if session_id ~= fileid then
      g_tab_prev = fileid
    end
    set_fileid(session_id)
  end
  lued.disp(dd)
end


