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



function lued.remove_all_trailing_space(dd)
  local dd2 = 1
  local r,c = get_cur_pos()
  local pr,pc = get_page_pos()
  local numlines = get_numlines()
  for i=1,numlines do
    set_cur_pos(i,1)
    lued.remove_trailing_spaces(0,0,true,dd2)
  end
  set_cur_pos(r,c)
  set_page_pos(pr,pc)
  lued.disp(dd)
end


function lued.remove_all_trailing_space_all_files(dd)
  local dd2 = 1
  local fileid = get_fileid()
  local num_sessions = get_numsessions()
  for i=1,num_sessions do
    lued.session_sel(i,dd2)
    lued.remove_all_trailing_space(dd2)
  end
  lued.session_sel(fileid,dd)
end


function lued.remove_all_leading_tabs(tab_size,dd)
  tab_size = tab_size or  8
  local dd2 = 1
  local r,c = get_cur_pos()
  local numlines = get_numlines()
  for i=1,numlines do
    set_cur_pos(i,1)
    local line = get_line()
    local leading_ws = string.match(line,"^%s+") or ""
    if (leading_ws ~= nil) then
      local leading_ws_len = string.len(leading_ws)
      local tabi = string.find(leading_ws,"\t")
      local count = 0
      while tabi~=nil and count < 10 do
        count = count + 1
        tabi = tabi - 1
        local num_tab = math.floor(tabi / tab_size)
        local next_tab = tab_size*(num_tab+1)
        local this_tab_size = next_tab - tabi;
        local spaces = string.rep(' ',this_tab_size);
        leading_ws = string.gsub(leading_ws, "(\t)", spaces, 1)
        tabi = string.find(leading_ws,"\t")
      end
      set_sel_start()
      set_cur_pos(i,leading_ws_len+1)
      set_sel_end()
      lued.del_sel(dd2)
      lued.ins_str(leading_ws,dd2)
    end
  end -- for
  set_cur_pos(r,c)
  lued.disp(dd)
end



