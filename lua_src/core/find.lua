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


function lued.set_find_case_sensitive(dd)
  g_find_case_sensitive = true
  lued.disp(dd)
end

function lued.clr_find_case_sensitive(dd)
  g_find_case_sensitive = false
  lued.disp(dd)
end

function lued.get_find_whole_word()
  return g_find_whole_word
end

function lued.set_find_whole_word(dd)
  g_find_whole_word = true
  lued.disp(dd)
end

function lued.clr_find_whole_word(dd)
  g_find_whole_word = false
  lued.disp(dd)
end

function lued.toggle_find_whole_word(dd)
  g_find_whole_word = not g_find_whole_word
  lued.disp(dd)
end


-- Not used anymore FIXME DELETE ME
-- function find(str,dd)
--   local dd2 = 1
--   local r,c = get_cur_pos()
--   local found,r2,c2 = find_str(str)
--   if found==0 then
--     lued.move_to_first_line(dd2)
--
--     found,r2,c2 = find_str(str)
--     set_cur_pos(r,c)
--   end
--   if found ~= 0 then
--     -- lued.remove_trailing_spaces(r2,c2,false,dd2)
--     local pr,pc = get_page_pos()
--     local tr,tc = get_termsize()
--     local lr = pr+tr
--     local page_change = r2 > lr-third or r2 < pr+third
--     if page_change==true then
--       lued.set_page_offset_percent(third,dd2)
--     end
--   end
--   lued.disp(dd)
-- end


function lued.find_prompt(test_str)
  test_str = test_str or ""
  local str = ""
  -- repeat
    local default_str = ""
    if g_find_str and g_find_str~="" then
      default_str = " (default='"..g_find_str.."')"
    end

    local prompt = "String to Find"..default_str..": "

    find_prompt_hist_id = find_prompt_hist_id or lued.get_hist_id()

    local hot=""
    str = lued.prompt(find_prompt_hist_id, prompt, hot, test_str)
--    str = find_read(0,prompt)
    if str==nil or str=="" and g_find_str and g_find_str~="" then
      str = g_find_str
    else
      lued.disp()
    end
  -- until str and str ~= ""
  if (str=="/*") then str = "/" .. "\\" .. "*" end
  return str
end


function lued.replace_prompt()
  local str = ""
  -- repeat
    local default_str = ""
    if g_replace_str and g_replace_str~="" then
      default_str = " (default='"..g_replace_str.."')"
    end

    local prompt = "String to Replace"..default_str..": "
    replace_prompt_hist_id = replace_prompt_hist_id or lued.get_hist_id()
    str = lued.prompt(replace_prompt_hist_id, prompt)
--    str = replace_read(prompt)
    if str==nil or str=="" and g_replace_str and g_replace_str~="" then
      str = g_replace_str
    else
      lued.disp()
    end
  -- until str and str ~= ""
  return str
end


g_find_jump_back_stack = {}
g_find_jump_forward_stack = {}
function lued.push_jump_stack(stack, fileid, row, col)
  local entry = {fileid, row, col}
  table.insert(stack, entry)
end


