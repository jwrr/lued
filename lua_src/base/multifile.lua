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


function lued.tab_next(dd)
  local num_sessions = get_numsessions()
  local next_session = (get_fileid() % num_sessions)+1
  lued.session_sel(next_session, dd)
  return get_fileid()
end


function lued.tab_prev(dd)
  local num_sessions = get_numsessions()
  local next_session = get_fileid()-1
  if next_session<1 then
    next_session = num_sessions
  end
  lued.session_sel(next_session, dd)
  return get_fileid()
end


function lued.tab_toggle(dd)
  local num_sessions = get_numsessions()
  local this_session = get_fileid()
  if g_tab_prev == nil and get_numsessions() > 1 then
    if this_session < num_sessions then
      g_tab_prev = this_session + 1
    else
      g_tab_prev = this_session - 1
    end
  end
  lued.session_sel(g_tab_prev, dd)
end




function lued.create_tab_select_menu(filter, dont_print)
  dont_print = dont_print or false
  local n = get_numsessions()
  local t = { "Open Files" }
  local id = get_fileid()
  local found_i = 0
  local found_count = 0
  g_tab_prev = g_tab_prev or 1
  for i=1,n do
    local is_changed = is_modified(i) and "* " or "  "
    local is_current = i==g_tab_prev and "TT" or "  "
    is_current = i==id and "->" or is_current
    local line = is_current..i..is_changed..get_filename(i)
    if filter==nil or string.find(line,filter) then
      if id==n and found_i==0 or id~=n and found_i <= id then
        found_i = i
      end
      found_count = found_count + 1
      t[#t+1]=line
    end
  end
  print( "\n" .. table.concat(t, "\n") .. "\n" )   
  if found_count > 1 then found_i = 0 end
  return found_i, t
end


function lued.display_menu(filter,dont_print)
  dont_print = dont_print or false
  local n = get_numsessions()
  local t = { "Open Files" }
  local id = get_fileid()
  local found_i = 0
  local found_count = 0
  g_tab_prev = g_tab_prev or 1
  for i=1,n do
    local is_changed = is_modified(i) and "* " or "  "
    local is_current = i==g_tab_prev and "TT" or "  "
    is_current = i==id and "->" or is_current
    local line = is_current..i..is_changed..get_filename(i)
    if filter==nil or string.find(line,filter) then
      if id==n and found_i==0 or id~=n and found_i <= id then
        found_i = i
      end
      found_count = found_count + 1
      t[#t+1]=line
    end
  end
  print( "\n" .. table.concat(t, "\n") .. "\n" )   
  if found_count > 1 then found_i = 0 end
  return found_i, t
end




function lued.select_tab_menu(filter,dont_print)
  dont_print = dont_print or false
  local n = get_numsessions()
  local t = { "Open Files" }
  local id = get_fileid()
  local found_i = 0
  local found_count = 0
  g_tab_prev = g_tab_prev or 1
  for i=1,n do
    local is_changed = is_modified(i) and "* " or "  "
    local is_current = i==g_tab_prev and "TT" or "  "
    is_current = i==id and "->" or is_current
    local line = is_current..i..is_changed..get_filename(i)
    if filter==nil or string.find(line,filter) then
      if id==n and found_i==0 or id~=n and found_i <= id then
        found_i = i
      end
      found_count = found_count + 1
      t[#t+1]=line
    end
  end
  print("\n", table.concat(t, "\n"))

  print("----------------------")
  local current_id = get_fileid()
  local current_filename = get_filename(current_id)
  g_recent_files = g_recent_files or {}
  
  for i,val in ipairs(g_recent_files) do
    if val == current_id then
      table.remove(g_recent_files, i)
      break
    end
  end
  
  table.insert(g_recent_files, 1, current_id)
  n = math.min(#g_recent_files, 5) -- local
  t = {} -- local
  for recent_i=1,n do
    local i = g_recent_files[recent_i]
    local is_changed = is_modified(i) and "* " or "  "
    local is_current = i==g_tab_prev and "TT" or "  "
    is_current = i==id and "->" or is_current
    local line = is_current..i..is_changed..get_filename(i)
    t[#t+1]=line
  end
  print(table.concat(t, "\n"))
     
  if found_count > 1 then found_i = 0 end
  return found_i, t
end


function lued.select_tab(filter)
  local id = get_fileid()
  local new_id = id
  local found_i = 0
  repeat
    found_i = lued.select_tab_menu(filter)
    if found_i ~= 0 then
      new_id = found_i
    else
      local hot = nil -- lued.hot_range('a','z') .. hot_range('A','Z') .. ",-,_,"
      -- print (hot); io.read()
      select_tab_hist_id = select_tab_hist_id or lued.get_hist_id()
      new_id = lued.prompt(select_tab_hist_id, "Enter File Id Number, 'tt' or portion of filename: ",hot)
      if new_id==nil or new_id=="" then
        lued.tab_toggle(dd)
        return
      end
      local new_id_int = tonumber(new_id)
      if new_id == 'tt' then
        new_id = g_tab_prev
        found_i = g_tab_prev
      elseif new_id_int==nil then
        filter = new_id
      elseif new_id_int==0 then
        new_id = id
        found_i = id
      else
        found_i = new_id_int
      end
    end
  until found_i > 0
  if (tonumber(new_id)~=id) then
    lued.session_sel(new_id)
  else
    lued.disp()
  end
end

