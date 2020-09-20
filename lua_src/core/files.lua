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


function lued.toggle_review_mode(dd)
  g_review_mode = g_review_mode or false
  g_review_mode = not g_review_mode
  lued.disp(dd)
end


function lued.save_file(dd)
  if g_review_mode then
    lued.save_as(nil, dd)
  end

  local r,c = get_cur_pos()
  local id = get_fileid()
  local filename = get_filename(id)
  local file_has_changed = false
  local mtime, ts
  if lued.file_exists(filename) then
    file_has_changed,mtime,ts = is_file_modified(1)
   end

  if file_has_changed==1 then
    local id = get_fileid()
    local filename = get_filename(id)
    io.write("\n\n=======================================\n\n")
    local overwrite = lued.get_yesno("File '" .. filename .. "' has changed. Do you want to overwrite <y/n>?")=="Y"
    if overwrite then
      save_session()
    end
  else
    save_session()
  end
  set_cur_pos(r,c)
  lued.disp(dd)
end


function lued.save_as(filename, dd)
  if filename == nil then
    save_as_hist_id = save_as_hist_id or lued.get_hist_id()
    local done = false
    repeat
      filename = lued.prompt(save_as_hist_id,"Save As Filename: ")
      if lued.file_exists(filename) then
        local response = lued.get_yesno
        local prompt = "File '" .. filename .. "' exists. Overwrite <y/n/a for abort (don't save)>?";
        local what_should_i_do = lued.get_yesno(prompt, "N")
        if what_should_i_do == "N" then
          lued.disp(dd)
          done = false
        elseif what_should_i_do == "Y" then
          done = true
        else -- abort
          lued.disp(dd)
          return
        end
      else
        done = true
      end
    until done
  end

  set_filename(filename)
  save_session()
  lued.disp(dd)
end


function lued.save_all(dd)
  local dd2 = 1
  local fileid = get_fileid()
  local numsessions = get_numsessions()
  for i=1,numsessions do
    lued.session_sel(i)
    if is_modified()==1 then
      save_session(dd2)
    end
  end
  lued.session_sel(fileid,dd)
end

function lued.pwd()
  local home = os.getenv("HOME")
  io.write(home)
end


function lued.open_file(filenames,dd)
  print("in open_file") os.read()

  local dd2 = 1
  if filenames==nil then
    filenames = lued.cd_change_dir(dd2)
  end
  if filenames==nil then
    open_file_hist_id = open_file_hist_id or lued.get_hist_id()
    filenames = lued.prompt(open_file_hist_id, "Enter Filename: ")
    local home = os.getenv("HOME")
    filenames = string.gsub(filenames,"^~",home)
    local env_name = string.match(filenames,"%${?([%w_]+)}?")
    while env_name ~= nil do
      local env_value = os.getenv(env_name)
      filenames = string.gsub(filenames, "%${?" .. env_name .. "}?", env_value)
      env_name = string.match(filenames,"%${?([%w_]+)}?")
    end
  end

  local filename_list,count = filenames:gmatch("(%S+)")

  for filename1 in filename_list do
    local existing_fileid = lued.is_open(filename1)
    if existing_fileid then
       g_tab_prev = get_fileid()
      set_fileid(existing_fileid,dd2)
    elseif filename1~=nil and filename1~="" and lued.file_exists(filename1) and not lued.is_dir(filename1)  then
      local prev = get_fileid()
      local fileid = lued_open(filename1)
      if fileid~=nil and fileid~=0 then
        g_tab_prev = prev
        set_fileid(fileid)
        lued.move_to_first_line(dd2)
      end
    end
  end
  lued.disp(dd)
end


function lued.open_filerc(filename, r, c)
  lued.open_file(filename)
  lued.set_cur_pos(r,c)
  lued.disp()
end

function lued.open_filerc_test(dd)
  lued.open_filerc('bin2gray.vhd', 1, 1)
  lued.disp(dd)
end

function lued.open_partial_filename(dd)
  local dd2 = 1
  local file_filter = ""
  open_partial_filename_hist_id = open_partial_filename_hist_id or lued.get_hist_id()
  file_filter = lued.prompt(open_partial_filename_hist_id, "Enter Partial Filename: ")
  print("\n")
  local filenames_table = lued.ls_recursive(".", file_filter)
  for i, f in pairs(filenames_table) do
    print(i..": "..f)
  end
  local filename = nil
  if #filenames_table == 1 then
    filename = filenames_table[1]
  end
  lued.open_file(filename,dd)
end


function lued.open_file_bindings(dd)
  lued.open_file(g_bindings_file,dd)
end


function lued.reload_file(dd)
  reopen()
  g_enable_file_changed = true -- tell me when the file has changed.
  lued.disp(dd)
end


function lued.open_filelist(filelist,dd)
  local dd2 = 1
  if filelist==nil then
    open_filelist_hist_id = open_filelist_hist_id or lued.get_hist_id()
    filelist = lued.prompt(open_filelist_hist_id, "Enter Filelist: ")
  end
  if (filelist~=nil and filelist~="") then
    local file = io.open(filelist, "r");
    if file~=nil then
      for filename in file:lines() do
        lued.open_file(filename)
      end
    end
  end
  lued.disp(dd)
end


function lued.new_file(filename, dd)
  local dd2 = 1
  local fileid = lued_open("")
  if filename == nil then
    local default_filename = "lued_untitled_"..fileid..".txt"
    new_file_hist_id = new_file_hist_id or lued.get_hist_id()
    filename = lued.prompt(new_file_hist_id,  "Enter Filename (default: '"..default_filename.."'): ")
    if filename == nil or filename=="" then
      filename = default_filename
    end
  end
  set_fileid(fileid)
  lued.save_as(filename,dd)
end