function lued.pop_jump_stack(stack)
  if #stack == 0 then
    return 0, 0, 0
  end
  local entry = stack[#stack] or {0,0,0}
  table.remove(stack)
  local fileid = entry[1] or 0
  local row = entry[2] or 0
  local col = entry[3] or 0
  return fileid, row, col
end


function lued.jump_back(jump_back_stack, jump_forward_stack, dd)
  local dd2 = 1

  local fileid = get_fileid()
  local r, c = get_cur_pos()
  lued.push_jump_stack(jump_forward_stack, fileid, r, c)


  local fileid, row, col = lued.pop_jump_stack(jump_back_stack)
  if fileid ~= get_fileid() then
    lued.session_sel(fileid, dd2)
  end
  if row ~= 0 then
    set_cur_pos(row, col)
  end
  lued.disp(dd)
end


function lued.jump_forward(jump_back_stack, jump_forward_stack, dd)
  local dd2 = 1

  local fileid = get_fileid()
  local r, c = get_cur_pos()
  lued.push_jump_stack(jump_back_stack, fileid, r, c)

  local fileid, row, col = lued.pop_jump_stack(jump_forward_stack)
  if fileid ~= get_fileid() then
    lued.session_sel(fileid, dd2)
  end
  if row ~= 0 then
    set_cur_pos(row, col)
  end
  lued.disp(dd)
end


function lued.find_jump_back(dd)
  lued.jump_back(g_find_jump_back_stack, g_find_jump_forward_stack, dd)
end


function lued.find_jump_forward(dd)
  lued.jump_back(g_find_jump_back_stack, g_find_jump_forward_stack, dd)
end

g_find_plaintext = g_find_plaintext or true

function lued.find_all_on_line(line,str)
  local matchi = {}
  local s,e = 1,1
  local match_count = 0

  find_plaintext = g_find_plaintext and not g_find_whole_word


  if g_find_whole_word then
    str2 = "%f[%w_]" .. str .. "%f[^%w_]"
  else
    str2 = str
  end

  repeat
    s,e = string.find(line,str2,e,find_plaintext)
    if s ~= nil then
     match_count = match_count + 1
     matchi[match_count] = s
      e = e + 1
    end
  until (s == nil)
  return matchi
end


function lued.get_last_match(matches, maxc)
  if matches==nil then return end
  local last_match
  for i=1,#matches do
    if matches[i] < maxc then
      last_match = matches[i]
    end
  end
  return last_match
end


function lued.find_reverse(str,dd)
  local dd2 = 1
  if (str==nil or str=="") then
    g_find_str = lued.find_prompt()
  else
    g_find_str = str
  end
  if g_find_str == "" then
    lued.disp(dd)
    return
  end

  local g_find_str2 = g_find_str
  if not g_find_case_sensitive then
    g_find_str2 = string.lower(g_find_str)
  end

  local r,c = get_cur_pos()
  local pr,pc = get_page_pos()
  c = c-1
  local numlines = get_numlines()
  local match_found = false
  for k=numlines,1,-1 do
    i = (r+k-numlines) % numlines
    local line = get_line()
    if not g_find_case_sensitive then
      line = string.lower(line)
    end
    local matches = lued.find_all_on_line(line,g_find_str2)
    local maxc = i==r and c or string.len(line)+1
    local match_c = lued.get_last_match(matches,maxc)
    for j=1,#matches do matches[j] = nil end
    match_found = (match_c ~= nil)
    if match_found then
      local cfileid = get_fileid()
      local cr, cc = get_cur_pos()
      if not dd then
        lued.push_jump_stack(g_find_jump_back_stack, cfileid, cr, cc)
      end

      local match_str = string.match(line,g_find_str2,match_c)
      local match_len = string.len(match_str)
      set_cur_pos(i,match_c)
      set_sel_start()
      set_cur_pos(i,match_c+match_len)
      set_sel_end()
      set_cur_pos(i,match_c)
      break
    else
      if k==1 then
        set_cur_pos(r,c+1)
        set_page_pos(pr,pc)
      else
        set_cur_pos(i-1,1)
      end
    end
  end
  lued.disp(dd)
  return match_found
end


function lued.find_reverse_again(dd)
  local dd2 = 1
  local skip = g_find_str==nil or g_find_str==""
  if not skip then
    lued.find_reverse(g_find_str,dd2)
  end
  lued.disp(dd)
end


function lued.find_reverse_selected(dd)
  local dd2 = 1
  local initial_r,initial_c = get_cur_pos()
  local pr,pc = get_page_pos()

  local sel_str, sel_sr, sel_sc = lued.get_sel_str()
  local found = false
  if sel_str~="" then
    g_find_str = sel_str
--  lued.dbg_prompt("DBG sel_sr="..sel_sr.." initial_r="..initial_r)
    set_cur_pos(sel_sr,sel_sc)
    found = lued.find_reverse(g_find_str,dd2)
    if found then
      local new_r,new_c = get_cur_pos()
      local delta_r = initial_r - new_r
    else
      set_cur_pos(initial_r,initial_c)
    end
  end
  local center = true
  lued.disp(dd, center)
  return found
end


function lued.get_first_match(matches, minc)
  if matches==nil then return end
  local first_match
  for i=1,#matches do
    if matches[i] > minc then
      first_match = matches[i]
      break
    end
  end
  return first_match
end

-- found = lued.find_forward(str,true,false,false,'',dd2)
function lued.find_forward(str,nowrap,search_all,replace,test_str,dd)
  test_str = test_str or ""
  local dd2 = 1

  local cfileid = get_fileid()
  local cr, cc = get_cur_pos()

  local found = false
  if test_str ~= "" then
    g_find_str = lued.find_prompt(test_str)
  elseif str==nil or str=="" then
    g_find_str = lued.find_prompt()
  else
    g_find_str = str
  end
  if g_find_str == "" then
    lued.disp(dd)
    return
  end

  local g_find_str2 = g_find_str
  if not g_find_case_sensitive then
    g_find_str2 = string.lower(g_find_str2)
  end

  if replace and (str==nil or str=="") then
    g_replace_str = lued.replace_prompt()
  end

  local r,c = get_cur_pos()
  local pr,pc = get_page_pos()
  local numlines = get_numlines()
  local i = 0
  for k=1,numlines,1 do
    local ibefore = i
    i = (((r+k-1)-1) % numlines)+1
    local wrap = i < ibefore
    if wrap==true and nowrap==true then break end
    set_cur_pos(i,1)
    local line = get_line()
    if not g_find_case_sensitive then
      line = string.lower(line)
    end
    local matches = lued.find_all_on_line(line,g_find_str2)
    local minc = 0
    if i==r and not search_all then
      minc = c
    end
    local match_c = lued.get_first_match(matches,minc)
    for j=1,#matches do matches[j] = nil end
    if match_c == nil then
      if k==numlines then
        local r2,c2 = get_cur_pos()
        local pr2,pc2 = get_page_pos()
        set_cur_pos(r,c)
        set_page_pos(pr,pc)
      else
        set_cur_pos(i+1,1)
      end
    else
      lued.push_jump_stack(g_find_jump_back_stack, cfileid, cr, cc)

      local match_len = string.len(g_find_str2)
      if not g_find_plaintext then
        local match_str = string.match(line,g_find_str2,match_c) or ""
        match_len = string.len(match_str)
      end
      set_cur_pos(i,match_c)
      set_sel_start()
      set_cur_pos(i, match_c+match_len)
      set_sel_end()
      set_cur_pos(i,match_c)
      found = true
      break
    end
  end
  
  if get_page_pos() ~= pr then
    lued.recenter_top(dd2)
  end
  
  lued.disp(dd)
  return found
end


function lued.find_and_replace(from,to,options,dd)
  local dd2 = 1
  local found = false
  local str = nil
  if from~=nil then
    str = from
  end
  if to~=nil then
    g_replace_str = to
  end

  local replace_all = false
  if options=='a' then
    replace_all = true
  end

  local initial_r,initial_c = get_cur_pos()
  local r,c = get_cur_pos()
  local resp = "y"
  repeat

    local test_str = ""
    if g_search_all_files then
      found = lued.search_all_files(str,dd2)
    else
      found = lued.find_forward(str,true,false,true,test_str,dd2)
    end
    str = str or g_find_str
    g_find_str = str
    if found then
      resp = "y"
      if not replace_all then
        lued.disp(0)
        r,c = get_cur_pos()
        find_and_replace_hist_id = find_and_replace_hist_id or lued.get_hist_id()
        resp = lued.prompt(find_and_replace_hist_id,"Replace <y/n/j/a/q/s>?", ",y,n,j,a,q,s,")
        -- Y = yes and goto next
        -- N = no and goto next
        -- J = Jagged. Yes + Fix jagged alignment after replace
        -- A = replace All
        -- Q = quit and return cursor to beginning
        -- S = Stop (Yes, quit and Stop at current position)
        resp = string.lower( string.sub(resp,1,1) )
        resp = string.match(resp,"[ynjaqs]") or "q"
        replace_all = resp=="a"
      end

      if resp=="y" or resp=="j" or resp=="a" or resp=="s" then
        g_replace_str = g_replace_str or ""
        local to = g_replace_str
        local to_is_lower = to == to:lower()
        local to_is_upper = to == to:upper()
        if not to_is_lower and not to_is_upper then
          local sel_str, sel_sr, sel_sc = lued.get_sel_str()
          local from_is_lower = sel_str == sel_str:lower()
          local from_is_upper = sel_str == sel_str:upper()
          if from_is_lower then
            to = to:lower()
          elseif from_is_upper then
            to = to:upper()
          end
        end
        lued.ins_string(to, dd2)
        if resp=="j" then
          lued.insert_tab(dd2)
        end
        if resp=="s" then break end
      elseif resp=="n" then
        lued.move_right_n_char(1,dd2)
      else -- q or invalid response
        break
      end

    end
  until not found
  if resp~="s" then
    set_cur_pos(initial_r,initial_c)
    lued.recenter(dd2)
  end
  lued.disp(dd)
end


function lued.replace_again(dd)
  local dd2 = 1
  lued.find_and_replace(g_find_str,g_replace_str,"",dd)
end


function lued.paste_and_find_forward(dd)
  local dd2 = 1
  lued.global_paste(dd2)
  lued.find_forward_again(dd)
end


function lued.paste_and_find_reverse(dd)
  local dd2 = 1
  lued.global_paste(dd2)
  lued.find_reverse_again(dd)
end


function lued.search_all_files(str,dd)
  local dd2 = 1
  str = str or ""

  local sel_str, sel_sr, sel_sc = lued.get_sel_str()
  if sel_str ~= "" then
    g_find_str = sel_str
    set_sel_off()
  end

  local save_g_tab_prev = g_tab_prev;
  local test_str = ""
  local match = lued.find_forward(str,true,false,false,sel_str,dd2)
  local start_session = get_fileid()
  if not match then
    save_g_tab_prev = start_session
  end
  while not match do
    local session_id = lued.tab_next(dd2)
    if session_id == start_session then break end
    local r,c = get_cur_pos()
    lued.move_to_first_line(dd2)
    lued.move_to_sol_classic(dd2)
    match = lued.find_forward(g_find_str,true,true,false,test_str,dd2)
    if not match then -- restore cur_pos
      set_cur_pos(r,c)
    end
  end
  g_tab_prev = save_g_tab_prev
  g_search_all_files = true
  lued.disp(dd)
  return match
end


function lued.find_forward_again(dd)
  local dd2 = 1
  local initial_r,initial_c = get_cur_pos()
  if g_search_all_files then
    return lued.search_all_files(str,dd)
  end
  local test_str = ""
  local found = lued.find_forward(g_find_str,false,false,false,test_str,dd2)
  if not found then
    set_cur_pos(initial_r,initial_c)
  end
  lued.disp(dd)
  return found
end


function lued.find_word(dd)
  local dd2 = 1
  set_sel_off()
  lued.sel_word(dd2)
  set_sel_end()
  local sel_str = lued.get_sel_str()
  lued.find_forward_selected(dd)
end


function lued.find_reverse_word(dd)
  local dd2 = 1
  set_sel_off()
  lued.sel_word(dd2)
  set_sel_end()
  lued.find_reverse_selected(dd)
end


function lued.find_forward_selected(dd)
  local dd2 = 1
  g_search_all_files = false
  local initial_r,initial_c = get_cur_pos()
  local sel_str, sel_sr, sel_sc = lued.get_sel_str()
  if sel_str~="" then
    lued.move_right_n_char(1,dd2)
    g_find_str = sel_str
    set_sel_off()
  else
    g_find_str = sel_str
  end
  local found = lued.find_forward(g_find_str,false,false,false,sel_str,dd2)
  if not found then
    set_cur_pos(initial_r,initial_c)
  end
  lued.disp(dd)
  return found
end


function lued.find_all_matches_in_file(pat, plain)
  local r, c = get_cur_pos()
  local tmp_g_find_plaintext = g_find_plaintext
  g_find_plaintext = plain or false
  set_cur_pos(1, 1)
  local all_matches = {}
  while true do
--  local found = lued.find_forward(pat, nowrap, search_all, replace, test_str, dd2)
    local found = lued.find_forward(pat, true,   false,      false,   "",       1)
    if not found then break end
    local match_str = lued.get_sel_str(dd2)
    if match_str==nil then break end
    all_matches[#all_matches] = match_str 
  end
  g_find_plaintext = tmp_g_find_plaintext
  set_cur_pos(r, c)
  lued.disp()  io.write(#all_matches,pat) io.read()
  return all_matching_words
end
