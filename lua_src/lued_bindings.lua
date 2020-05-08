--[[
  MIT License, Copyright (c) 2018-2019 JWRR.COM, See LICENSE file
  Get LUED: git clone https://github.com/jwr/lued
--]]

-- key bindings
-- set_hotkeys(",1,2,3,df,dg,dh,dd,ds,da,")
--  set_hotkeys( ",Sn,Sp,sw,v,VV,w,y,x,z,")

--  set_repeatables(",alt_uu,")

-- set_repeatables(",,")
set_non_repeatables(",alt_ee,alt_EE,")

-- Pressing ALT plus KEY is the same as pressing ESC followed by KEY.
-- This is a feature of terminals, not just LUED.

--## Basic Control Key Commands
ctrl__at_        = disp              -- Called when resuming from Ctrl+Z (fg at shell prompt). Not directly used by you.
ctrl_Q           = quit_all          -- Quit or Exit. Similar to Sublime Ctrl-Q.
ctrl_W           = quit_session      -- Close window or tab. Similar to Sublime Ctrl-W.
ctrl_E           = move_to_eol       -- Move to End of Line. Similar to Sublime <End>.
ctrl_R           = move_right_fast   -- Move right defined number (4) of char
ctrl_T           = select_tab        -- Select file tab menu
ctrl_Y           = redo_cmd          -- Redo (undo undo). Similar to Sublime Ctrl+Y
ctrl_U           = spare             -- Spare

ctrl_I           = insert_tab        -- Terminal interprets as `Tab` key
ctrl_O           = open_file         -- Open File. Similar to Word Ctrl+O
ctrl_P           = open_partial_filename -- Open File from partial name. Similar to Sublime Ctrl+P
ctrl_A           = move_to_sol       -- Move to Start of Line. Similar to Sublime <Home>.

ctrl_S           = save_file         -- Save File. Similar to Sublime Ctrl+S.
ctrl_D           = sel_word          -- Select Word under cursor. Similar to Sublime Ctrl+D
ctrl_F           = find_forward_selected -- Find. Similar to Sublime Ctrl+F.  If text is selected the find selected text (Similar to Sublime Ctrl+F3).
ctrl_G           = move_to_line      -- Goto Line Number. Similar to Sublime Ctrl+G

ctrl_H           = find_and_replace  -- Find and Replace. Similar to Sublime Ctrl+H.
ctrl_J           = dont_use          -- Do Not Use. Same as <Enter>
ctrl_K           = spare             -- Spare
ctrl_L           = sel_line          -- Select entire line. Similar to Sublime Ctrl+L

ctrl_Z           = undo_cmd          -- Undo. Similar to Sublime Ctrl+Z
ctrl_X           = cut_line          -- Cut. Similar to Word and Sublime Ctrl+X
ctrl_C           = copy_line         -- Copy. Similar to Sublime Ctrl+C
ctrl_V           = global_paste      -- Paste. Similar to Sublime Ctrl+V
ctrl_B           = spare             -- Spare. - let's keep that way for tmux compatibility

ctrl_N           = new_file          -- Create New File. Similar to Word.
ctrl_M           = dont_use          -- Do Not Use.


