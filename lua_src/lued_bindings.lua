--[[
  MIT License, Copyright (c) 2018-2019 JWRR.COM, See LICENSE file
  Get LUED: git clone https://github.com/jwr/lued
--]]

-- key bindings
-- set_hotkeys(",1,2,3,df,dg,dh,dd,ds,da,")
--  set_hotkeys( ",Sn,Sp,sw,v,VV,w,y,x,z,")

  set_repeatables(",alt_aa,alt_as,alt_bd,alt_bu,alt_cc,alt_cr,alt_ff,alt_FF,alt_ii,alt_jj,alt_uu,")
  set_repeatables(",alt_pk,alt_pl,alt_sn,alt_sp,")

-- set_repeatables(",,")
--  set_non_repeatables(",alt_jj,")


-- Pressing ALT plus KEY is the same as pressing ESC followed by KEY.
-- This is a feature of terminals, not just LUED.

alt__caret_      = del_sol                 hot("^")
alt__dollar_     = del_eol                 hot("$")
-- alt__period_  = sel_toggle              hot(".")
alt__slash_      = find_forward            hot(",/,") -- FIXME make this regex
alt__minus_      = tab_prev                hot(",-,")
alt__equal_      = tab_next                hot("=")
alt__plus_       = tab_prev                hot(",+,")
alt__colon_w     = save_file               hot(":w")
alt__gt_         = halfsy_right            hot(",>,")
alt__lt_         = halfsy_left             hot(",<,")


alt_aa           = align_delimiter_selected hot("aa") 
alt_as           = align_selected          hot("as") 
-- alt_a_colon_  = function() align_delimiter_selected(":") end hot("a:")
-- alt_a_comma_  = function() align_delimiter_selected(",") end -- hot("a,")
-- alt_a_equal_  = function() align_delimiter_selected("=") end hot("a=")
-- alt_a_gt_     = function() align_delimiter_selected(">") end hot("a>")
-- alt_a_lt_     = function() align_delimiter_selected("<") end hot("a<")
-- alt_a_minus_  = function() align_delimiter_selected("-") end hot("a-")
-- alt_a_semi_   = function() align_delimiter_selected(";") end hot("a;")
-- alt_a_slash_  = function() align_delimiter_selected("/") end hot("a/")
-- ================
alt_bb           = toggle_bottom              hot("bb")
alt_bd           = bubble_selected_lines_down hot("bd") -- line sinks to bottom of file
alt_bu           = bubble_selected_lines_up   hot("bu") -- line floats to top of file
alt_cc           = comment_selected        hot("cc")
alt_cr           = uncomment_selected      hot("cr") -- comment remove
alt_cd           = cd_change_dir;          hot("cd")
alt_cs           = set_comment             hot("cs")
-- alt_d            = del_char   -- delete N characters. alt_d8<Enter> deletes 8 char
alt_d            = line_down   -- Move N lines down. alt_d42<Enter> moves down 42 lines
alt_da           = del_sol                 hot("da")
alt_de           = del_eol                 hot("de")
alt_dd           = del_word                hot("dd")
alt_df           = del_sof                 hot("df")
alt_dg           = del_eof                 hot("dg")
alt_dh           = del_all                 hot("dh")
alt_ds           = del_spaces_selected     hot("ds")
alt_dw           = del_eow                 hot("dw")
alt_ed           = set_edit_mode           hot("ed")
alt_fa           = search_all_files;       hot("fa")  -- search all open files for match
alt_ff           = find_forward_again;     hot("ff")
alt_FF           = find_reverse_again;     hot("FF")
alt_hh           = replace_again           hot("hh")
alt_he           = open_file_bindings      hot("he")
alt_ii           = indent_selected         hot("ii")
alt_ir           = reindent_selected       hot("ir")
alt_is           = set_indent_size         hot("is")
alt_jj           = join_lines              hot("jj")
alt_kl           = sel_to_lower            hot("kl")
alt_ku           = sel_to_upper            hot("ku")
alt_l            = char_left -- Move N char left.  alt_l42<Enter> moves 42 char to the left
alt_ll           = insert_cr_after         hot("ll") -- similar to vi's o
alt_lk           = insert_cr_before        hot("lk") -- similar to vi's O
alt_ln           = toggle_line_numbers     hot("ln") -- show line numbers
alt_ls           = ls_dir                  hot("ls") -- unix ls command. dos dir command
alt_LU           = set_lua_mode            hot("LU")
alt_M_squote     = function(name) set_mark(name); disp() end
alt_M_squote     = function(name) goto_mark(name); disp() end
alt_mm           = set_nameless_mark       hot("mm")
alt_mp           = goto_nameless_mark_prev hot("mp")
alt_mn           = goto_nameless_mark_next hot("mn")
alt_nn           = new_file                hot("nn")
alt_pl           = paste_line_after        hot("pl")
alt_pk           = paste_line_before       hot("pk")
alt_qq           = wrap_line               hot("qq")
alt_r            = char_right -- Move N char right.  alt_r42<Enter> moves 42 char to the right
alt_ralt         = remove_all_leading_tabs
alt_rats         = remove_all_trailing_space
alt_ratsall      = remove_all_trailing_space_all_files
alt_relued       = relued -- reload lued script
alt_rl           = reload_file             hot("rl")
alt_rt           = set_replace_tabs -- rt0 rt4
alt_SA           = save_as                 hot("SA")
alt_sa           = sel_sol                 hot("sa")
alt_sb           = sel_block               hot("sb")
alt_se           = sel_eol                 hot("se")
alt_sf           = sel_sof                 hot("sf")
alt_sg           = sel_eof                 hot("sg")
alt_sh           = sel_all                 hot("sh")
alt_ss           = sel_toggle              hot("ss")
alt_sn           = swap_line_with_next     hot("sn")
alt_sp           = swap_line_with_prev     hot("sp")

