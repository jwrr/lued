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


function walter()
  local r,c = get_cur_pos()
  for i=1,10 do
    for j=1,70 do
      ins_str(".",1)
    end
    ins_str("\n",1)
  end

  set_cur_pos(r,c)
  for i = 0,9 do
    set_cur_pos(r+i,2)
    del_char(1,1)
    ins_str(" ",1)
  end
  disp()
end


-- str = w('* ,+-20,=20,()8\n',20)
-- str="* ,.60,\n"
function walter2(str,n)
  n = n or 1
  local result = ""
  for word in string.gmatch(str, '([^,]+)') do
    if not string.find(str,'%d$') then
      str = str .. '1'
    end
--    local letter = string.match(word,'^(%D+)')
--    local rep = string.match(word,'(%d+)$')
    local letter = string.match(word,'(%D+)')
    local null,rrr = string.match(word,'(%D+)(%d+)')
    if rrr==nil then rrr = 1 end
    -- print ("999999",str,word,letter,rrr,"00000")
    local letters = string.rep(letter,rrr)
    result = result .. letters
  end
  local final_result = ""
  for i=1,n do
    final_result = final_result .. result
  end
  ins_str(final_result)
end

function hi()
  w('****,*10,**,*10,**,*10,\n',1)
  w('**  ,*10,  ,*10,  ,*10,\n',4)
  w('**  , 10,  ,*10,  ,*10,\n',1)
  w('**  ,*10,  ,*10,  ,*10,\n',4)
  w('****,*10,**,*10,**,*10,\n',1)
end

--function lock_page(dd)
--  local r,c = get_cur_pos()
--  set_page_lock(r)
--end
--
--
--function unlock_page(dd)
--  set_page_lock(0)
--end

function fill_screen(ch,r,c)
  ch = ch or "*"
  local tr,tc = get_termsize()
  r = r or tr
  c = c or tc - 1
  local str = string.rep(ch,c) .. "\n"
  str = string.rep(str,r)
  sol_classic(dd2)
  ins_str(str)
end

function dig_up(n,dd)
  n = n or 1
  local dd2 = 1
  for i=1,n do
    line_up(1,dd2)
    char_left(2,dd2)
    ins_str("  ",dd2)
  end
  disp(dd)
end

function dig_down(n,dd)
  n = n or 1
  local dd2 = 1
  for i=1,n do
    line_down(1,dd2)
    char_left(2,dd2)
    ins_str("  ",dd2)
  end
  disp(dd)
end

function dig_right(n,dd)
  n = n or 1
  local dd2 = 1
  for i=1,n do
    ins_str(" ",dd2)
  end
  disp(dd)
end

function dig_left(n,dd)
  n = n or 1
  local dd2 = 1
  for i=1,n do
    char_left(3,dd2)
    ins_str(" ",dd2)
    char_right(1,dd2)
  end
  disp(dd)
end

function start_aa(dd)
local dd2 = 1
aa_save_alt_e = alt_e
aa_save_alt_s = alt_s
aa_save_alt_d = alt_d
aa_save_alt_f = alt_f
aa_save_overtype = get_overtype()
alt_e = dig_up
alt_s = dig_left
alt_d = dig_down
alt_f = dig_right
set_overtype(1,dd2)
disp(dd)
end

function stop_aa()
local dd2 = 1
alt_e = aa_save_alt_e
alt_s = aa_save_alt_s
alt_d = aa_save_alt_d
alt_f = aa_save_alt_f
set_overtype(aa_save_overtype,dd2)
disp(dd)
end

alt_Start_aa = start_aa
alt_Stop_aa  = stop_aa
alt_FS = fill_screen

