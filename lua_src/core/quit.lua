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


function lued.exit_session(dd)
  save_session()
  close_session()
  lued.disp(dd)
end


function lued.exit_all(dd)
  local dd2 = 1
  while (true) do
     lued.exit_session(dd2)
  end
end


function lued.quit_session(force,dd)
  force = force or false
  local not_saved_yet = is_modified()
  local numsessions = get_numsessions()
  local what_should_i_do = "Y"
  if not force and not_saved_yet==1 and numsessions>0 then
    local id = get_fileid()
    local prompt = "Save '" .. get_filename(id) .. "' <y/n/a for abort (don't quit)>?";
    what_should_i_do = lued.get_yesno(prompt, "A")
    if what_should_i_do=="Y" then
      save_session()
    end
  end
  local abort = what_should_i_do=="A"
  if not abort then
    close_session()
    if (numsessions==1) then
      close_session()
    end
  end
  lued.disp(dd)
  return abort
end


function lued.quit_all(force, dd)
  local dd2 = 1
  if g_save_session_on_quit then
    lued.save_session_file(dd2)
  end
  force = force or false
  local abort = false
  while (not abort) do
     abort = lued.quit_session(force, dd2)
  end
  if abort then
    lued.disp(dd)
  end
end





