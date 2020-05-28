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



function lued.esc_clear_screen()
  local ESC = string.char(27)
  local ESC_CLR_ALL  = ESC .. "[2J"
  local ESC_GO_HOME  = ESC .. "[H"
  io.write(ESC_CLR_ALL .. ESC_GO_HOME)
end


function lued.esc_rev(str)
  local ESC = string.char(27)
  local ESC_REVERSE  = ESC .. "[7m"
  local ESC_NORMAL   = ESC .. "[0m"
  return ESC_REVERSE .. str .. ESC_NORMAL
end



function lued.display_status_in_lua()
  lued.esc_clear_screen()
end


-- @description replace plain text string. Similar to string.gsub, except with
-- plain text.
-- @param subject is the string to modify
-- @param from is the plain text string to find
-- @param to is the plain text replacement string
-- @param index is the starting offset. default to 1
-- @param lim is the max number of substitutions. nil is no limit.
-- @return result count start stop
-- @return result is modified string
-- @return count is the number of replacements performed
-- @return start is the first offset modied
-- @return stop is the last offset modified in the new string
function lued.psub(subject, from, to, index, lim)
  lim = lim or 0
  index = index or 1
  if not subject or not from or from=="" or not to or to=="" then
    return subject
  end
  subject_len = string.len(subject)
  from_len = string.len(from)
  local to_len = string.len(to)
--   if true then return subject  end
  local plain = true
  local count = 0
  local start
  local stop
  local offset = 1
  local result = subject
  local lim_reached = false
  repeat
    local pos = string.find( result, from, offset, plain)
    if not pos then break end
    offset = pos + to_len
    local front_exists = pos>1
    local front = front_exists and string.sub(result, 1, pos-1) or ''
    local back_start = pos+from_len
    local back_exists = back_start <= string.len(result)
    local back = back_exists and string.sub(result , back_start) or ''
    result = front .. to .. back
    count = count + 1
    start = start or pos
    stop = pos + to_len - 1
  until count==lim
  return result, count, start, stop
end


function lued.display_page_in_lua1(lua_mode, highlight_trailing_spaces)
  lued.display_status_in_lua(lua_mode)
  local prow,pcol = get_page_pos() -- FIXME -1 to adjust from c to lua
  local crow,ccol = get_cur_pos()
  local row_offset = crow - prow + 1
  local text = get_page(prow-1,highlight_trailing_spaces)
  local lines = lued.style_page( lued.explode(text) , prow, row_offset)
  text = lued.implode(lines)

  -- text = lued.insert_line_numbers_orig(text)
  -- text = string.char(27) .. "[1m" .. text;

  io.write (text)

end




function lued.display_page_in_lua(lua_mode, highlight_trailing_spaces)


  lued.display_status_in_lua(lua_mode)
  local prow,pcol = get_page_pos() -- FIXME -1 to adjust from c to lua
  local crow,ccol = get_cur_pos()
  local row_offset = crow - prow + 1
  local text = get_lines(prow,1,prow+20,0)
  local lines = lued.style_page( lued.explode(text) , prow, row_offset)
  text = lued.implode(lines)

  -- text = lued.insert_line_numbers_orig(text)
  -- text = string.char(27) .. "[1m" .. text;

  io.write (text)
end


function lued.disp(dd,center)
   dd = dd or g_dont_display
   center = center or false

   local dd2 = 1
   local r,c = get_cur_pos()
   local pr,pc = get_page_pos()

   if g_enable_file_changed then

     local id = get_fileid()
     local filename = get_filename(id)
     local file_has_changed = false
     local mtime, ts
     if lued.file_exists(filename) then
       file_has_changed,mtime,ts = is_file_modified(0)
     end

     if file_has_changed==1 then
       io.write("\n\n=======================================\n\n")
       local prompt = "File '" .. filename .. "' has changed. Do you want to reload <y/n>?"
       local reload = lued.get_yesno(prompt)=="Y"
       if reload then
         reopen()
       else
         g_enable_file_changed = false -- stop telling me the file has changed. I don't care
       end
     end
   end
   local tr,tc = get_termsize()
   local page_offset_changed = false
   local half = math.floor(tr / 2)

   -- if center then lued.dbg_prompt("CENTER") end

   if (r-pr) < g_min_lines_from_top then
     local new_offset = g_min_lines_from_top
     if center then
       new_offset = half
       lued.dbg_prompt("new_offset1="..new_offset)
     end
     lued.set_page_offset_percent(new_offset,dd2)
   end
   if (pr+tr-r < g_min_lines_from_bot) then
     local new_offset = -g_min_lines_from_bot
     if center then
       new_offset = half
     end
     if center then lued.dbg_prompt("new_offset2="..new_offset) end
     lued.set_page_offset_percent(new_offset,dd2)
   end

   if center then
     local new_offset = half
     lued.set_page_offset_percent(new_offset,dd2)
   end

   if dd == 0 then
     g_command_count = g_command_count or 0
     g_command_count = g_command_count + 1

     g_prev_pos = g_cur_pos or nil;
     g_cur_pos = get_cur_pos();

     if g_lua_mode == nil then return end
     local lua_mode = 0
     if g_lua_mode then
       lua_mode = 1
     end
     lued.display_page_in_lua1(lua_mode,g_show_trailing_spaces)

     lued.push_keystroke( get_last_cmd() )
  
     -- display_status(lua_mode)
     -- display_text(lua_mode,g_show_trailing_spaces)
   end
end

