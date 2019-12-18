--[[
  MIT License, Copyright (c) 2018-2019 JWRR.COM, See LICENSE file
  Get LUED git clone https://github.com/jwr/lued
--]]

-- key bindings
-- set_hotkeys(",1,2,3,df,dg,dh,dd,ds,da,")
--  set_hotkeys( ",Sn,Sp,sw,v,VV,w,y,x,z,")

-- cc=comment, ii=indent, jj-join
  set_repeatables(",alt_cc,alt_CC,alt_ff,alt_FF,alt_ii,alt_jj,alt_uu,")
-- set_repeatables(",,")
--  set_non_repeatables(",alt_jj,")


-- Pressing ALT plus KEY is the same as pressing ESC followed by KEY.
-- This is a feature of terminals, not just LUED.

alt__caret_   = del_sol                 hot("^")
alt__dollar_  = del_eol                 hot("$")
-- alt__period_  = sel_toggle              hot(".")
alt__slash_   = find_forward            hot(",/,") -- FIXME make this regex
alt__minus_   = tab_prev                hot(",-,")
alt__equal_   = tab_next                hot("=")
alt__plus_    = tab_prev                hot(",+,")
alt__colon_w  = save_file               hot(":w")
alt__gt_      = halfsy_right            hot(",>,")
alt__lt_      = halfsy_left             hot(",<,")

alt_as        = align_selected1         hot("as") 
alt_A_colon_  = function() align_delimiter(":") end
alt_A_comma_  = function() align_delimiter(",") end
alt_A_equal_  = function() align_delimiter("=") end
alt_A_gt_     = function() align_delimiter(">") end
alt_A_lt_     = function() align_delimiter("<") end
alt_A_minus_  = function() align_delimiter("-") end
alt_A_semi_   = function() align_delimiter(";") end
alt_A_slash_  = function() align_delimiter("/") end
-- ================
alt_bb        = toggle_bottom           hot("bb")
alt_cc        = comment                 hot("cc")
alt_CC        = uncomment               hot("CC")
alt_cd        = cd_change_dir;          hot("cd")
alt_cs        = set_comment             hot("cs")
alt_da        = del_sol                 hot("da")
alt_de        = del_eol                 hot("de")
alt_dd        = del_word                hot("dd")
alt_df        = del_sof                 hot("df")
alt_dg        = del_eof                 hot("dg")
alt_dh        = del_all                 hot("dh")
alt_dw        = del_eow                 hot("dw")
alt_DS        = toggle_doublespeed      hot("DS")
alt_ED        = set_edit_mode           hot("ED")
alt_ff        = find_forward_again;     hot("ff")
alt_FA        = search_all_files;       hot("FA")
alt_FF        = find_reverse_again;     hot("FF")
alt_hh        = replace_again           hot("hh")
alt_help      = open_file_bindings      hot("help")
alt_ii        = indent_selected         hot("ii")
alt_is        = set_indent_size         hot("is")
alt_jj        = join_lines              hot("jj")
alt_kl        = sel_to_lower            hot("kl")
alt_ku        = sel_to_upper            hot("ku")

alt_ld        = move_line_down          hot("ld")
alt_ll        = insert_cr_after         hot("ll") -- similar to vi's o
alt_lk        = insert_cr_before        hot("lk") -- similar to vi's O
alt_ln        = toggle_line_numbers     hot("ln")
alt_lu        = move_line_up            hot("lu")
alt_ls        = ls_dir                  hot("ls")
alt_LU        = set_lua_mode            hot("LU")
alt_M_squote  = function(name) set_mark(name); disp() end
alt_M_squote  = function(name) goto_mark(name); disp() end
alt_mm        = set_nameless_mark       hot("mm")
alt_mp        = goto_nameless_mark_prev hot("mp")
alt_mn        = goto_nameless_mark_next hot("mn")
alt_nn        = new_file                hot("nn")
alt_qq        = wrap_line               hot("qq")
alt_ralt      = remove_all_leading_tabs
alt_rats      = remove_all_trailing_space
alt_ratsall   = remove_all_trailing_space_all_files
alt_relued    = relued -- reload lued script
alt_rl        = reload_file hot("rl")
alt_Rt        = set_replace_tabs -- rt0 rt4
alt_Rts       = toggle_remove_trailing_spaces
alt_ss        = sel_toggle hot("ss")
alt_S         = save_as
alt_sa        = sel_sol    hot("sa")
alt_sb        = sel_block  hot("sb")
alt_se        = sel_eol    hot("se")
alt_sf        = sel_sof    hot("sf")
alt_sg        = sel_eof    hot("sg")
alt_sh        = sel_all    hot("sh")

