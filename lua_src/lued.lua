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


  function expand_path(filename)
    return string.gsub(filename, "^~", os.getenv("HOME") )
  end

  g_lued_root              = "~/.lued/lua_src" -- Path for plugins such as ascii_art.lua, vhdl.lua and verilog.lua
  g_lued_root              = expand_path(g_lued_root)
  g_bindings_file          = g_lued_root .. "/lued_bindings.lua"
  g_auto_indent            = true  -- Indent the same as the previous line
  g_indent_char            = " "   -- Used in indent_selected. Typically a space or tab
  g_indent_size            = 2     -- Used in reindent_selected
  g_remove_trailing_spaces = false -- Only removes on lines that are modified. Use alt_Rats to remove all trailing spaces.
  g_show_trailing_spaces   = true  -- Show trailing spaces in reverse video
  g_scope_indent           = 2     -- Use with indent_scope(is) command. change indent with si2 si3 si4...
  g_mouse_remove_trailing_comma = true -- Some terminals include comma if it is next to selected work. Which is rarely what you want.
  g_min_lines_from_top     = 5     -- Scroll will try to keep at least 5 lines from the top
  g_min_lines_from_bot     = 7     -- Scroll will try to keep at least 7 lines from the bottom
  g_move_down_n_lines      = 8     -- move this many lines when not specified
  g_move_up_n_lines        = 4     -- move this many lines when not specified
  g_move_right_n_char      = 10    -- move this many char when not specified
  g_move_left_n_char       = 3     -- move this many char when not specified
  g_page_size              = 0.5  -- This controls PgUp/PgDn speed. 0.5 is halfs page at a time.
  g_enable_file_changed    = true  -- efc0, efc1. detect file change and prompt to reload FIXME
  g_find_case_sensitive    = false -- find uses case sensitive search
  g_find_whole_word        = false -- Find whole words
  g_find_plaintext         = true  -- plain text search. Set to true for regular expression pattern search
  g_show_line_numbers      = false -- alt_LN (toggle_line_numbers) toggles on/off
  g_ctrl_c_max             = 5     -- Quit when Ctrl+C is pounded several times with empty select buffer
  g_show_help              = false -- Show startup help menu
  g_double_speed           = 0     -- Increases scroll speed. 1 enables this feature. 2 or more goes even faster
  g_lua_mode               = false -- set_lua_mode (Alt+LU) forces lua mode. LuEd automatically goes in and out of Lua mode as needed.
  g_ctrl_s_flow_control    = true  -- Alt+Flow toggles this to enable/disable Ctrl+S / Ctrl+Q
  g_ctrl_c_abort           = true  -- Alt+Abort toggles this to enable/disable Ctrl+C abort
  g_ctrl_z_suspend         = true  -- Alt+Suspend toggles this to enable/disable Ctrl+Z suspect (fg at shell prompt resumes).
  g_comment                = "--"  -- Alt+Co comments line. Alt+Noco removes comment marker
  g_pwd                    = "."   -- This is the current working directory and is changed by change_dir (alt_CD)
  g_review_mode            = false -- In review mode save maps to save_as.
  g_status_line_on         = true  -- Display status line when true, else do not display status line
  g_status_line_reverse    = true  -- Status Line is in reverse video when true, else normal video
  g_search_all_files       = false -- Search all files. set by search_all_files, cleared by
  g_tab_classic            = false -- Select classic tab or better tab
  g_replace_tabs           = 0     -- 4 -- Replace tab with N spaces (does not remove existing tabs). 0 keeps tabs.
  g_tab_size               = 8     -- Tab size
  g_incr_step              = 1     -- step size for incr command
  g_decr_step              = 1     -- step size for incr command

  dofile( g_lued_root .. "/lued_lib.lua" )
  dofile( g_lued_root .. "/lued_version.lua" )
  init_lued(g_lued_root, g_bindings_file)



