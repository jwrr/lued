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

-- ctag global tables
g_ctag_file = {}
g_ctag_address = {}


function lued.split_string (str, delimiter)
  delimiter = delimiter or "%s"
  local t={}
  for field in string.gmatch(str, "([^"..delimiter.."]+)") do
    table.insert(t, field)
  end
  return t
end


-- Read the tags file
function lued.ctag_read_file(tagfile, dd)
  tagfile = tagfile or "tags"  -- if nil then default to "tags"
  g_ctag_file = {}     -- clear hash table of filenames
  g_ctag_address = {}  -- clear hash table of line numbers (or search strings)
  local ctag_file = io.open("tags", "r");
  if ctag_file == nil then return; end
  for line in ctag_file:lines() do
    line = line:gsub(';"\t.*','') -- Remove comment
    local fields = lued.split_string(line, '\t')
    local name = fields[1] or ""
    g_ctag_file[name] = fields[2] or ""
    g_ctag_address[name] = fields[3] or ""
  end
  lued.disp(dd)
end


-- Jump to the definition of the symbol under the cursor
function lued.ctag_move_to_tag(dd)
  local dd2=1
  if is_sel_off()==1 then
    lued.sel_word(dd2)
    set_sel_end()
  end
  local sel_str, sel_sr, sel_sc = lued.get_sel_str()

  local ctag_file = g_ctag_file[sel_str]
  if ctag_file == nil then
    io.write(" - CTAG '" .. sel_str .. "' does not exist\n")
    return
  end
  local address = g_ctag_address[sel_str] or 1

  -- save current position in jump stack
  g_ctag_r, g_ctag_c = get_cur_pos()
  g_ctag_id = get_fileid()
  lued.push_jump_stack(g_find_jump_back_stack, g_ctag_id, g_ctag_r, g_ctag_c)
  lued.push_jump_stack(g_ctag_jump_back_stack, g_ctag_id, g_ctag_r, g_ctag_c)
  
  lued.open_file(ctag_file, dd2)
  lued.move_to_first_line(dd2)
  if lued.is_number(address) then
    lued.move_to_line(tonumber(address), dd2)
  else
    address = address:sub(3,-3) -- remove '/^' and '$/'
--     dbg_prompt("ctag_file="..ctag_file.." address="..address)
     local found = lued.find_forward(address,true,false,false,address,dd2)
     lued.move_to_sol(dd2)
     
     lued.find_forward(sel_str,true,false,false,sel_str,dd2)
  end
  lued.disp(dd)
end


-- Return back to the original file location
function lued.ctag_move_back_from_tag(dd)
  if g_ctag_r==nil then
    lued.disp(dd)
    return
  end
  local dd2 = 1
  lued.session_sel(g_ctag_id,dd2)
  set_cur_pos(g_ctag_r, g_ctag_c)
  g_ctag_r = nil
  lued.disp(dd)
end


g_ctag_jump_back_stack = {}
g_ctag_jump_forward_stack = {}
function lued.ctag_jump_back(dd)
  lued.jump_back(g_ctag_jump_back_stack, g_ctag_jump_forward_stack, dd)
end


function lued.ctag_jump_forward(dd)
  lued.jump_forward(g_ctag_jump_back_stack, g_ctag_jump_forward_stack, dd)
end


-- ctag key bindings
-- alt_cb = ctag_move_back_from_tag; hot("cb") -- ctag back
-- alt_ct = ctag_move_to_tag;        hot("ct") -- ctag jump. Similar Sublime Ctrl+R
-- alt_cr = ctag_read_file;          hot("cr") -- ctag read

-- Read the ctag file
-- You can re-read the ctags file using Alt+cr 
lued.ctag_read_file(dd2)

