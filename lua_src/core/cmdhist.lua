-- cmdhist.lua


function lued.same_cmd()
  if lued.cmd_hist == nil or #lued.cmd_hist==0 then return false end
  local cmd_str = get_last_cmd()
  if cmd_str == lued.cmd_hist[#lued.cmd_hist] then return true end
  return false
end


function lued.push_cmd(cmd)
  if g_cmdhist_dont_push or g_in_run_strig then
    return
  end
  local cmd_str = get_last_cmd() or ""
  if cmd_str ~= "" then
    if lued.cmd_hist == nil then
      lued.cmd_hist = {}
    end
    lued.cmd_hist[#lued.cmd_hist+1] = cmd_str
  end
end


function lued.list_n_cmd(prompt)
  local page_size = math.floor(lued.get_pagesize()) or -1
  local cmd_hist_len = #lued.cmd_hist or -1
  if page_size < 1 or cmd_hist_len < 1 then return 0 end
  local num_cmd_to_disp = math.min(page_size, cmd_hist_len)
  local first_cmd_to_disp = cmd_hist_len - num_cmd_to_disp + 1
  local reverse_order_number = num_cmd_to_disp
  for i=first_cmd_to_disp,cmd_hist_len do
    print(reverse_order_number .. ". " .. lued.cmd_hist[i])
    reverse_order_number = reverse_order_number - 1
  end

  g_cmdhist_id = g_cmdhist_hist_id or lued.get_hist_id()
  local p = prompt or "Command History (Press <Enter> to continue...)"
  local user_response = lued.prompt(g_cmdhist_id, p)
  if user_response=="" then
    return g_cmdhist_repcnt
  end
  return tonumber(user_response)
end


function lued.run_string(str,dd)
  local func, err = load(str)
  if func then
    g_in_run_string = true
    local ok = pcall(func)
    g_in_run_string = false
  else
    print("Compilation error:", err)
  end
end


function lued.repeat_n_cmd(again,dd)
  local dd2 = 1
  if g_cmdhist_repcnt==nil or g_cmdhist_repcnt<1 then
    g_cmdhist_repcnt = 1
  end
  if not again and not lued.same_cmd() then
    local prompt = "Repeat N last Commands (Default="..g_cmdhist_repcnt.."): "
    g_cmdhist_repcnt = lued.list_n_cmd(prompt)
    g_cmdhist_last  = #lued.cmd_hist
  end
    
  if g_cmdhist_repcnt>0 then
    local l  = g_cmdhist_last
    local f = l - g_cmdhist_repcnt + 1
--     print('abc=',f, l, g_cmdhist_repcnt) ; str = io_read()
    for i=f,l do
      cmd = lued.cmd_hist[i]
      if not string.find(cmd, '(', 1, true) then
        cmd = cmd .. '()'
      end
      lued.run_string(cmd,dd2)
    end
  else
    g_cmdhist_dont_push = true -- hide replace command
    lued.disp(dd)
    g_cmdhist_dont_push = false
  end
end

function lued.repeat_again(dd)
  lued.repeat_n_cmd(true,dd)
end



