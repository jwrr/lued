-- replay.lua

lued.replay = lued.replay or {}
lued.replay.names = lued.replay.names or {}
lued.replay.keystroke_hist = lued.replay.keystroke_hist or {}
lued.replay.inhibit_push = false
lued.replay.in_exec_str = false


function lued.same_keystroke()
  if #lued.replay.keystroke_hist==0 then return false end
  local cmd_str = get_last_cmd()
  if cmd_str == lued.replay.keystroke_hist[#lued.replay.keystroke_hist] then return true end
  return false
end


function lued.push_keystroke(cmd)
  if lued.replay.inhibit_push or lued.replay.in_exec_str then
    return
  end
  local cmd_str = get_last_cmd() or ""
  if cmd_str ~= "" then
    if lued.replay.keystroke_hist == nil then
      lued.replay.keystroke_hist = {}
    end
    lued.replay.keystroke_hist[#lued.replay.keystroke_hist+1] = cmd_str
  end
end


function lued.show_keystroke_hist(prompt)
  local page_size = math.floor(lued.get_pagesize()) or -1
  local keystroke_hist_len = #lued.replay.keystroke_hist or -1
  if page_size < 1 or keystroke_hist_len < 1 then return 0 end
  local num_keystroke_to_disp = math.min(page_size, keystroke_hist_len)
  local first_keystroke_to_disp = keystroke_hist_len - num_keystroke_to_disp + 1
  local reverse_order_number = num_keystroke_to_disp
  for i=first_keystroke_to_disp,keystroke_hist_len do
    print(reverse_order_number .. ". " .. lued.replay.keystroke_hist[i])
    reverse_order_number = reverse_order_number - 1
  end

  local p = prompt or "Command History (Press <Enter> to continue...)"
  lued.replay.prompt_id_keystrokes = lued.replay.prompt_id_keystrokes or lued.get_hist_id() 
  
  local user_response = lued.prompt(lued.replay.prompt_id_keystrokes, p)
  if user_response=="" then
    return lued.replay.num_keystrokes
  end
  return tonumber(user_response)
end


function lued.exec_str(str,dd)
  local func, err = load(str)
  if func then
    lued.replay.in_exec_str = true
    local ok = pcall(func)
    lued.replay.in_exec_str = false
  else
    print("Compilation error:", err)
  end
end


function lued.replay_keystrokes(again,dd)
  local dd2 = 1
  if lued.replay.num_keystrokes==nil or lued.replay.num_keystrokes<1 then
    lued.replay.num_keystrokes = 1
  end
  if not again and not lued.same_keystroke() then
    local prompt = "replay N last Commands (Default="..lued.replay.num_keystrokes.."): "
    lued.replay.num_keystrokes = lued.show_keystroke_hist(prompt)
    lued.replay.most_recent_keystroke  = #lued.replay.keystroke_hist
    lued.replay.prompt_id_name = lued.replay.prompt_id_name or lued.get_hist_id()
    
    local name = lued.prompt(lued.replay.prompt_id_name, "Enter name (Optional): ")
    if name ~= "" then
      lued.replay.names[#lued.replay.names+1] = {
        name=name,
        most_recent=lued.replay.most_recent_keystroke,
        num_keystrokes=lued.replay.num_keystrokes
      }
    end
  end
    
  if lued.replay.num_keystrokes > 0 then
    local l  = lued.replay.most_recent_keystroke
    local f = l - lued.replay.num_keystrokes + 1
--     print('abc=',f, l, lued.replay.num_keystrokes) ; str = io_read()
    for i=f,l do
      cmd = lued.replay.keystroke_hist[i]
      if not string.find(cmd, '(', 1, true) then
        cmd = cmd .. '()'
      end
      lued.exec_str(cmd,dd2)
    end
  else
    lued.replay.inhibit_push = true -- hide replace command
    lued.disp(dd)
    lued.replay.inhibit_push = false
  end
end


function lued.replay_again(dd)
  lued.replay_keystrokes(true,dd)
end


function lued.show_list(list,id,prompt)
  if list==nil or id==nil then return end
  local page_size = math.floor(lued.get_pagesize())
  if page_size < 1 or #list < 1 then return end
  local num_to_disp = math.min(page_size, #list)
  local most_recent_entry  = #list
  local first_entry = #list - num_to_disp + 1
--   local reverse_order_number = num_to_disp
  print("")
  for i=first_entry,most_recent_entry do
    print(i .. ". " .. list[i].name)
--     print(reverse_order_number .. ". " .. list[i])
--     reverse_order_number = reverse_order_number - 1
  end

  local p = prompt or "Press <Enter> to continue..."
  local user_response_str = lued.prompt(id, p)
  return user_response_str
end


function lued.replay_name(dd)
  if #lued.replay.names == 0 then lued.disp(dd) return end
  local p = "Enter index number of named replay sequence: "
  local sel_str = lued.show_list(lued.replay.names, lued.replay.prompt_id_name, p)
  sel_i = tonumber(sel_str)
  if sel_i==nil or lued.replay.names[sel_i]==nil then lued.disp(dd) return end
  lued.replay.most_recent_keystroke = lued.replay.names[sel_i].most_recent
  lued.replay.num_keystrokes = lued.replay.names[sel_i].num_keystrokes
  lued.replay_keystrokes(true,dd)
end