-- alt_Saveall   = save_all
alt_Seti      = set_scope_indent -- SI2 SI3 SI4
alt_sw        = function() set_sel_start(); var_end(1); set_sel_end(); disp(); end hot("sw")
alt_tt        = select_tab hot("tt")
alt_TT        = tab_toggle              hot("TT")
alt_uu        = unindent_selected       hot("uu")
alt_Up        = line_up -- Up23 moves up 23 lines
alt_WW        = del_sow hot("WW")
alt_x         = global_cut            hot("x")
alt_y         = redo_cmd              hot("y")
alt_z         = function() set_ctrl_z_suspend(true); undo_cmd() end  hot("z")
alt_ZZ        = recenter hot("ZZ")

alt__period_c   = toggle_ctrl_c_abort
alt__period_ind = toggle_auto_indent
alt__period_ctc = set_ctrl_c_abort
alt__period_cts = set_ctrl_s_flow_control
alt__period_ctz = toggle_ctrl_z_suspend
alt__period_com = set_comment
alt__period_dsp = toggle_doublespeed
alt__period_edi = set_edit_mode
alt__period_fch = toggle_enable_file_changed
alt__period_num = toggle_line_numbers
alt__period_lua = set_lua_mode
alt__period_mlt = set_min_lines_from_top
alt__period_mlb = set_min_lines_from_bot
alt__period_ps  = set_pagesize -- used by page_up / page_down

alt__period_sl  = toggle_status_line_on
alt__period_slr = toggle_status_line_reverse
alt__period_tab = set_replace_tabs
alt__period_fcs = toggle_find_case_sensitive
alt__period_fww = toggle_find_whole_word
alt__period_rts = toggle_remove_trailing_spaces


alt__squote   = find
alt_p_squote  = set_paste_buffer
alt_sa_squote = save_as

ctrl__at_      = disp           -- Called when resuming from Ctrl+Z (fg at shell prompt)
ctrl_Q         = quit_all          -- alt_q
ctrl_W         = quit_session      -- alt_x
ctrl_E         = eol
ctrl_R         = spare
ctrl_T         = spare

ctrl_Y         = redo_cmd          -- alt_z
ctrl_U         = spare

ctrl_I         = insert_tab        -- terminal <Tab> key (do not change)
ctrl_O         = open_file         -- alt_o
ctrl_P         = select_tab

ctrl_A         = sol               -- alt_a
ctrl_S         = save_file         -- alt_s
ctrl_D         = sel_word
ctrl_F         = find_forward_selected      -- alt_f find_forward_again
ctrl_G         = goto_line

ctrl_H         = find_and_replace
ctrl_J         = dont_use          -- Same as <Enter>
ctrl_K         = sel_word
ctrl_L         = sel_line

ctrl_Z         = undo_cmd          -- alt_z
ctrl_X         = cut_line          -- global_cut
ctrl_C         = copy_line
ctrl_V         = global_paste
ctrl_B         = spare

ctrl_N         = new_file          -- alt_n
ctrl_M         = dont_use          -- Same as <Enter>

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
esc_mouse        = mouse_event
esc_pastestart   = bracket_paste_start
esc_pastestop    = bracket_paste_stop

