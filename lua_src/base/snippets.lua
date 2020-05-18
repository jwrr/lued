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


function lued.handle_snippets(dd)
  local dd2 = false
  local r,c=get_cur_pos()
  lued.sel_left_pattern( "[%w.#*()^>+*:]"  , dd2)
--   lued.sel_sow(dd2)
  local sel_str, sel_sr, sel_sc = lued.get_sel_str()
  if sel_str==nil or sel_str=='' then
    return false
  end
  
  local filetype = 'html'
  
  s1 = snips and "snips exists," or "snips NOT"
  s2 = snips[filetype] and "html exists" or "html NOT"
  --s3 = snips[filetype]['exec']  and "exec exists" or "exec NOT"
  
  local snip_routine = snips[filetype].main
  if snip_routine == nil then
    set_sel_off()
    set_cur_pos(r,c)
    return false
  end
  lued.del_sel(dd2)
  set_cur_pos(sel_sr,sel_sc)
  g_dont_display = 1
  
  local tok = ""
  local ii = 1
  local cnt = 1
  repeat
    tok, ii = lued.get_token(sel_str,ii)
    snip_routine(tok)
    tok, ii = lued.get_token(sel_str,ii)
    cnt = cnt + 1
  until tok == "" or cnt == 5
  
  g_dont_display = 0
  
  lued.disp(dd)
  return true
end


lued.is_snippet = function(haystack, plain_text)
  return string.find(" "..haystack.." ", " "..plain_text.." ", 1, plain)
end




