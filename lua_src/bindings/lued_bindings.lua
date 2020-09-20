--[[
  MIT License, Copyright (c) 2018-2019 JWRR.COM, See LICENSE file
  Get LUED: git clone https://github.com/jwr/lued
--]]

-- key bindings
-- set_hotkeys(",1,2,3,df,dg,dh,dd,ds,da,")
--  set_hotkeys( ",Sn,Sp,sw,v,VV,w,y,x,z,")

--  set_repeatables(",alt_uu,")

-- set_repeatables(",,")
set_non_repeatables(",alt_ee,alt_EE,alt_bb,alt_BB,")

-- Pressing ALT plus KEY is the same as pressing ESC followed by KEY.
-- This is a feature of terminals, not just LUED.

--## Basic Control Key Commands
ctrl__at_        = lued.disp              -- Called when resuming from Ctrl+Z (fg at shell prompt). Not directly used by you.
ctrl_Q           = lued.quit_all          -- Quit or Exit. Similar to Sublime Ctrl-Q.
ctrl_W           = lued.quit_session      -- Close window or tab. Similar to Sublime Ctrl-W.
ctrl_E           = lued.move_to_eol       -- Move to End of Line. Similar to Sublime &lt;End&gt;.
--ctrl_R           = lued.move_right_fast   -- Move right defined number (4) of char
ctrl_R           = lued.replay_keystrokes -- Move right defined number (4) of char
ctrl_T           = lued.select_tab        -- Select file tab menu
ctrl_Y           = lued.redo_cmd          -- Redo (undo undo). Similar to Sublime Ctrl+Y
ctrl_U           = lued.spare             -- Spare

ctrl_I           = lued.insert_tab        -- Terminal interprets as `Tab` key
ctrl_O           = lued.open_file         -- Open File. Similar to Word Ctrl+O
ctrl_P           = lued.open_partial_filename -- Open File from partial name. Similar to Sublime Ctrl+P
ctrl_A           = lued.move_to_sol       -- Move to Start of Line. Similar to Sublime &lt;Home&gt;.

ctrl_S           = lued.save_file         -- Save File. Similar to Sublime Ctrl+S.
ctrl_D           = lued.sel_word          -- Select Word under cursor. Similar to Sublime Ctrl+D
ctrl_F           = lued.find_forward_selected -- Find. Similar to Sublime Ctrl+F.  If text is selected the find selected text (Similar to Sublime Ctrl+F3).
ctrl_G           = lued.move_to_line      -- Goto Line Number. Similar to Sublime Ctrl+G

ctrl_H           = lued.find_and_replace  -- Find and Replace. Similar to Sublime Ctrl+H.
ctrl_J           = lued.dont_use          -- Do Not Use. Same as Enter Key
-- ctrl_K           = lued.ctrl_combo        -- Control Combo
ctrl_KK          = lued.del_eol           -- Delete from cursor to end of line. Similar to Sublime Ctrl+KK
ctrl_KH          = lued.del_sol           -- Delete from cursor to start of line. Press Ctrl+&lt;Backspace&gt; instead of 'H'. Similar to Sublime Ctrl+K,Ctrl+Backspace
ctrl_Kesc_backspace = lued.del_sol        -- Delete from cursor to start of line. Similar to Sublime Ctrl+K,Ctrl+Backspace
ctrl_KL          = lued.sel_to_lower      -- Transform selection or current char to lowercase. Similar to Sublime Ctrl+KL 
ctrl_KU          = lued.sel_to_upper      -- Transform selection or current char to uppercase. Similar to Sublime Ctrl+KU

ctrl_L           = lued.sel_line          -- Select entire line. Similar to Sublime Ctrl+L

ctrl_Z           = lued.undo_cmd          -- Undo. Similar to Sublime Ctrl+Z
ctrl_X           = lued.cut_sel_or_line   -- Cut. Similar to Word and Sublime Ctrl+X
ctrl_C           = lued.copy_line         -- Copy. Similar to Sublime Ctrl+C
ctrl_V           = lued.global_paste      -- Paste. Similar to Sublime Ctrl+V
ctrl_B           = lued.spare             -- Spare. - let's keep that way for tmux compatibility

ctrl_N           = lued.new_file          -- Create New File. Similar to Word.
ctrl_M           = lued.dont_use          -- Do Not Use.


