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


function lued.def_snippet(snippets, key_str, fn)
  local keys = lued.explode(key_str, " ")
  for i=1,#keys do
    local key = keys[i]
    snippets[key] = fn
  end
end


function lued.is_snippet(haystack, plain_text)
  haystack = " " .. haystack .. " "
  plain_text = " " .. plain_text .. " "
--   lued.dbg_prompt("haystack=") -- ..haystack.."++plain_text="..plain_text.."++")
  return string.find( haystack , plain_text , 1 , plain)
end


function lued.handle_snippets()
  local filetype = lued.get_filetype()
  if not lued.snippets[filetype] then return false end
  
  local dd2 = 1
  local r,c=get_cur_pos()
  lued.sel_left_pattern( "[%w_.#*()^+*:!]"  , dd2)
  local sel_str, sel_sr, sel_sc = lued.get_sel_str()
  if sel_str==nil or sel_str=='' then return false end
  if not lued.snippets[filetype][sel_str] then
    set_sel_off()
    set_cur_pos(r,c)
    return false
  end
    
  lued.del_sel(dd2)
  set_cur_pos(sel_sr,sel_sc)
  local cnt = 0
  local tok, ii = lued.get_token(sel_str, 1)
  repeat
    local snippet_routine = lued.snippets[filetype][sel_str]
    if snippet_routine then
      g_dont_display = 1
      snippet_routine(tok)
      g_dont_display = 0
    end
    tok, ii = lued.get_token(sel_str,ii)
    cnt = cnt + 1
  until tok == "" or cnt == 5  
  
  -- lued.disp(dd)
  return true
end






