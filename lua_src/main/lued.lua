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

  g_lued_root                   = "~/.lued" -- Path for plugins such as ascii_art.lua, vhdl.lua and verilog.lua
  g_lued_root                   = expand_path(g_lued_root)
  g_lua_src                     = g_lued_root .. "/lua_src"
  g_bindings_file               = g_lua_src .. "/bindings/lued_bindings.lua"
  g_auto_indent                 = true  -- Indent the same as the previous line
  g_block_start                 = { "{" , "begin" , "then" , "do" , "loop" , "repeat", ":" }
  g_block_end                   = { "}" , "end" , "until" }
  g_color_mode                  = 'monochrome' -- '16color' '256color'
  g_express_mode                = false -- arrow keys move faster (ctrl-E toggles)
  g_highlight_current_line      = true
  g_indent_char                 = " "   -- Used in lued.indent_selected. Typically a space or tab
  g_indent_size                 = 2     -- Used in reindent_selected
  g_remove_trailing_spaces      = false -- Only removes on lines that are modified. Use alt_Rats to remove all trailing spaces.
  g_show_trailing_spaces        = true  -- Show trailing spaces in reverse video
  g_scope_indent                = 2     -- Use with indent_scope(is) command. change lued.indent with si2 si3 si4...
  g_mouse_remove_trailing_comma = true -- Some terminals include comma if it is next to selected work. Which is rarely what you want.
  g_min_lines_from_top          = 5     -- Scroll will try to keep at least 5 lines from the top
  g_min_lines_from_bot          = 7     -- Scroll will try to keep at least 7 lines from the bottom
  g_move_down_n_lines           = 4     -- move this many lines when not specified
  g_move_up_n_lines             = 4     -- move this many lines when not specified
  g_move_right_n_char           = 4     -- move this many char when not specified
  g_move_left_n_char            = 4     -- move this many char when not specified
  g_page_size                   = 0.5   -- This controls PgUp/PgDn speed. 0.5 is halfs page at a time.
  g_enable_file_changed         = true  -- efc0, efc1. detect file change and prompt to reload FIXME
  g_find_case_sensitive         = false -- find uses case sensitive search
  g_find_whole_word             = false -- Find whole words
  g_find_plaintext              = true  -- plain text search. Set to true for regular expression pattern search
  g_ctrl_c_max                  = 5     -- Quit when Ctrl+C is pounded several times with empty select buffer
  g_show_abs_line_numbers       = false -- alt_ln/LN turn on/off absolute line numbers
  g_show_rel_line_numbers       = false -- alt_ln/LN turn on/off relative line numbers
  g_show_sb_files               = false -- alt_sb/alt_SB shows/hides sidebar listing open files
  g_show_help                   = false -- Show startup lued.help menu
  g_double_speed                = 0     -- Increases scroll speed. 1 enables this feature. 2 or more goes even faster
  g_lua_mode                    = false -- set_lua_mode (Alt+LU) forces lua mode. LuEd automatically goes in and out of Lua mode as needed.
  g_ctrl_s_flow_control         = true  -- Alt+Flow toggles this to enable/disable Ctrl+S / Ctrl+Q
  g_ctrl_c_abort                = true  -- Alt+Abort toggles this to enable/disable Ctrl+C abort
  g_ctrl_z_suspend              = true  -- Alt+Suspend toggles this to enable/disable Ctrl+Z suspect (fg at shell prompt resumes).
  g_comment                     = "--"  -- Alt+Co comments line. Alt+Noco removes comment marker
  g_pwd                         = "."   -- This is the current working directory and is changed by change_dir (alt_CD)
  g_review_mode                 = false -- In review mode save maps to lued.save_as.
  g_self_closing_braces         = true  -- close "{(["
  g_status_line_on              = true  -- Display status line when true, else do not display status line
  g_status_line_reverse         = true  -- Status Line is in reverse video when true, else normal video
  g_search_all_files            = false -- Search all files. set by lued.search_all_files, cleared by
  g_tab_classic                 = false -- Select classic tab or better tab
  g_replace_tabs                = 0     -- 4 -- Replace tab with N spaces (does not remove existing tabs). 0 keeps tabs.
  g_tab_size                    = 8     -- Tab size
  g_incr_step                   = 1     -- step size for incr command
  g_decr_step                   = 1     -- step size for incr command
  g_wrap_mode                   = false -- true = wrap lines. false = truncate long lines
  g_num_most_recent             = 10    -- Show this many most recent files when alt_T

  g_lnum = 1
  
  g_dont_display = 0 -- This is set to true when  running snippets  
  g_handle_snippets = true
  snips = {}


  package.path = g_lua_src .. "/?.lua;" ..  package.path

  require "core.lued_lib"
  require "core.terminal"
  require "core.os"
  require "core.hotkeys"
  require "core.undo"
  require "core.prompt"
  require "core.files"
  require "core.getters_setters"
  require "core.booleans"
  require "core.replay"
  require "core.display"
  require "core.move"
  require "core.select"
  require "core.insert"
  require "core.find"
  require "core.delete"
  require "core.copy_paste"
  require "core.get_sel"
  require "core.quit"
  require "core.style"
  require "core.version"
  
  
  require "base.align"
  require "base.autocomplete"
  require "base.center_page"
  require "base.comments"
  require "base.ctags"
  require "base.help"
  require "base.increment"
  require "base.indent"
  require "base.linenumbers"
  require "base.markers"
  require "base.mouse"
  require "base.multifile"
  require "base.plugins"
  require "base.remove"
  require "base.sessions"
  require "base.sidebar"
  require "base.snippets"
  require "base.statusline"
  require "base.swap"
  require "base.wrap"


  lued.init_lued(g_lua_src , g_bindings_file)

  lued.ctrl_combo_key = ""
  
  local lued_metatable = {
    -- __index is called when a command is not defined
    __index = function ( t, k )
      if k == nil then return end
      if k == "_PROMPT" then return end -- FIXME
      if k == "row" then return end -- FIXME
--       if string.find(k,"xins_str") then print ("KEY='"..k.."'") io.read() end
--       print ("KEY='"..k.."'") io.read()

      local k2, num_sub = string.gsub(k, "^x", "", 1)
      if num_sub==0 or k2==nil then return end
      
      if string.find(k2, "ctrl_", 1, true) then
        if lued.ctrl_combo_key=="" then
          if _G[k2] then return _G[k2] end
          lued.ctrl_combo_key = k2
        else
          k2 = lued.ctrl_combo_key .. string.gsub(k2, "ctrl_", "", 1)
          lued.ctrl_combo_key = ""
          if _G[k2] then return _G[k2] end 
        end
        return lued.noop
      end

      if lued.ctrl_combo_key=="" then
        if k2 and _G[k2] then return _G[k2] end
        k2 = string.gsub(k2, "alt_", "", 1)
        if k2 and _G[k2]  then return _G[k2] end
      else
        k2 = lued.ctrl_combo_key .. k2
        lued.ctrl_combo_key = ""
        if _G[k2]==nil then
          print ("KEY='" .. k2 .. "'"  .. " not defined. Press <Enter> to Continue...") io.read()
          return lued.noop
        end
        return _G[k2]
      end
      return lued.noop
    end
  }

  setmetatable(_G, lued_metatable)

