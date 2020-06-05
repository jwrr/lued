
-- \brief Make next line's leading whitespace the same as current line's leading whitespace.
function lued.align_start_of_next_line(dd)
  local dd2 = 1
  local ws1,ws1_len = lued.leading_ws()
  lued.move_down(dd2)
  lued.move_to_sol_classic(dd2)
  local ws2,ws2_len = lued.leading_ws()
  lued.del_char(ws2_len,dd2)
  ins_str(ws1,dd2)
  lued.disp(dd)
end


-- \brief Fix jagged left edges by making leading white space of all selected lines the same as first selected line.
function lued.align_selected(dd)
  lued.foreach_selected(lued.align_start_of_next_line, dd)
end


-- \brief Align delimiter of next line with the same delimiter on current line
function lued.align_delimiter_of_next_line(delim, dd)
  g_align_delimiter_of_next_line = g_align_delimiter_of_next_line or "="
  delim = delim or "="
  local dd2 = 1
  local delim_pos1 = string.find( get_line(), g_align_delimiter_of_next_line, 1, true)
  if delim_pos1 then
    lued.move_down(dd2)
    local line = get_line() or ""
    local delim_pos2 = string.find( line, g_align_delimiter_of_next_line, 1, true)
    if delim_pos2 then
      local r,c = get_cur_pos()
      set_cur_pos(r,delim_pos2)
      local delta = delim_pos1 - delim_pos2
      if delta > 0 then
        local ws = string.rep(" ", delta)
        ins_str(ws, dd2)
      elseif delta < 0 then
        delta = -1 * delta
        for i = 1, delta do
          if lued.is_sol() then break end
          lued.move_left_n_char(1,dd2)
          if not lued.is_space() then break end
          lued.del_char(1,dd2)
        end
      end
    end
  end
  lued.disp(dd)
end


-- \brief Align delimiter in selected region
function lued.align_delimiter_selected(delim, dd)
  align_delimiter_selected_hist_id = align_delimiter_selected_hist_id or lued.get_hist_id()
  g_align_delimiter_of_next_line = delim or lued.prompt(align_delimiter_selected_hist_id, "Enter string to align: ") or "="
  lued.foreach_selected(lued.align_delimiter_of_next_line, dd)
end


function lued.align_cur_char(dd)
  local dd2 = 1
  local cur_char = lued.get_char()
  local r1,c1 = get_cur_pos()
  lued.move_down(dd2)
  lued.move_to_sol_classic(dd2)
  found = lued.find_forward(cur_char,true,false,true,"",dd2)
  if not found then
    lued.disp(dd)
    return
  end

  set_sel_off()
  local r2,c2 = get_cur_pos();
  local done = c2 == c1
  local cnt = 0
  while not done do
    if c2 < c1 then
      ins_str(" ",dd2)
    else
      if lued.is_sol() or not lued.is_space("",-1) then
        done = true
      else
        lued.del_backspace(1,dd2)
        if not lued.is_space("",-1) then
          ins_str(" ",dd2)
          done = true
        end
      end
    end
    r2,c2 = get_cur_pos();
    cnt = cnt + 1
    done = done or (c2 == c1) or (cnt > 200)
  end
  lued.disp(dd)
end


