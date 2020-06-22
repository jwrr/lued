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


function lued.get_rc(id)
  local current_id = get_fileid()
  if id==nil or id==current_id then return get_cur_pos() end
  set_fileid(id)
  local r,c = get_cur_pos()
  set_fileid(current_id)
  return r,c
end


function lued.get_filenamerc(id)
  local filename = get_filename(id)
  local r, c = lued.get_rc(id)
  return filename, r, c
end

function lued.get_overtype()
  return g_overtype
end


function lued.set_overtype(val,dd)
  val = val or 0
  g_overtype = val
  lued.disp(dd)
end


function lued.toggle_overtype(dd)
  g_overtype = g_overtype or 0
  g_overtype = (g_overtype+1) % 2
  lued.disp(dd)
end


function lued.toggle_doublespeed(dd)
  g_double_speed = g_double_speed or 0
  g_double_speed = (g_double_speed+1) % 2
  lued.disp(dd)
end


function lued.get_hist_id()
  get_hist_id_cnt = get_hist_id_cnt or 0
  get_hist_id_cnt = get_hist_id_cnt + 1
  return get_hist_id_cnt;
end


function lued.get_yesno(prompt,default)
  local yes = false
  local no = false
  local quit = false
  local all = false
  local valid_answer = false
  local answer = ""
  get_yesno_hist_id = get_yesno_hist_id or lued.get_hist_id()
  repeat
    answer = lued.prompt(get_yesno_hist_id,prompt .. " ")
    if default~=nil and answer==nil or answer=="" then answer = default end
    answer = string.upper(answer)
    yes = answer=="Y"
    no  = answer=="N"
    quit = answer=="Q"
    all = answer=="A"
    valid_answer = yes or no or quit or all
    if not valid_answer then
      io.write("'"..answer.."' is not valid. ")
    end
  until (valid_answer)
  return answer
end


function lued.get_cur_filename()
  local id = get_fileid()
  local filename = get_filename(id)
  return filename
end


function lued.get_pagesize()
  rows, cols = get_termsize()
  if g_page_size==nil or g_page_size==0 then
    return rows
  elseif g_page_size < 1 then
    return math.floor(rows*g_page_size*100 + 0.5) / 100;
  else
    return g_page_size
  end
end


function lued.get_all_matches(needle,haystack)
  local match_list = {}
  needle = "%f[%w]" .. needle
  for word in string.gmatch(haystack, needle) do
    match_list[#match_list+1] = word
  end
  return match_list
end


function lued.get_longest_word(words)
  local longest_word = "";
  for word in words:gmatch("(%S+)") do
    local len = word:len()
    if (len > longest_word:len()) then
      longest_word = word
    end
  end
  return longest_word
end


function lued.get_basename(full_path)
  full_path = full_path or ""
  local basename_str = full_path:match("[^/]+$") or ""
  return basename_str
end


function lued.get_dirname(full_path)
  full_path = full_path or ""
  local dirname_str  = full_path:match("^.*[/]") or ""
--  if dirname_str:len() > 1 then
--    dirname_str  = dirname_str:sub(1,-2) -- remove trailing backslash
--  end
  return dirname_str
end


function lued.set_pagesize(val,dd)
  val = val or 0 -- zero is a special case.
  g_page_size = val
  lued.disp(dd)
end


function lued.set_tab_size(val,dd)
  val = val or 0
  g_tab_size = val
  lued.disp(dd)
end


function lued.toggle_remove_trailing_spaces(dd)
  g_remove_trailing_spaces = not g_remove_trailing_spaces
  lued.disp(dd)
end


function lued.toggle_show_trailing_spaces(dd)
  g_show_trailing_spaces = not g_show_trailing_spaces
  lued.disp(dd)
end


function lued.set_min_lines_from_top(val,dd)
  if val==nil then val = 5 end
  g_min_lines_from_top = val
  lued.disp(dd)
end


function lued.set_min_lines_from_bot(val,dd)
  if val==nil then val = 7 end
  g_min_lines_from_bot = val
  lued.disp(dd)
end


function lued.toggle_enable_file_changed(dd)
  g_enable_file_changed = not g_enable_file_changed
  lued.disp(dd)
end


function lued.toggle_express_mode(dd)
  g_express_mode = not g_express_mode
  lued.disp(dd)
end


function lued.set_edit_mode(dd)
  g_lua_mode = false
  local keys = get_hotkeys()
  keys = "all" .. keys
  set_hotkeys(keys)
  lued.disp(dd)
end


function lued.set_lua_mode(dd)
  g_lua_mode = true
  local keys = get_hotkeys()
  keys = string.gsub(keys,"(all)","")
  print ("KEYS2="..keys)
  set_hotkeys(keys)
  lued.disp(dd)
end


function lued.get_filename()
  local id = get_fileid() or 1
  return get_filename(id) or ""
end


function lued.get_extension(filename)
  filename = filename or lued.get_filename()
  local extension = string.lower( filename:match "[^./]+$" or "" )
  return extension
end


function lued.get_filetype(filename)
  local extension = lued.get_extension(filename)
  local filetype = extension
  if lued.filetypes and lued.filetypes[extension] then
    filetype = lued.filetypes[extension]
  end
  return filetype
end


function lued.get_line_comment(filename)
  local comment_start = g_comment
  local filetype = lued.get_filetype(filename)
  if lued.line_comments and lued.line_comments[filetype] then
    comment_start = lued.line_comments[filetype]
  end
  return comment_start
end


function lued.set_number(prompt_id, prompt, num)
  local default_str = ""
  if lued.wrap_col then
    default_str = " (default='"..tostring(num).."')"
  end
  local prompt = prompt..default_str..": "
  local hot=""
  local test_str=""
  local str = lued.prompt(prompt_id, prompt, hot, test_str)
  if str~=nil then
    local tmp = tonumber(str)
    if tmp~=nil then num = tmp end
  end
  return num
end




  


