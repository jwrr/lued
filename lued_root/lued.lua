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

  g_lued_root              = "~/.lued" -- Path for plugins such as ascii_art.lua, vhdl.lua and verilog.lua
  g_auto_indent            = true  -- Indent the same as the previous line
  g_replace_tabs           = 0     -- 4 -- Replace tab with N spaces (does not remove existing tabs). 0 keeps tabs.
  g_remove_trailing_spaces = false -- Only removes on lines that are modified. Use alt_Rats to remove all trailing spaces.
  g_show_trailing_spaces   = true  -- Show trailing spaces in reverse video
  g_enable_regex           = true  -- ALWAYS REGEX FOR NOW. Use with find commands: ctrl_F, (ff), find_reverse(fr)
  g_scope_indent           = 2     -- Use with indent_scope(is) command. change indent with si2 si3 si4...
  g_min_lines_from_top     = 5     -- Scroll will try to keep at least 5 lines from the top
  g_min_lines_from_bot     = 7     -- Scroll will try to keep at least 7 lines from the bottom
  g_page_size              = 0.25  -- This controls PgUp/PgDn speed. 0.25 is quarter page at a time.
  g_enable_file_changed    = true  -- efc0, efc1. detect file change and prompt to reload
  g_case_sensitive         = false -- case sensitive search
  g_plaintext              = true  -- plain text search. Set to true for regular expression pattern search
  g_show_line_numbers      = false -- alt_LN (toggle_line_numbers) toggles on/off
  g_ctrl_c_max             = 5     -- Quit when Ctrl+C is pounded several times with empty select buffer
  g_show_help              = false -- Show startup help menu
  g_double_speed           = 0     -- Increases scroll speed. 1 enables this feature. 2 or more goes even faster
  g_lua_mode               = false -- set_lua_mode (Alt+LU) forces lua mode. LuEd automatically goes in and out of Lua mode as needed.
  g_ctrl_s_flow_control    = false -- Alt+Flow toggles this to enable/disable Ctrl+S / Ctrl+Q
  g_ctrl_c_abort           = false -- Alt+Abort toggles this to enable/disable Ctrl+C abort
  g_ctrl_z_suspend         = false -- Alt+Suspend toggles this to enable/disable Ctrl+Z suspect (fg at shell prompt resumes).
  g_comment                = "--"  -- Alt+Co comments line. Alt+Noco removes comment marker
  g_pwd                    = "."   -- This is the current working directory and is changed by change_dir (alt_CD)


function pathifier(filename)
    filename = string.gsub(filename, "^~", os.getenv("HOME") )
    local env_name = string.match(filename,"%${?([%w_]+)}?")
    while env_name ~= nil do
      local env_value = os.getenv(env_name)
      filename = string.gsub(filename, "%${?" .. env_name .. "}?", env_value)
      env_name = string.match(filename,"%${?([%w_]+)}?")
    end
    return filename
end

dofile( pathifier(g_lued_root) .. "/lued_lib.lua" )

if first_time == nil then
  local dd2 = 1
  first_time = 1
  set_ctrl_s_flow_control(false,dd2)
  set_ctrl_c_abort(false,dd2)
  set_ctrl_z_suspend(false,dd2)
  decset(1000)
  set_fileid(1,dd2)
  first_line(0)
  mouse(0)
  if g_show_help==true then help(1,0) end
end

local bindings_file = pathifier(g_lued_root) .. "/lued_bindings.lua"
dofile(bindings_file)
load_plugins(g_lued_root .. "/plugins" )
set_edit_mode(0)

