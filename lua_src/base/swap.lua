--[[
MIT License

Copyright (c) 2018 JWRR.COM

git clone https://github.com/jwrr/lued.git

Permission is hereby granted, free of charge, to any person obtaining a lued.copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, lued.copy, modify, merge, publish, distribute, sublicense, and/or sell
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


function lued.swap_line_with_prev(dd)
  local dd2 = 1
  lued.cut_line(1,dd2)
  lued.move_up_n_lines(1,dd2)
  lued.paste_line_before(dd)
end


function lued.swap_line_with_next(dd)
  local dd2 = 1
  lued.cut_line(1,dd2)
  lued.move_down_n_lines(1,dd2)
  lued.paste_line_before(dd2)
  lued.move_up_n_lines(2,dd)
end


function lued.bubble_line_up(dd)
  local dd2 = 1
  lued.swap_line_with_prev(dd2)
  lued.move_up_n_lines(1,dd)
end


function lued.bubble_selected_lines_up(dd)
  local dd2 = 1
  if lued.is_sel_on() then
    local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
    if sel_sr > 1 then
      lued.global_cut(dd2)
      lued.move_up_n_lines(1,dd2)
      lued.paste_line_before(dd)
      lued.set_sel_from_to(sel_sr-1, 1, sel_er-1, 1, dd)
    end
    lued.disp(dd)
  else
    lued.bubble_line_up(dd)
  end
end


function lued.bubble_line_down(dd)
  local dd2 = 1
  lued.swap_line_with_next(dd2)
  lued.move_down_n_lines(1,dd)
end


function lued.bubble_selected_lines_down(dd)
  local dd2 = 1
  if lued.is_sel_on() then
    local sel_state, sel_sr, sel_sc, sel_er, sel_ec = get_sel()
    lued.global_cut(dd2)
    lued.move_down_n_lines(1,dd2)
    lued.paste_line_before(dd)
    lued.set_sel_from_to(sel_sr+1, 1, sel_er+1, 1, dd)
    lued.disp(dd)
  else
    lued.bubble_line_down(dd)
  end
end


function lued.bubble_word_right(dd)
  local dd2 = 1
  lued.sel_word(dd2)
  lued.skip_spaces(dd2)
  set_sel_end()
  lued.del_word(1,dd2)
  lued.move_right_n_words(1,dd2)
  lued.paste(dd2)
  lued.move_left_n_words(1,dd2)
  lued.disp(dd)
end


function lued.bubble_word_left(dd)
  local dd2 = 1
  lued.sel_word(dd2)
  lued.skip_spaces(dd2)
  set_sel_end()
  lued.del_word(1,dd2)
  lued.move_left_n_words(1,dd2)
  lued.paste(dd2)
  lued.move_left_n_words(1,dd2)
  lued.disp(dd)
end

