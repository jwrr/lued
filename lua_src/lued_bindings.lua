--[[
  MIT License, Copyright (c) 2018-2019 JWRR.COM, See LICENSE file
  Get LUED: git clone https://github.com/jwr/lued
--]]

-- key bindings
-- set_hotkeys(",1,2,3,df,dg,dh,dd,ds,da,")
--  set_hotkeys( ",Sn,Sp,sw,v,VV,w,y,x,z,")

set_repeatables(",alt_aa,")
--  set_repeatables(",alt_aa,alt_as,alt_bd,alt_bu,alt_cc,alt_cr,alt_d,alt_ff,alt_FF,alt_ii,alt_jj,alt_rr,alt_uu,")
--  set_repeatables(",alt_pk,alt_pl,alt_sn,alt_sp,")

-- set_repeatables(",,")
--  set_non_repeatables(",alt_jj,")


-- Pressing ALT plus KEY is the same as pressing ESC followed by KEY.
-- This is a feature of terminals, not just LUED.
-- sow
alt__caret_      = del_sol                 hot("^")
alt__dollar_     = del_eol                 hot("$")
-- alt__period_  = sel_toggle              hot(".")
alt__slash_      = find_forward            hot(",/,") -- FIXME make this regex
alt__minus_      = tab_prev                hot(",-,") -- Similar to Sublime Ctrl+Shift+Tab
alt__equal_      = tab_next                hot("=")   -- Similar to Sublime Ctrl+Tab
alt__plus_       = tab_prev                hot(",+,")
alt__colon_w     = save_file               hot(":w")
alt__gt_         = halfsy_right            hot(",>,") -- Move half the distance
alt__lt_         = halfsy_left             hot(",<,") -- Move back half the distance

alt_aa           = align_delimiter_selected hot("aa")
alt_as           = align_selected          hot("as")

alt_bb           = toggle_bottom              hot("bb")
alt_bd           = bubble_selected_lines_down hot("bd") -- line sinks to bottom of file. Similar to sublime Ctrl+Shift+Down
alt_bu           = bubble_selected_lines_up   hot("bu") -- line floats to top of file. Similar to sublime Ctrl+Shift+Up

-- plugin bindings: ctag
alt_cb = ctag_move_back_from_tag; hot("cb") -- ctag back
alt_ct = ctag_move_to_tag;        hot("ct") -- ctag jump. Similar Sublime Ctrl+R
alt_cr = ctag_read_file;          hot("cr") -- ctag read

alt_cc           = comment_selected        hot("cc") -- Similar to Sublime Ctrl+/. Comment Line
alt_cu           = uncomment_selected      hot("cu") -- comment remove
alt_cd           = cd_change_dir;          hot("cd")
alt_cs           = set_comment             hot("cs")

alt_dd           = duplicate_line          hot("dd") -- Similar to Sublime Ctrl+Shift+D
alt_dq           = del_sol                 hot("dq") -- Similar to Sublime Ctrl_K+<Backspace>
alt_de           = del_eol                 hot("de") -- Similar to Sublime Ctrl+KK
alt_dm           = del_mark_to_cursor      hot("dm") -- 
alt_ds           = del_spaces_selected     hot("ds") -- Delete spaces from cursor to non-whitespace.  If on non-whitespace then go to next line and do it.
alt_dw           = del_eow                 hot("dw") -- Similar to Sublime Ctrl+KW
alt_DW           = del_backword            hot("DW") -- Similar to Sublime Ctrl+Backspace

alt_ed           = set_edit_mode           hot("ed")
alt_fa           = search_all_files;       hot("fa")  -- Similar to Sublime Ctrl+Shift+F. search all open files for match
alt_ff           = find_forward_again;     hot("ff")  -- Similar to Sublime F3. Find next occurrence of search text.
alt_FF           = find_reverse_again;     hot("FF")  -- Similar to Sublime Shift+F3. Find previous occurrence.
alt_hh           = replace_again           hot("hh")
alt_he           = open_file_bindings      hot("he")
alt_ii           = indent_selected         hot("ii")
alt_ir           = reindent_selected       hot("ir")
alt_is           = set_indent_size         hot("is")
alt_jj           = join_lines              hot("jj") -- Similar to Sublime Ctrl+J. Join lines.
alt_ka           = sel_mark_to_cursor      hot("ka") -- Similar to Sublime Ctrl+KA. Select from mark to cursor (set mark with alt_mm)
alt_kc           = recenter                hot("kc") -- Similar to Sublime's CTRL+KC. vim's zz/zt. recenters cursor to top, press again and recenters to center. 
alt_kl           = sel_to_lower            hot("kl") -- Similar to Sublime Ctrl+KL. Convert to Lower Case
alt_ku           = sel_to_upper            hot("ku") -- Similar to Sublime Ctrl+KU. Convert to Upper Case
alt_kw           = del_mark_to_cursor      hot("kw") -- Similar to Sublime Ctrl+KW. Delete from mark to cursor (set mark with alt_mm)

