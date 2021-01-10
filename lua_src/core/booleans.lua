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


function lued.is_sol()
  local r,c = get_cur_pos()
  return c <= 1
end


function lued.at_start_of_line()
  local r,c = get_cur_pos()
  if c <= 1 then return true end
  local line = lued.get_line()
  local leading_str = string.sub(line,1,c)
  if string.match(leading_str, "^%s*$") then 
    return true
  end
  return false
end


function lued.is_eol()
  local r,c = get_cur_pos()
  return c > get_line_len()
end


function lued.is_sof()
  local r,c = get_cur_pos()
  return c <= 1 and r <= 1
end

-- Two modes are supported. When line string is passed in the char at `pos` is
-- checked. When line is nil then the char under the cursor is checked.
function lued.is_space(line,pos)
  local is
  if line and line ~= "" then
    is = string.match(line,"^%s",pos) and true or false
  else
    local offset = pos
    local ch = lued.get_char(offset)
    -- lued.dbg_prompt ("is_space="..ch.."xxx")
    is = string.match(ch,"^%s",1) and true or false
  end
  return is
end


function lued.is_punct(line,pos)
  pos = pos or 1
  local ch = line and string.sub(line,pos,pos) or lued.get_char()
  return string.match(ch,"^%p",pos) and true or false
end


function lued.is_word(line,pos)
  if not line and lued.is_eol() then return false end
  local is;
  if line then
    is = string.match(line,"[%w_]",pos) and true or false
  else
    is = string.match(lued.get_char(),"^[%w_]",1) and true or false
  end
  return is
end


function lued.is_pattern(pattern, line,pos)
  local is;
  if line then
    is = string.match(line, "^"..pattern, pos) and true or false
  else
    is = string.match(lued.get_char(), "^"..pattern, 1) and true or false
  end
  return is
end


-- not word and not space
function lued.is_other(line,pos)
  local is = not (lued.is_word() or lued.is_space())
  return is;
end


function lued.prev_is_space()
  local dd2 = 1
  if lued.is_sol() then return false; end
  lued.move_left_n_char(1,dd2)
  local is = lued.is_space()
  lued.move_right_n_char(1,dd2)
  return is;
end


function lued.next_is_space()
  local dd2 = 1
  if lued.is_eol() then return false; end
  lued.move_right_n_char(1,dd2)
  local is = lued.is_space()
  lued.move_left_n_char(1,dd2)
  return is;
end


function lued.prev_is_word()
  local dd2 = 1
  if lued.is_sol() then return false; end
  lued.move_left_n_char(1,dd2)
  local is = lued.is_word()
  lued.move_right_n_char(1,dd2)
  return is;
end


function lued.next_is_word()
  local dd2 = 1
  if lued.is_eol() then return false; end
  lued.move_right_n_char(1,dd2)
  local is = lued.is_word()
  lued.move_left_n_char(1,dd2)
  return is;
end



function lued.prev_is_other()
  local dd2 = 1
  if lued.is_sol() then return false; end
  lued.move_left_n_char(1,dd2)
  local is = lued.is_other()
  lued.move_right_n_char(1,dd2)
  return is;
end

function lued.next_is_other()
  local dd2 = 1
  if lued.is_eol() then return false; end
  lued.move_right_n_char(1,dd2)
  local is = lued.is_other()
  lued.move_left_n_char(1,dd2)
  return is;
end


function lued.is_sow()
  local r,c = get_cur_pos()
  local line = get_line()
  local prev_boundary = (c==1) or lued.is_space(line,c-1)
  local is = prev_boundary and not lued.is_space(line,c)
  return is
end


function lued.is_firstline()
  local r,c = get_cur_pos()
  return r <= 1
end


function lued.is_lastline()
  local r,c = get_cur_pos()
  local num_lines = get_numlines()
  return r >= num_lines
end


function lued.next_is_lastline()
  if lued.is_lastline() then return true end
  local r,c = get_cur_pos()
  local dd2 = 1
  lued.move_down(dd2)
  local is_last = lued.is_lastline()
  set_cur_pos(r,c)
  return is_last
end


function lued.is_eof()
  return lued.is_lastline() and lued.is_eol()
end


function lued.is_blankline(line)
  line = line or get_line()
  local found = string.find(line,"^%s*$")
  local is = found~=nil
  return is
end


function lued.next_is_blankline()
  local dd2 = 1
  if lued.is_lastline() then return true end
  local r,c = get_cur_pos()
  lued.move_down(dd2)
  local is_blank = lued.is_blankline()
  set_cur_pos(r,c)
  return is_blank
end


function lued.is_glob(filename)
  filename = filename or     ""
  local contains_wildcard = filename:match("[*]")
  if filename:match("[*]") then
    return true
  end
  return false
end


function lued.is_dir(filename)
  filename = filename or ""
  if filename == "" then
    return false
  end
  if lued.is_glob(filename) then
    return false
  end
  local file_type = lued.os_cmd("stat -c%F " .. filename) or ""
  if file_type:match("directory") then
    return true
  end
  return false
end


function lued.file_exists(filename)
   local handle=io.open(filename,"r")
   local exists = handle~=nil
   if exists then
     io.close(handle)
   end
   return exists
end


function lued.is_empty(str)
  return str==nil or str==""
end


function lued.is_open(filename)
  local dd2 = 1
  filename = filename or ""
  if lued.is_empty(filename) then
    return nil
  end
  local id = get_fileid()
  local found = false
  for i=1,get_numsessions() do
    set_fileid(i)
    found = filename == get_filename(i)
    if found then
      set_fileid(id,dd2)
      return i
    end
  end
  set_fileid(id,dd2)
  return nil
end


function lued.is_number(str)
  return (tonumber(str) ~= nil)
end


function lued.is_digit(ch)
  ch = ch or lued.get_char()
  return ( string.match(ch, "%d") )
end