--## File Tab Commands
alt_tt           = tab_next                hot("tt")  -- Change to next file tab. Similar to Sublime next_view Ctrl+Tab or Command+Shift+].
alt_TT           = tab_prev                hot("TT")  -- Change to previous file tab. Similar to Sublime prev_view Ctrl+Shift+Tab or Command+Shift+[.
alt__equal_      = tab_toggle              hot("=")   -- Toggle to previous file tab
alt__plus_       = tab_prev                hot(",+,") -- Change to previous file tab. Similar to Sublime prev_view Ctrl+Shift+Tab or Command+Shift+[

--## Select Commands
alt_si           = sel_indentation         hot("si") -- Similar to Sublime Ctrl+shift+J.  Select lines with the indentation.
alt_sb           = sel_inside_braces       hot("sb") -- Select inside curly brace. Similar to Sublime Ctrl+Command+M
alt_se           = sel_eol                 hot("se") -- Select from cursor to End of line
alt_SE           = sel_sol                 hot("SE") -- Select from cursor to starting End of line
alt_sb           = sel_eof                 hot("sb") -- Select to Bottom of File Buffer
alt_SB           = sel_sof                 hot("SB") -- Select to Beginning of File Buffer
alt_sm           = sel_mark_to_cursor      hot("sm") -- Select from mark (alt+mm) to cursor. Similar to Sublime Ctrl+K
alt_ss           = sel_toggle              hot("ss") -- Turn off/on selection. Similar to Sublime <ESC>.
alt_sw           = sel_eow                 hot("sw") -- Select to End of word.
alt_SW           = sel_sow                 hot("SW") -- Select to starting End of word.

--## Movement Commands
alt_bb           = toggle_bottom           hot("bb")  -- Goto bottom of file. Similar to Sublime END
alt_BB           = toggle_top              hot("BB")  -- Goto top of file. Similar to Sublime HOME

alt_ww           = move_right_n_words      hot("ww")  -- Move right one word. Similar to Sublime Ctrl+right_arrow.
alt_WW           = move_left_n_words       hot("WW")  -- Move left one word. Similar to Sublime Ctrl+left_arrow.
alt_ee           = toggle_express_mode     hot("ee") -- Express mode - arrow keys move faster
alt__gt_         = halfsy_right            hot(",>,") -- Move right half the distance
alt__lt_         = halfsy_left             hot(",<,") -- Move left half the distance
alt_R            = move_left_n_char                   -- Move N char left.  alt_l42<Enter> moves 42 char to the left
alt_RR           = move_left_n_char        hot("RR")  -- Move predefined numbed of char to the left.
alt_r            = set_move_right_n_char              -- Move N char right.  alt_r42<Enter> moves 42 char to the right
alt_rr           = move_right_n_char       hot("rr")  -- Move predefined numbed of char to the right.

--## ctag Exuberant Tags
alt_cb           = ctag_move_back_from_tag  hot("cb") -- ctag back
alt_cf           = ctag_move_forward_in_stack hot("cf") -- ctag forward in stack 
alt_ct           = ctag_move_to_tag         hot("ct") -- ctag jump. Similar Sublime Ctrl+R
alt_CT           = ctag_jump_back           hot("CT") -- ctag jump back.
alt_cr           = ctag_read_file           hot("cr") -- ctag read
alt_cx           = ctag_delete_history      hot("cx") -- ctag delete history

--## Delete, Cut, Copy and Paste Commands
alt_ce           = copy_eol                hot("ce") -- copy current pos to eol
alt_CE           = copy_sol                hot("CE") -- copy sol to current pos
alt_cw           = copy_word               hot("cw") -- copy word
alt_DD           = duplicate_line          hot("DD") -- Similar to Sublime Ctrl+Shift+D

alt_d            = del_char                          -- del N char
alt_db           = del_eof                 hot("db") -- Delete to Bottom of Tab/Buffer/Window/File
alt_DB           = del_sof                 hot("DB") -- Delete to Beginning of Tab
alt_de           = del_eol                 hot("de") -- Similar to Sublime Ctrl+KK
alt_DE           = del_sol                 hot("DE") -- Similar to Sublime Ctrl_K+<Backspace>
alt_dl           = del_line                hot("dl") -- Delete line
alt_dm           = del_mark_to_cursor      hot("dm") -- Delete from mark (alt+mm) to cursor
alt_ds           = del_spaces_selected     hot("ds") -- Delete spaces from cursor to non-whitespace.  If on non-whitespace then go to next line and do it.
alt_dd           = del_word                hot("dd") -- Delete word under cursor
alt_dw           = del_eow                 hot("dw") -- Similar to Sublime Ctrl+KW
alt_DW           = del_sow                 hot("DW") -- Similar to Sublime Ctrl+Backspace

alt_pl           = paste_line_after        hot("pl") -- Paste Line after current line
alt_PL           = paste_line_before       hot("PL") -- Paste Line before current line

--## Find and Replace Commands
alt_df           = find_word               hot("df")  -- find word under cursor
alt_DF           = find_reverse_word       hot("DF")  -- find reverse word under cursor
alt_fa           = search_all_files        hot("fa")  -- Similar to Sublime Ctrl+Shift+F. search all open files for match
alt_fb           = find_back               hot("fb")  -- find back. return to position before find operation.
alt_ff           = find_forward_again      hot("ff")  -- Similar to Sublime F3. Find next occurrence of search text.
alt_FF           = find_reverse_again      hot("FF")  -- Similar to Sublime Shift+F3. Find previous occurrence.
alt_files        = set_sb_files            hot("files") -- show sidebar with list of open files
alt_Files        = clr_sb_files            hot("Files") -- hide sidbar with list of open files
alt_FR           = find_reverse_selected   hot("FR")  -- Find previous occurrence.
alt_fc           = set_find_case_sensitive  hot("fc")  -- set find case sensitive
alt_FC           = clr_find_case_sensitive  hot("FC")  -- clear find case sensitive (case insensitive)
alt_fw           = set_find_whole_word     hot("fw")  -- set find whole word
alt_FW           = clr_find_whole_word     hot("FW")  -- clear find whole word
alt_hh           = replace_again           hot("hh")  -- Find and Replace again.
alt_vv           = paste_and_find_forward  hot("vv")  -- Paste and Find Next
alt_VV           = paste_and_find_reverse  hot("VV")  -- Paste and Find Prev
alt__minus_      = find_jump_back          hot(",-,") -- Jump back to previous position before Find. Similar to Sublime jump_back.
alt__            = find_jump_forward       hot(",_,") -- Jump forward to next position in jump stack. Similar to Sublime jump_forward.

--## Line Swap Commands
alt_sn           = swap_line_with_next     hot("sn") -- Swap current line with next line. Similar to Sublime Ctrl+DOWN arrow
alt_sp           = swap_line_with_prev     hot("sp") -- Swap current line with prev line. Similar to Sublime Ctrl+UP arrow
alt_bd           = bubble_selected_lines_down hot("bd") -- line sinks to bottom of file. Similar to sublime Ctrl+Shift+Down
alt_bu           = bubble_selected_lines_up   hot("bu") -- line floats to top of file. Similar to Sublime Ctrl+Shift+Up
alt_bl           = bubble_word_left           hot("bl") -- swap current word with prev word. Similar to Sublime move_word_left
alt_br           = bubble_word_right          hot("br") -- swap current word with next word. Similar to Sublime move_word_right

--## Indent and Align Commands
alt_ii           = indent_selected         hot("ii")  -- Indented selected lines one space
alt_II           = unindent_selected       hot("II")  -- Unindent selected lines one space
alt_ir           = reindent_selected       hot("ir")  -- Reindents selected per defined indent size
alt_is           = set_indent_size         hot("is")  -- Set indent size
alt_aa           = sel_all                 hot("aa")  -- Select All (Entire File). Similar to Sublime Ctrl+A.
alt_al           = align_cur_char;         hot("al") -- Align char on next line with current line
alt_af           = align_selected          hot("af")  -- Align First char on next line with current line. If lines selected then align all lines with first line.

--## Center Cursor Commands
alt_kc           = recenter                hot("kc") -- Recenters cursor to center, press again and recenters to top. Similar to Sublime's CTRL+KC. vim's zz/zt. 
alt_KC           = recenter_top            hot("KC") -- Recenters cursor to top, press again and recenters to center. Similar to Sublime's CTRL+KC. vim's zz/zt. 

--## Comment Commands
alt_cc           = comment_selected        hot("cc") -- Comment out line. Similar to Sublime Ctrl+slash.
alt_CC           = uncomment_selected      hot("CC") -- Uncomment selected lines.
alt_cs           = set_comment             hot("cs") -- Comment set. Change start of comment string.

--## Upper / Lower Case Commands
alt_kl           = sel_to_lower            hot("kl") -- Similar to Sublime Ctrl+KL. Convert to Lower Case
alt_ku           = sel_to_upper            hot("ku") -- Similar to Sublime Ctrl+KU. Convert to Upper Case

--## Mark Commands
alt_sm           = sel_mark_to_cursor      hot("sm") -- Similar to Sublime Ctrl+KA. Select from mark to cursor (set mark with alt_mm)
alt_dm           = del_mark_to_cursor      hot("dm") -- Similar to Sublime Ctrl+KW. Delete from mark to cursor (set mark with alt_mm)
alt_m            = set_named_mark 
alt_M            = goto_named_mark
alt_mm           = set_nameless_mark       hot("mm") -- Similar to Sublime Ctrl+K+space. Set Mark
alt_MM           = goto_nameless_mark_prev hot("MM") -- Goto previous mark
alt_mn           = goto_nameless_mark_next hot("mn") -- Goto next mark in stack

--## Insert Line Before / After Commands
alt_ll           = insert_cr_after         hot("ll") -- Goto to end of line and insert new line. similar to vi's o. Similar to Sublime Ctrl+Enter
alt_LL           = insert_cr_before        hot("LL") -- Goto beginning of line and insert new line. similar to vi's O. Similar to Sublime Ctrl+Shift+Enter

--## Page Up / Down Commands
alt_p            = move_down_n_lines                 -- Move down N lines
alt_P            = move_up_n_lines                   -- Move up N lines
alt_pp           = move_down_n_pages       hot("pp") -- Similar to Sublime <PageDown> (or ctrl+u in vintage mode) , move down half page
alt_PP           = move_up_n_pages         hot("PP") -- Similar to Sublime <PageUP> (or ctrl+d in vintage mode), move up half page

--## Remove Tabs and Spaces
alt_ralt         = remove_all_leading_tabs              -- Replace all leading tabs with spaces at start of line
alt_rats         = remove_all_trailing_space            -- Remove all trailing spaces at end of line
alt_ratsall      = remove_all_trailing_space_all_files  -- Remove all trailing spaces in all files

-- Ctrl-Z Commands
alt_z            = alt_z_wrapper           hot("z")  -- Similar to Sublime Ctrl-z. Undo. After alt-z is used, ctrl-z becomes unix suspend command.


-- Increment / Decrement
alt_incr         = incr                    hot("incr") -- Read number at current position, go down a line, and replace number with incremented value.
alt_decr         = decr                    hot("decr") -- Decrement next line's index.

--## Configuration Commands
-- Setting keystroke combinations start with period ('.')
alt__period_c    = toggle_ctrl_c_abort         -- Toggle Ctrl+C between Cut and Kill Process
alt__period_ind  = toggle_auto_indent          -- Turn auto-indent on/off
--alt__period_cts  = set_ctrl_s_flow_control
--a lt__period_ctz  = toggle_ctrl_z_suspend
--a lt__period_dsp  = toggle_doublespeed
alt__period_edi  = set_edit_mode               -- Change from Lua mode to Edit mode. You almost always want to be in edit mode. 
--a lt__period_fch  = toggle_enable_file_changed
alt__period_lua  = set_lua_mode                -- Toggle to Lua mode to enter lua commands. Rarely used.
alt__period_mlt  = set_min_lines_from_top      -- Set minimum lines to from top of page to cursor
alt__period_mlb  = set_min_lines_from_bot      -- Set minimum lines from cursor to bottom of page
alt__period_ps   = set_pagesize                -- Change number of lines for page up/down command
alt__period_sl   = toggle_status_line_on       -- Toggle on/off the status line
alt__period_slr  = toggle_status_line_reverse  -- Toggle status line being shown in reverse video
alt__period_tab  = set_replace_tabs            -- Toggle replace tabs with spaces as you type (defaults to replace)
alt__period_rts  = toggle_remove_trailing_spaces -- Toggle on/off remove trailing spaces as you type (defaults to don't remove)

alt_p_squote     = set_paste_buffer -- Put string into paste buffer

-- These keys produce escape sequences (escape is not pressed)
esc_backspace    = del_backspace     -- BACKSPACE. Delete previous char. 
esc_insert       = toggle_overtype   -- INSERT. Toggle insert/overtype mode.
esc_delete       = del_char          -- DELETE. Delete current char.  If selection the delete selection.
esc_up           = move_up_n_lines   -- UP ARROW.  Move up one line.
esc_down         = move_down_n_lines -- DOWN ARROW. Move down one line.
esc_left         = move_left_fast    -- LEFT ARROW. Move left one char.
esc_right        = move_right_fast   -- RIGHT ARROW. MOVE right one char.
esc_shift_left   = word_left         -- SHIFT+LEFT ARROW. Move left one word (if supported by terminal). Same as Alt+WW
esc_shift_right  = move_right_n_words -- SHIFT+RIGHT ARROW. Move right one word (if supported by terminal). Same as Alt+ww
esc_home         = move_to_sol        -- HOME. Move to start of line (if supported by terminal). Same as Alt+wq
esc_end          = move_to_eol        -- END. Move to end of line (if supported by terminal). Same as Alt+we
esc_pageup       = move_up_n_pages    -- PAGEUP. Move up one page (if supported by terminal). Same as Alt+PP
esc_pagedown     = move_down_n_pages  -- PAGEDOWN. Move down one page (if supported by terminal). Same as Alt+pp

-- These mouse actions produce escape sequences (escape is not pressed)
esc_mouse        = mouse_event         -- Mouse event. Double Left Mouse Button (LMB) selects word. Triple selects line. Middle Mouse Button (MMB) pastes mouse selection.
esc_pastestart   = bracket_paste_start -- Mouse paste start
esc_pastestop    = bracket_paste_stop  -- Mouse paste stop

--## Misc Commands

alt__caret_      = del_sol                 hot("^")   -- delete from cursor to start of line
alt__dollar_     = del_eol                 hot("$")   -- delete from cursor to end of line
alt__slash_      = find_forward            hot(",/,") -- find forward
alt__colon_w     = save_file               hot(":w")  -- Save File. Similar to Vi :w

alt_cd           = cd_change_dir;          hot("cd")  -- Change directory
alt_ed           = set_edit_mode           hot("ed")  -- Change to EDIT mode. You almost always want to be in EDIT mode.
alt_help         = open_file_bindings      hot("help")  -- Help. Open lued_bindings.lua
alt_jj           = join_lines              hot("jj")  -- Similar to Sublime Ctrl+J. Join lines.
alt_ln           = set_abs_line_numbers    hot("ln")  -- show absolute line numbers
alt_LN           = clr_abs_line_numbers    hot("LN")  -- hide absolute line numbers

alt_rln          = set_rel_line_numbers    hot("rln")  -- show relative line numbers
alt_RLN          = clr_rel_line_numbers    hot("RLN")  -- hide relative line numbers

alt_ls           = ls_dir                  hot("ls")  -- unix ls command. dos dir command
alt_LU           = set_lua_mode            hot("LU")  -- Change to LUA mode. You rarely want to be in lua mode.
alt_qq           = wrap_line               hot("qq")  -- Wrap line at cursor. Subsequent lines end at previous line. Similar to Sublime Alt+q
alt_relued       = relued                             -- Reload lued script
alt_review       = toggle_review_mode                 -- Review mode prevents saving file
alt_refresh      = reload_file                        -- Reload current file
alt_sa           = save_as                 hot("sa")  -- Similar to Sublime Ctrl+Shift+S. File Save as.
alt_SaveSession  = save_session_file
alt_LoadSession  = load_session_file
alt_Seti         = set_scope_indent                  -- Set Scope Indent SI2 SI3 SI4
-- alt_sw           = function() set_sel_start(); var_end(1); set_sel_end(); disp(); end hot("sw")



-- DONE



