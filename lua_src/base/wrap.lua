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



-- Names of chickens, in no particular order, or perhaps a rank order of an underfined metric.
-- the
-- quick
-- brown
-- fox
-- * Vlad the Impaler prowled the outer garden for unsuspecting victims that unwittingly entered into the killing zone.
-- * Sweetie
-- * Comrad
-- * Monk aka Orayoh
-- * Yesterday's Jam
-- If I had a hammer, I'd hammer in the morning. I'd hammer in the evening all over this land 


function lued.set_wrap_col(dd)
  local prompt = "Wrap at column"
  lued.set_wrap_prompt_id = lued.set_wrap_prompt_id or lued.get_hist_id()
  lued.wrap_col = lued.set_number(lued.set_wrap_prompt_id,prompt,lued.wrap_col)
  if lued.wrap_col<1 then lued.wrap_col = nil end
  lued.disp(dd)
end


function lued.join_lines(delim,dd)
  delim = delim or " "
  local dd2 = 1
  if lued.is_lastline() then lued.disp(dd) return end


  local is_blankline = lued.is_blankline()
  local is_blankcomment, current_line = lued.is_blankcomment()
  local first_char = string.sub(current_line, 1, 1) or " "
  local dont_merge = string.find(" *+-", first_char, 1, true)
  
  local next_is_blankline = lued.next_is_blankline()
  local next_is_blankcomment, next_line = lued.next_is_blankcomment()
  local next_first_char = string.sub(next_line, 1, 1) or " "
  local dont_merge_next = string.find(" *+-", next_first_char, 1, true)
--   lued.disp() io.read()
  if next_is_blankline or next_is_blankcomment then
    if lued.next_is_lastline() then lued.disp(dd) return end
    lued.move_down_n_lines(2,dd2)
    lued.disp(dd)
    return
  elseif dont_merge or dont_merge_next then
    lued.move_down(dd2)
    lued.disp(dd)
    return
  end
  local is_comment = lued.is_comment()
  local next_is_comment = lued.next_is_comment()
  local r,c = get_cur_pos()
  if not lued.is_eol() then
    lued.move_to_eol(dd2)
  end
  if lued.is_space() then
    lued.del_sow(dd2) -- delete spaces
  end
  
  if is_comment and next_is_comment then
    lued.move_down(dd2)
    lued.uncomment(dd2)
    lued.move_up_n_lines(1,dd2)
    lued.move_to_eol(dd2)
  end
  
  lued.del_char(1,dd2) -- delete '\n'
  if lued.is_space() then
    lued.del_eow(dd2) -- delete spaces
  end
  ins_str(delim,dd2);
  set_cur_pos(r,c)
  lued.disp(dd)
end


function lued.wrap_line(dd)
  local wrap_col = lued.wrap_col or 80
  local wrap_delim =  " "
  local dd2 = 1

  local line_len = get_line_len()


  if get_line_len() <= wrap_col then
    lued.join_lines(wrap_delim,dd2)
  end
  if get_line_len() <= wrap_col then lued.disp(dd) return end
  
  local is_comment = lued.is_comment()
  lued.move_to_eol(dd2)
  local r,c = get_cur_pos()
  while c > wrap_col do
    lued.move_left_n_words(1,dd2)
    r,c = get_cur_pos()
  end
  if c > 1 then
    lued.ins_string("\n",dd2)
    lued.move_to_sol_classic(dd2)
    if lued.is_space() then
      lued.del_spaces(dd2)
    end
    if is_comment then
      local r,c = get_cur_pos()
      lued.comment(dd2)
      set_cur_pos(r,c)
    end
    
  else
    lued.move_down(dd2)
  end
  lued.disp(dd)
end









