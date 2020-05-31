-- autocomplete.lua

--[[
MIT License
Copyright (c) 2020 JWRR.COM
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


-- called from ins_str
function lued.auto_complete_insert_word()
  local word = lued.get_word()

  -- decrement count of word (because it is being modified to new_word)
  lued.auto_complete.full[word] = lued.auto_complete.full[word] or 1
  lued.auto_complete.full[word] = lued.auto_complete.full[word] - 1 
  if lued.auto_complete.full[word] == 0 then lued.auto_complete.full[word] = nil end

  -- increment count of new word
  local new_word = word .. ins_str
  local new_word = string.gsub(word..ins_str, "%s.*", "")
  lued.auto_complete.full[new_word] = lued.auto_complete.full[new_word] or 0
  lued.auto_complete.full[new_word] = lued.auto_complete.full[new_word] + 1    

  -- add new word to all the partial words
  for ii=1,#new_word do
    local key = string.sub(word, 1, ii)
    lued.auto_complete.partial[key] = lued.auto_complete.partial[key] or " "
    lued.auto_complete.partial[key] =  lued.auto_complete.partial[key] .. new_word .. " "
  end
end

-- called from disp
function lued.auto_complete_lookup_word()
  local matches_str = lued.auto_complete.partial[key]
  if matches_str == nil then return "" end
  local matches_array = lued.explode(matches_str, " ")
  if #matches_array == 0 then return "" end
  local out_array = {}
  local new_matches_str = ""
  for ii=1,#matches_array do
    local word = matches_array[ii]
    if lued.auto_complete.full[word] and lued.auto_complete > 0 then
      out_array[#out_array+1] = word
      new_matches_str = new_matches_str .. " " .. word
    end
  end
  if new_matches_str ~= matches_str then
    lued.auto_complete.partial[key] = new_matches_str
  end
  return out_array
end


function lued.minmax(min, actual, max)
  return math.min(max, math.max(actual,min) )
end


-- called from tab
function lued.auto_complete_select_word()
  local choices = lued.auto_complete_lookup_word()
  if #choices == 1 then
    lued.replace_current_word_with( choices[1], dd)
  elseif #choices > 1 then
    response = prompt()
    index = lued.minmax(1, tointeger(response), #choices)
    --index = math.min(index,#choices)
    --index = math.max(index,1)
    lued.replace_current_word_with( choices[index], dd)
  else
    disp(dd)  
  end
end


