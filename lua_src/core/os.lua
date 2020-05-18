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


function lued.pathifier(filename)
    filename = string.gsub(filename, "^~", os.getenv("HOME") )
    local env_name = string.match(filename,"%${?([%w_]+)}?")
    while env_name ~= nil do
      local env_value = os.getenv(env_name)
      filename = string.gsub(filename, "%${?" .. env_name .. "}?", env_value)
      env_name = string.match(filename,"%${?([%w_]+)}?")
    end
    return filename
end


function lued.os_cmd(cmd)
  local stream  = assert(io.popen(cmd, "r"))
  local output_string  = assert(stream:read("*all"))
  stream:close()
  return output_string
end


function lued.read_dir(glob)
  glob = glob or "*"
  local files = lued.os_cmd("ls " .. glob)
  return files
end


function lued.ls_dir(glob)
  ls_dir_hist_id = ls_dir_hist_id or lued.get_hist_id()
  glob = glob or lued_prompt(ls_dir_hist_id, "Enter path, glob or filename. ctrl-A selects All: ")
  glob = glob or ""

  if glob == "ctrl_A" then
    return glob
  end

  local path  = lued.get_dirname(glob)
  local globname = lued.get_basename(glob)
  if lued.is_dir(glob) then
    path = glob
    if path:match("[/]$")==nil then
      path = path .. "/"
    end
    globname = ""
  end

  local file_count = 0
  local return_filename = ""
  local filenames = lued.read_dir(glob)
  if filenames ~= "" then
    print ("")
    local str = "path: " .. path
    if globname and globname~="" then
      str = str .. " glob: " .. globname
    end
    print (str)

    local longest_filename = lued.get_longest_word(filenames);
    local col_width = longest_filename:len() + 2
    local prepend_path = path ~= nil and longest_filename:match("[/]")==nil
    if (prepend_path) then
      col_width = col_width + path:len()
    end
    local tr,tc = get_termsize()
    local num_col_per_line = math.floor(tc / col_width)
    local col_cnt = 0
    local line = ""
    for filename in filenames:gmatch("(%S+)") do
      file_count = file_count + 1
      if prepend_path then
        filename = path .. filename
      end
      local filename_len = filename:len()
      local pad_len = col_width - filename_len
      local spaces = string.rep(' ', pad_len);
      line = line .. filename .. spaces
      col_cnt = col_cnt + 1
      if col_cnt == num_col_per_line then
        print(line)
        col_cnt = 0
        line = ""
      end
    end
    if line ~= "" then
      print(line)
    end
  end
  return glob
end


function lued.exactly_one_file_matches(glob)
  local filenames = lued.read_dir(glob)
  local _,count = filenames:gsub("%S+","")
  if count==1 then
    return lued.chomp(filenames)
  end
  return nil
end


function lued.cd_change_dir(dd)
  local tmp_path = ""
  tmp_path = lued.ls_dir("")
  local previous = tmp_path
  local filename = ""
  repeat
    if tmp_path == "ctrl_A" then -- select all
      if lued.is_dir(previous) then
        previous = previous .. "/*"
      end
      local filenames = lued.read_dir(previous)

      return filenames
    end

    filename = lued.exactly_one_file_matches(tmp_path)
    if not lued.is_empty(filename) then
      return filename
    end
    previous = tmp_path
    tmp_path = lued.ls_dir()
  until tmp_path==""
  lued.disp(dd)
  return nil
end



function lued.ls_recursive(path,filter)
  path = path or "."
  filter = filter or ""
  local filenames_str = lued.os_cmd("find "..path.." -type f -iname '*"..filter.."*'")
  local filenames_table = {}
  for filename in filenames_str:gmatch('[^\n]+') do
    table.insert(filenames_table, filename)
  end
  return filenames_table
end





