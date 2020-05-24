-- cmdhist.lua


function lued.same_cmd()
  if lued.cmd_hist == nil or #lued.cmd_hist==0 then return false end
  local cmd_str = get_last_cmd()
  if cmd_str == lued.cmd_hist[#lued.cmd_hist] then return true end
  return false
end


function lued.push_cmd(cmd)
  local cmd_str = get_last_cmd() or ""
  if cmd_str ~= "" then
    if lued.cmd_hist == nil then
      lued.cmd_hist = {}
    end
    lued.cmd_hist[#lued.cmd_hist+1] = cmd_str -- FIXME
  end
end


function lued.list_n_cmd(n,prompt,dd)
  local user_response = nil
  if n == nil then
    local page_size = lued.get_pagesize() or -1
    local cmd_hist_len = #lued.cmd_hist or -1
    if page_size == -1 or cmd_hist_len == -1 then lued.disp(dd) return end
    local num_cmd_to_disp = math.min(page_size, cmd_hist_len)
    local first_cmd_to_disp = cmd_hist_len - num_cmd_to_disp + 1
    local reverse_order_number = num_cmd_to_disp
    print(num_cmd_to_disp,first_cmd_to_disp,reverse_order_number,cmd_hist_len)
    for i=first_cmd_to_disp,cmd_hist_len do
      print(reverse_order_number .. ". " .. lued.cmd_hist[i])
      reverse_order_number = reverse_order_number - 1
    end

    g_cmdhist_id = g_cmdhist_hist_id or lued.get_hist_id()
    g_cmdhist_default = g_cmdhist_default or 1
    local p = prompt or "Command History (Press <Enter> to continue...)"
    user_response = lued.prompt(g_cmdhist_id, p)

  end
  lued.disp(dd)
  return user_response
end


function lued.run_string(str,dd)
  local func, err = load(str)
  if func then
    local ok = pcall(func)
  else
    print("Compilation error:", err)
  end
end


function lued.repeat_n_cmd(n,dd)
  local dd2 = 1
  g_cmdhist_default = g_cmdhist_default or 1
  local prompt = "Repeat N last Commands (Default="..g_cmdhist_default.."): "
  local rep_cnt = lued.list_n_cmd(n, prompt, dd2)
  if rep_cnt then
    local last  = #lued.cmd_hist
    local first = last - rep_cnt + 1
    for i=first,last do
      cmd = lued.cmd_hist[i]
      if not string.find(cmd, '(', 1, true) then
        cmd = cmd .. '()'
      end
      lued.run_string(cmd,dd2)
    end
  end
 -- disp(dd)
end