alt_l            = move_left_n_char -- Move N char left.  alt_l42<Enter> moves 42 char to the left
alt_ll           = insert_cr_after         hot("ll") -- similar to vi's o. Similar to Sublime Ctrl+Enter
alt_lk           = insert_cr_before        hot("lk") -- similar to vi's O. Similar to Sublime Ctrl+Shift+Enter
alt_ln           = toggle_line_numbers     hot("ln") -- show line numbers
alt_ls           = ls_dir                  hot("ls") -- unix ls command. dos dir command
alt_LU           = set_lua_mode            hot("LU")
alt_M_squote     = function(name) set_mark(name); disp() end
alt_M_squote     = function(name) goto_mark(name); disp() end
alt_mm           = set_nameless_mark       hot("mm") -- Similar to Sublime Ctrl+K+space. Set Mark
alt_mp           = goto_nameless_mark_prev hot("mp") -- 
alt_mn           = goto_nameless_mark_next hot("mn")
alt_nn           = new_file                hot("nn")
alt_pl           = paste_line_after        hot("pl")
alt_pk           = paste_line_before       hot("pk")
alt_pp           = move_down_n_pages       hot("pp") -- Similar to Sublime <PageDown>, move down one page
alt_PP           = move_up_n_pages         hot("PP") -- Similar to Sublime <PageUP>, move up one page
alt_qq           = wrap_line               hot("qq")
alt_r            = set_move_right_n_char -- Move N char right.  alt_r42<Enter> moves 42 char to the right
alt_rr           = set_move_right_n_char   hot("rr")
alt_ralt         = remove_all_leading_tabs
alt_rats         = remove_all_trailing_space
alt_ratsall      = remove_all_trailing_space_all_files
alt_relued       = relued -- reload lued script
alt_rl           = reload_file             hot("rl")
alt_rt           = set_replace_tabs -- rt0 rt4
alt_sa           = save_as                 hot("sa") -- Similar to Sublime Ctrl+Shift+S. File Save as.
alt_si           = sel_indentation         hot("si") -- Similar to Sublime Ctrl+shift+J.  Select lines with the indentation.
alt_sq           = sel_sol                 hot("sq")
alt_sb           = sel_block               hot("sb")
alt_se           = sel_eol                 hot("se")
alt_sf           = sel_sof                 hot("sf")
alt_sg           = sel_eof                 hot("sg")
alt_sm           = sel_mark_to_cursor      hot("sm") -- Similar to Sublime Ctrl+K
alt_sn           = swap_line_with_next     hot("sn")
alt_sp           = swap_line_with_prev     hot("sp")
alt_ss           = sel_toggle              hot("ss") -- Similar to Sublime <ESC>.  Toggle on/off selection.

-- alt_Saveall   = save_all
alt_Seti         = set_scope_indent -- SI2 SI3 SI4
-- alt_sw           = function() set_sel_start(); var_end(1); set_sel_end(); disp(); end hot("sw")
alt_tt           = select_tab              hot("tt")  -- Select file tab from list of open files.
alt_TT           = tab_toggle              hot("TT")  -- Toggle to previous file tab
alt_u            = set_move_up_n_lines   -- Move N lines up. alt_u42<Enter> moves up 42 lines
alt_uu           = set_move_up_n_lines    hot("uu")  -- Move N lines up. alt_u42<Enter> moves up 42 lines
alt_ui           = unindent_selected       hot("ui")
alt_ww           = move_right_n_words      hot("ww") -- Similar to Sublime Ctrl+right_arrow.  Move right one word.
alt_WW           = move_left_n_words       hot("WW") -- Similar to Sublime Ctrl+left_arrow. Move left one word.
alt_wq           = move_to_sol             hot("wq") -- Similar to Sublime <Home>. Move to Start of Line.
alt_we           = move_to_eol             hot("we") -- Similar to Sublime <End>. Move to End of Line.
alt_z            = alt_z_wrapper           hot("z")  -- Similar to Sublime Ctrl-z. Undo. After alt-z is used, ctrl-z becomes unix suspend command.