-- alt_Saveall   = save_all
alt_Seti         = set_scope_indent -- SI2 SI3 SI4
-- alt_sw           = function() set_sel_start(); var_end(1); set_sel_end(); disp(); end hot("sw")
alt_tt           = select_tab              hot("tt")  -- Select file tab from list of open files
alt_TT           = tab_toggle              hot("TT")  -- Toggle to previous file tab
alt_u            = line_up   -- Move N lines up. alt_u42<Enter> moves up 42 lines
alt_uu           = unindent_selected       hot("uu")
alt_WW           = del_sow hot("WW")
alt_x            = global_cut              hot("x")
alt_y            = redo_cmd                hot("y")
alt_z            = alt_z_wrapper           hot("z")
alt_ZZ           = recenter                hot("ZZ")


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
alt__period_lua  = set_lua_mode
alt__period_mlt  = set_min_lines_from_top
alt__period_mlb  = set_min_lines_from_bot
alt__period_ps   = set_pagesize -- used by page_up / page_down
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
ctrl_Q           = quit_all          -- alt_q
ctrl_W           = quit_session      -- alt_x
ctrl_E           = eol
ctrl_R           = spare
ctrl_T           = spare
ctrl_Y           = redo_cmd          -- alt_z
ctrl_U           = spare

ctrl_I           = insert_tab        -- terminal <Tab> key (do not change)
ctrl_O           = open_file         -- alt_o
ctrl_P           = select_tab

ctrl_A           = sol               -- alt_a
ctrl_S           = save_file         -- alt_s
ctrl_D           = sel_word
ctrl_F           = find_forward_selected -- alt_f find_forward_again
ctrl_G           = goto_line

ctrl_H           = find_and_replace
ctrl_J           = dont_use          -- Same as <Enter>
ctrl_K           = sel_word
ctrl_L           = sel_line

ctrl_Z           = undo_cmd          -- alt_z
ctrl_X           = cut_line          -- global_cut
ctrl_C           = copy_line
ctrl_V           = global_paste
ctrl_B           = spare

ctrl_N           = new_file          -- alt_n
ctrl_M           = dont_use          -- Same as <Enter>

-- These keys produce escape sequences (escape is not pressed)
esc_backspace    = del_backspace
esc_insert       = toggle_overtype
esc_delete       = del_char
esc_shift_delete = cut_line
esc_up           = line_up
esc_down         = line_down
esc_left         = char_left
esc_right        = char_right
esc_shift_left   = word_left
esc_shift_right  = word_right
esc_home         = sol
esc_end          = eol
esc_pageup       = page_up
esc_pagedown     = page_down

-- These mouse actions produce escape sequences (escape is not pressed)
esc_mouse        = mouse_event
esc_pastestart   = bracket_paste_start
esc_pastestop    = bracket_paste_stop