--## File Tab Commands
alt_tt           = lued.tab_next                lued.hot("tt")  -- Change to next file tab. Similar to Sublime next_view Ctrl+Tab or Command+Shift+].
alt_TT           = lued.tab_prev                lued.hot("TT")  -- Change to previous file tab. Similar to Sublime prev_view Ctrl+Shift+Tab or Command+Shift+[.

--## Select Commands
alt_si           = lued.sel_indentation         lued.hot("si") -- Similar to Sublime Ctrl+shift+J.  Select lines with the indentation.
alt_sb           = lued.sel_inside_braces       lued.hot("sb") -- Select inside curly brace. Similar to Sublime Ctrl+Command+M
alt_se           = lued.sel_eol                 lued.hot("se") -- Select from cursor to End of line
alt_SE           = lued.sel_sol                 lued.hot("SE") -- Select from cursor to starting End of line
alt_sb           = lued.sel_eof                 lued.hot("sb") -- Select to Bottom of File Buffer
alt_SB           = lued.sel_sof                 lued.hot("SB") -- Select to Beginning of File Buffer
alt_sm           = lued.sel_mark_to_cursor      lued.hot("sm") -- Select from mark (alt+mm) to cursor. Similar to Sublime Ctrl+K
alt_ss           = lued.sel_toggle              lued.hot("ss") -- Turn off/on selection. Similar to Sublime ESC-Key.
alt_sw           = lued.sel_eow                 lued.hot("sw") -- Select to End of word.
alt_SW           = lued.sel_sow                 lued.hot("SW") -- Select to starting End of word.

--## Movement Commands
alt_bb           = lued.toggle_bottom           lued.hot("bb")  -- Goto bottom of file. Similar to Sublime END
alt_BB           = lued.toggle_top              lued.hot("BB")  -- Goto top of file. Similar to Sublime HOME

alt_ww           = lued.move_right_n_words      lued.hot("ww")  -- Move right one word. Similar to Sublime Ctrl+right_arrow.
alt_WW           = lued.move_left_n_words       lued.hot("WW")  -- Move left one word. Similar to Sublime Ctrl+left_arrow.
alt_ee           = lued.toggle_express_mode     lued.hot("ee") -- Express mode - arrow keys move faster
alt__gt_         = lued.move_halfsy_right       lued.hot(",>,") -- Move right half the distance
alt__lt_         = lued.move_halfsy_left        lued.hot(",<,") -- Move left half the distance
alt_rn           = lued.replay_name             lued.hot("rn")  -- replay named keystroke sequence
alt_rr           = lued.replay_again            lued.hot("rr")  -- replay keystroke sequence again
-- alt_R            = lued.move_left_n_char                   -- Move N char left.  alt_l42&lt;Enter&gt; moves 42 char to the left
-- alt_RR           = lued.move_left_n_char        lued.hot("RR")  -- Move predefined numbed of char to the left.
-- alt_r            = lued.set_move_right_n_char              -- Move N char right.  alt_r42&lt;Enter&gt; moves 42 char to the right
-- alt_rr           = lued.move_right_n_char       lued.hot("rr")  -- Move predefined numbed of char to the right.

--## Ctags /  Exuberant Tags
alt_cb           = lued.ctag_move_back_from_tag  lued.hot("cb") -- ctag back
alt_cf           = lued.ctag_move_forward_in_stack lued.hot("cf") -- ctag forward in stack 
alt_ct           = lued.ctag_move_to_tag         lued.hot("ct") -- ctag jump. Similar Sublime Ctrl+R
alt_CT           = lued.ctag_jump_back           lued.hot("CT") -- ctag jump back.
alt_cr           = lued.ctag_read_file           lued.hot("cr") -- ctag read
alt_cx           = lued.ctag_delete_history      lued.hot("cx") -- ctag delete history

--## Delete, Cut, Copy and Paste Commands
alt_ce           = lued.copy_eol                lued.hot("ce") -- Copy current pos to eol
alt_CE           = lued.copy_sol                lued.hot("CE") -- Copy sol to current pos
alt_cw           = lued.copy_word               lued.hot("cw") -- Copy word
alt_DD           = lued.duplicate_line          lued.hot("DD") -- Duplicate line. Similar to Sublime Ctrl+Shift+D

alt_d            = lued.del_n_lines                            -- Delete N lines
alt_da           = lued.del_all                 lued.hot("da") -- Delete all, entire file
alt_db           = lued.del_eof                 lued.hot("db") -- Delete to Bottom of Tab/Buffer/Window/File
alt_DB           = lued.del_sof                 lued.hot("DB") -- Delete to Beginning of Tab
alt_de           = lued.del_eol                 lued.hot("de") -- Delete to end of line. Similar to Sublime Ctrl+KK
alt_DE           = lued.del_sol                 lued.hot("DE") -- Delete to start of line. Similar to Sublime Ctrl_K+&lt;Backspace&gt;
alt_dl           = lued.del_line                lued.hot("dl") -- Delete line
alt_dn           = lued.del_next                lued.hot("dn") -- Delete up to  next find occurrence
alt_dm           = lued.del_mark_to_cursor      lued.hot("dm") -- Delete from mark (alt+mm) to cursor
alt_ds           = lued.del_spaces_selected     lued.hot("ds") -- Delete spaces from cursor to non-whitespace.  If on non-whitespace then go to next line and do it.
alt_DS           = lued.del_sow                 lued.hot("DS") -- Delete spaces to the left
alt_dd           = lued.del_word                lued.hot("dd") -- Delete word under cursor
alt_dw           = lued.del_eow                 lued.hot("dw") -- Delete to end of word. Similar to Sublime Ctrl+KW
alt_DW           = lued.del_sow                 lued.hot("DW") -- Delete to start of word. Similar to Sublime Ctrl+Backspace


alt_x            = lued.cut_n_lines                            -- Cut multiple lines alt+x42&lt;enter&gt;
alt_xa           = lued.cut_all                 lued.hot("xa") -- Cut all, entire file
alt_xb           = lued.cut_eof                 lued.hot("xb") -- Cut to Bottom of Tab/Buffer/Window/File
alt_XB           = lued.cut_sof                 lued.hot("XB") -- Cut to Beginning of Tab
alt_xe           = lued.cut_eol                 lued.hot("xe") -- Cut to end of line. Similar to Sublime Ctrl+KK
alt_XE           = lued.cut_sol                 lued.hot("XE") -- Cut to start of line. Similar to Sublime Ctrl_K+&lt;Backspace&gt;
alt_xl           = lued.cut_line                lued.hot("xl") -- Cut line
alt_xm           = lued.cut_mark_to_cursor      lued.hot("xm") -- Cut from mark (alt+mm) to cursor
alt_xn           = lued.cut_next                lued.hot("xn") -- Cut up to next find occurrence
alt_xs           = lued.cut_spaces_selected     lued.hot("xs") -- Cut spaces from cursor to non-whitespace.  If on non-whitespace then go to next line and do it.
alt_XS           = lued.cut_sow                 lued.hot("XS") -- Cut spaces to the left
alt_xx           = lued.cut_word                lued.hot("xx") -- Cut word under cursor
alt_xw           = lued.cut_eow                 lued.hot("xw") -- Cut to end of word. Similar to Sublime Ctrl+KW
alt_XW           = lued.cut_sow                 lued.hot("XW") -- Cut to start of word. Similar to Sublime Ctrl+Backspace

alt_pl           = lued.paste_line_after        lued.hot("pl") -- Paste Line after current line
alt_PL           = lued.paste_line_before       lued.hot("PL") -- Paste Line before current line

--## Find and Replace Commands
alt_df           = lued.find_word               lued.hot("df")  -- find word under cursor
alt_DF           = lued.find_reverse_word       lued.hot("DF")  -- find reverse word under cursor
alt_fa           = lued.search_all_files        lued.hot("fa")  -- Similar to Sublime Ctrl+Shift+F. search all open files for match
alt_fb           = find_back                    lued.hot("fb")  -- find back. return to position before find operation.
alt_ff           = lued.find_forward_again      lued.hot("ff")  -- Similar to Sublime F3. Find next occurrence of search text.
alt_FF           = lued.find_reverse_again      lued.hot("FF")  -- Similar to Sublime Shift+F3. Find previous occurrence.
alt_kb           = lued.set_sb_files            lued.hot("kb") -- show sidebar with list of open files
alt_KB           = lued.clr_sb_files            lued.hot("KB") -- hide sidbar with list of open files
alt_FR           = lued.find_reverse_selected   lued.hot("FR")  -- Find previous occurrence.
alt_fc           = lued.set_find_case_sensitive lued.hot("fc")  -- set find case sensitive
alt_FC           = lued.clr_find_case_sensitive lued.hot("FC")  -- clear find case sensitive (case insensitive)
alt_fw           = lued.set_find_whole_word     lued.hot("fw")  -- set find whole word
alt_FW           = lued.clr_find_whole_word     lued.hot("FW")  -- clear find whole word
alt_hh           = lued.replace_again           lued.hot("hh")  -- Find and Replace again.
alt_VV           = lued.paste_and_find_reverse  lued.hot("VV")  -- Paste and Find Prev
alt_vv           = lued.paste_and_find_forward  lued.hot("vv")  -- Paste and Find Next
alt__minus_      = lued.find_jump_back          lued.hot(",-,") -- Jump back to previous position before Find. Similar to Sublime lued.jump_back.
alt__            = lued.find_jump_forward       lued.hot(",_,") -- Jump forward to next position in jump stack. Similar to Sublime lued.jump_forward.

--## Line Swap Commands
alt_sl           = lued.swap_line_with_next     lued.hot("sl") -- Swap current line with next line. Similar to Sublime Ctrl+DOWN arrow
alt_SL           = lued.swap_line_with_prev     lued.hot("SL") -- Swap current line with prev line. Similar to Sublime Ctrl+UP arrow
alt_bl           = lued.bubble_selected_lines_down lued.hot("bl") -- line sinks down towards bottom of file. Similar to sublime Ctrl+Shift+Down
alt_BL           = lued.bubble_selected_lines_up   lued.hot("BL") -- line floats up towards top of file. Similar to Sublime Ctrl+Shift+Up
alt_br           = lued.bubble_word_right          lued.hot("br") -- swap current word with next word. Similar to Sublime move_word_right
alt_BR           = lued.bubble_word_left           lued.hot("BR") -- swap current word with prev word. Similar to Sublime move_word_left

--## Indent and Align Commands
alt_ii           = lued.indent_selected         lued.hot("ii")  -- Indented selected lines one space
alt_II           = lued.unindent_selected       lued.hot("II")  -- Unindent selected lines one space
alt_ir           = lued.reindent_selected       lued.hot("ir")  -- Reindents selected per defined lued.indent size
alt_is           = lued.set_indent_size         lued.hot("is")  -- Set lued.indent size
alt_aa           = lued.sel_all                 lued.hot("aa")  -- Select All (Entire File). Similar to Sublime Ctrl+A.
alt_al           = lued.align_cur_char          lued.hot("al") -- Align char on next line with current line
alt_af           = lued.align_selected          lued.hot("af")  -- Align First char on next line with current line. If lines selected then align all lines with first line.

--## Center Cursor Commands
alt_ce           = set_recenter_screen          lued.hot("ce") -- Keep cursor centered
alt_CE           = clr_recenter_screen          lued.hot("CE") -- Turn off keep cursor centered
alt_kc           = lued.recenter                lued.hot("kc") -- Recenters cursor to center, press again and recenters to top. Similar to Sublime's CTRL+KC. vim's zz/zt. 
alt_KC           = lued.recenter_top            lued.hot("KC") -- Recenters cursor to top, press again and recenters to center. Similar to Sublime's CTRL+KC. vim's zz/zt. 

--## Comment Commands
alt_cc           = lued.comment_selected        lued.hot("cc") -- Comment out line. Similar to Sublime Ctrl+slash.
alt_CC           = lued.uncomment_selected      lued.hot("CC") -- Uncomment selected lines.
alt_cs           = lued.set_comment             lued.hot("cs") -- Comment set. Change start of comment string.

--## Upper / Lower Case Commands
alt_kl           = lued.sel_to_lower            lued.hot("kl") -- Similar to Sublime Ctrl+KL. Convert to Lower Case
alt_ku           = lued.sel_to_upper            lued.hot("ku") -- Similar to Sublime Ctrl+KU. Convert to Upper Case

--## Mark Commands
alt_sm           = lued.sel_mark_to_cursor      lued.hot("sm") -- Similar to Sublime Ctrl+KA. Select from mark to cursor (set mark with alt_mm)
alt_dm           = lued.del_mark_to_cursor      lued.hot("dm") -- Similar to Sublime Ctrl+KW. Delete from mark to cursor (set mark with alt_mm)
alt_m            = lued.set_named_mark                         -- Set Named Marker 
alt_M            = lued.goto_named_mark                        -- Goto Named Marker
alt_mm           = lued.set_nameless_mark       lued.hot("mm") -- Similar to Sublime Ctrl+K+space. Set Mark
alt_MM           = lued.goto_nameless_mark_prev lued.hot("MM") -- Goto previous mark
alt_mn           = lued.goto_nameless_mark_next lued.hot("mn") -- Goto next mark in stack

--## Insert Line Before / After Commands
alt_ll           = lued.insert_line_after         lued.hot("ll") -- Goto to end of line and insert new line. similar to vi's o. Similar to Sublime Ctrl+Enter
alt_LL           = lued.insert_line_before        lued.hot("LL") -- Goto beginning of line and insert new line. similar to vi's O. Similar to Sublime Ctrl+Shift+Enter

--## Page Up / Down Commands
alt_p            = lued.move_down_n_lines                      -- Move down N lines
alt_P            = lued.move_up_n_lines                        -- Move up N lines
alt_pp           = lued.move_down_n_pages       lued.hot("pp") -- Similar to Sublime &lt;PageDn&gt; (or ctrl+u in vintage mode) , move down half page
alt_PP           = lued.move_up_n_pages         lued.hot("PP") -- Similar to Sublime &lt;PageUp&gt; (or ctrl+d in vintage mode), move up half page

--## Remove Tabs and Spaces
alt_ralt         = lued.remove_all_leading_tabs              -- Replace all leading tabs with spaces at start of line
alt_rats         = lued.remove_all_trailing_space            -- Remove all trailing spaces at end of line
alt_ratsall      = lued.remove_all_trailing_space_all_files  -- Remove all trailing spaces in all files

-- Ctrl-Z Commands
alt_z            = lued.alt_z_wrapper           lued.hot("z")  -- Similar to Sublime Ctrl-z. Undo. After alt-z is used, ctrl-z becomes unix suspend command.


-- Increment / Decrement
alt_incr         = lued.incr                    lued.hot("incr") -- Read number at current position, go down a line, and replace number with incremented value.
alt_decr         = lued.decr                    lued.hot("decr") -- Decrement next line's index.

--## Configuration Commands
-- Setting keystroke combinations start with period ('.')
alt__period_c    = lued.toggle_ctrl_c_abort         -- Toggle Ctrl+C between Cut and Kill Process
alt__period_ind  = lued.toggle_auto_indent          -- Turn auto-lued.indent on/off
--alt__period_cts  = lued.set_ctrl_s_flow_control
--a lt__period_ctz  = lued.toggle_ctrl_z_suspend
--a lt__period_dsp  = lued.toggle_doublespeed
alt__period_edi  = set_edit_mode               -- Change from Lua mode to Edit mode. You almost always want to be in edit mode. 
--a lt__period_fch  = lued.toggle_enable_file_changed
alt__period_lua  = set_lua_mode                -- Toggle to Lua mode to enter lua commands. Rarely used.
alt__period_mlt  = lued.set_min_lines_from_top      -- Set minimum lines to from top of page to cursor
alt__period_mlb  = lued.set_min_lines_from_bot      -- Set minimum lines from cursor to bottom of page
alt__period_ps   = lued.set_pagesize                -- Change number of lines for page up/down command
alt__period_sl   = toggle_status_line_on       -- Toggle on/off the status line
alt__period_slr  = toggle_status_line_reverse  -- Toggle status line being shown in reverse video
alt__period_tab  = set_replace_tabs            -- Toggle replace tabs with spaces as you type (defaults to replace)
alt__period_rts  = lued.toggle_remove_trailing_spaces -- Toggle on/off remove trailing spaces as you type (defaults to don't remove)

alt_p_squote     = lued.set_paste_buffer -- Put string into lued.paste buffer

-- These keys produce escape sequences (escape is not pressed)
esc_backspace    = lued.del_backspace     -- BACKSPACE. Delete previous char. 
esc_insert       = lued.toggle_overtype   -- INSERT. Toggle insert/overtype mode.
exsc_insert = esc_insert
esc_delete       = lued.del_char          -- DELETE. Delete current char.  If selection the delete selection.
esc_up           = lued.move_up_n_lines   -- UP ARROW.  Move up one line.
esc_down         = lued.move_down_n_lines -- DOWN ARROW. Move down one line.
esc_left         = lued.move_left_fast    -- LEFT ARROW. Move left one char.
esc_right        = lued.move_right_fast   -- RIGHT ARROW. MOVE right one char.
esc_shift_left   = word_left         -- SHIFT+LEFT ARROW. Move left one word (if supported by terminal). Same as Alt+WW
esc_shift_right  = lued.move_right_n_words -- SHIFT+RIGHT ARROW. Move right one word (if supported by terminal). Same as Alt+ww
esc_home         = lued.move_to_sol        -- HOME. Move to start of line (if supported by terminal). Same as Alt+wq
esc_end          = lued.move_to_eol        -- END. Move to end of line (if supported by terminal). Same as Alt+we
esc_pageup       = lued.move_up_n_pages    -- PAGEUP. Move up one page (if supported by terminal). Same as Alt+PP
esc_pagedown     = lued.move_down_n_pages  -- PAGEDOWN. Move down one page (if supported by terminal). Same as Alt+pp

-- These mouse actions produce escape sequences (escape is not pressed)
esc_mouse        = lued.mouse_event         -- Mouse event. Double Left Mouse Button (LMB) selects word. Triple selects line. Middle Mouse Button (MMB) pastes mouse selection.
esc_pastestart   = lued.bracket_paste_start -- Mouse lued.paste start
esc_pastestop    = lued.bracket_paste_stop  -- Mouse lued.paste stop

--## Misc Commands

alt__caret_      = lued.del_sol                 lued.hot("^")   -- Delete from cursor to start of line
alt__dollar_     = lued.cut_eol                 lued.hot("$")   -- Delete from cursor to end of line
alt__slash_      = lued.find_forward            lued.hot(",/,") -- Find forward
alt__colon_w     = lued.save_file               lued.hot(":w")  -- Save File. Similar to Vi :w

alt_colors       = lued.show_colors                             -- Show colors
alt_cd           = lued.cd_change_dir;          lued.hot("cd")  -- Change directory
alt_ed           = set_edit_mode           lued.hot("ed")  -- Change to EDIT mode. You almost always want to be in EDIT mode.
alt_help         = lued.open_file_bindings      lued.hot("lued.help")  -- Help. Open lued_bindings.lua
alt_jj           = lued.join_lines              lued.hot("jj")  -- Similar to Sublime Ctrl+J. Join lines.
alt_ln           = lued.set_abs_line_numbers    lued.hot("ln")  -- show absolute line numbers
alt_LN           = lued.clr_abs_line_numbers    lued.hot("LN")  -- hide absolute line numbers

alt_rln          = lued.set_rel_line_numbers    lued.hot("rln")  -- show relative line numbers
alt_RLN          = lued.clr_rel_line_numbers    lued.hot("RLN")  -- hide relative line numbers

alt_ls           = lued.ls_dir                  lued.hot("ls")  -- unix ls command. dos dir command
alt_LU           = set_lua_mode                 lued.hot("LU")  -- Change to LUA mode. You rarely want to be in lua mode.
alt_no           = lued.noop                    lued.hot("noop") -- No Op. Type no if you've pressed esc and can't think of any other command to type
alt_pwd          = lued.pwd                                      -- print working directory
alt_qq           = lued.wrap_line               lued.hot("qq")  -- Wrap line at cursor. Subsequent lines end at previous line. Similar to Sublime Alt+q
alt_QQ           = lued.set_wrap_col            lued.hot("QQ")  -- set join wrap
alt_reinit       = lued.reinit                             -- Reload lued script
alt_review       = lued.toggle_review_mode                 -- Review mode prevents saving file
alt_refresh      = lued.reload_file                        -- Reload current file
alt_sa           = lued.save_as                 lued.hot("sa")  -- Similar to Sublime Ctrl+Shift+S. File Save as.
alt_Sesss        = lued.save_session_file                       -- Save session file
alt_Sessl        = lued.load_session_file                       -- Load session file
alt_Seti         = lued.set_scope_indent                  -- Set Scope Indent SI2 SI3 SI4
-- alt_sw           = function() set_sel_start(); lued.var_end(1); set_sel_end(); lued.disp(); end lued.hot("sw")

alt_test = lued.open_filerc_test

-- DONE