-- Setting keystroke combinations start with period ('.')
alt__period_c    = toggle_ctrl_c_abort
alt__period_ind  = toggle_auto_indent
alt__period_ctc  = set_ctrl_c_abort
alt__period_cts  = set_ctrl_s_flow_control
alt__period_ctz  = toggle_ctrl_z_suspend
alt__period_com  = set_comment
alt__period_dsp  = toggle_doublespeed
alt__period_edi  = set_edit_mode
alt__period_fch  = toggle_enable_file_changed
alt__period_num  = toggle_line_numbers
alt__period_lua  = set_lua_mode  -- Similar to Ctrl+Shift+P do anything
alt__period_mlt  = set_min_lines_from_top
alt__period_mlb  = set_min_lines_from_bot
alt__period_ps   = set_pagesize -- used by move_up_n_pages / move_down_n_pages
alt__period_sl   = toggle_status_line_on
alt__period_slr  = toggle_status_line_reverse
alt__period_tab  = set_replace_tabs
alt__period_fcs  = toggle_find_case_sensitive
alt__period_fww  = toggle_find_whole_word
alt__period_rts  = toggle_remove_trailing_spaces


alt__squote      = find
alt_p_squote     = set_paste_buffer
alt_sa_squote    = save_as

ctrl__at_        = disp              -- Called when resuming from Ctrl+Z (fg at shell prompt)
ctrl_Q           = quit_all          -- Similar to Sublime Ctrl-Q. Quit / Exit
ctrl_W           = quit_session      -- Similar to Sublime Ctrl-W. Close window.
ctrl_E           = spare
ctrl_R           = spare
ctrl_T           = spare
ctrl_Y           = redo_cmd          -- Similar to Sublime Ctrl+Y
ctrl_U           = spare

ctrl_I           = insert_tab        -- terminal <Tab> key (do not change)
ctrl_O           = open_file         -- Similar to Word Ctrl+O
ctrl_P           = open_file         -- Similar to Sublime Ctrl+P
  local sel_str, sel_sr, sel_
ctrl_A           = sel_all           -- Similar to Sublime Ctrl+A. Select All Entire File.
ctrl_S           = save_file         -- Similar to Sublime Ctrl+S. Save File.
ctrl_D           = sel_word          -- Similar to Sublime Ctrl+D (select next occurrence for multi-line)
ctrl_F           = find_forward_selected -- Similar to Sublime Ctrl+F.  If text is selected the find selected text (Similar to Sublime Ctrl+F3). alt_ff is find_forward_again. alt_FF is find_reverse_again
ctrl_G           = move_to_line      -- Similar to Sublime Ctrl+G

ctrl_H           = find_and_replace  -- Similar to Sublime Ctrl+H. Find and Replace
ctrl_J           = dont_use          -- Same as <Enter>
ctrl_K           = sel_word
ctrl_L           = sel_line          -- Similar to Sublime Ctrl+L

ctrl_Z           = undo_cmd          -- Similar to Sublime Ctrl+Z
ctrl_X           = cut_line          -- Similar to Sublime Shift+Delete
ctrl_C           = copy_line
ctrl_V           = global_paste
ctrl_B           = find_forward_again

ctrl_N           = new_file          -- alt_n
ctrl_M           = dont_use          -- Same as <Enter> Sublime Ctrl+M - Find matching Bracket

-- These keys produce escape sequences (escape is not pressed)
esc_backspace    = del_backspace
esc_insert       = toggle_overtype
esc_delete       = del_char
esc_shift_delete = cut_line
esc_up           = move_up_n_lines
esc_down         = move_down_n_lines
esc_left         = move_left_n_char
esc_right        = move_right_n_char
esc_shift_left   = word_left
esc_shift_right  = move_right_n_words
esc_home         = move_to_sol
esc_end          = move_to_eol
esc_pageup       = move_up_n_pages
esc_pagedown     = move_down_n_pages

-- These mouse actions produce escape sequences (escape is not pressed)
esc_mouse        = mouse_event
esc_pastestart   = bracket_paste_start
esc_pastestop    = bracket_paste_stop

