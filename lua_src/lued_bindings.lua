--[[
  MIT License, Copyright (c) 2018-2019 JWRR.COM, See LICENSE file
  Get LUED git clone https://github.com/jwr/lued
--]]

-- key bindings
-- set_hotkeys(",1,2,3,df,dg,dh,dd,ds,da,")
  set_hotkeys( ",Sn,Sp,sw,r,t,v,VV,w,y,x,z,")

  set_repeatables(",ctrl_F,")
-- set_repeatables(",,")
  set_non_repeatables(",alt_d,alt_da,alt_dg,")

-- Pressing ALT plus KEY is the same as pressing ESC followed by KEY.
-- This is a feature of terminals, not just LUED.

alt__caret_   = del_sol                 hot("^")
alt__dollar_  = cut_eol                 hot("$")
-- alt__period_  = sel_toggle              hot(".")
alt__slash_   = find_forward            hot(",/,") -- FIXME make this regex
alt__equal_   = tab_next                hot("=")
alt__gt_      = indent_selected         hot(">")
alt__lt_      = unindent_selected       hot("<")
alt__plus_    = sel_toggle              hot(",+,")
alt__colon_w  = save_file               hot(":w")
-- alt__comma_   = magic_left              hot(",")
-- alt__period_  = magic_right             hot(",.,")


alt_a         = sol hot("a") -- align_delimiter
alt_Align     = align_selected
alt_A_colon_  = function() align_delimiter(":") end
alt_A_comma_  = function() align_delimiter(",") end
alt_A_equal_  = function() align_delimiter("=") end
alt_A_gt_     = function() align_delimiter(">") end
alt_A_lt_     = function() align_delimiter("<") end
alt_A_minus_  = function() align_delimiter("-") end
alt_A_semi_   = function() align_delimiter(";") end
alt_A_slash_  = function() align_delimiter("/") end
-- ================
alt_Abort     = set_ctrl_c_abort
alt_AI        = toggle_auto_indent;     hot("AI")
alt_BB        = toggle_bottom           hot("BB")
alt_C         = comment                 -- C42<enter> comments 5 lines. CO changes comment
alt_CC        = comment;                hot("CC")
alt_CD        = cd_change_dir;          hot("CD")
alt_CS        = set_comment             hot("CS")
alt_d         = word_right hot("d") -- cut_line                hot("d")
alt_D_dollar_ = function() cut_line( get_numlines() ) end -- delete lines to end of file
alt_Dir       = ls_dir                  hot("Dir")
alt_DS        = toggle_doublespeed      hot("DS")
alt_e         = magic_right hot("e") -- del_eow                 hot("e")
alt_EE        = del_eow hot("EE")
alt_ED        = set_edit_mode           hot("ED")
alt_f         = find_forward_again;     hot("f")
alt_FA        = search_all_files;       hot("FA")
alt_FF        = find_reverse_again;     hot("FF")
-- alt_h      = eol;                    hot("h")
alt_HH        = replace_again           hot("HH")
alt_Help      = open_file_bindings      hot("Help")
-- alt_i      = spare;                  hot("i")  ####################
alt_I_squote  = indent_scope
alt_IS        = indent_scope            hot("IS")
-- alt_j      = find_reverse_again      hot("j")
alt_j         = join_lines              hot("j")
alt_KC        = comment                 hot("KC")
alt_KK        = del_eol                 hot("KK")
alt_KJ        = del_sol                 hot("KJ")
alt_KL        = sel_to_lower            hot("KL")
alt_KU        = sel_to_upper            hot("KU")

alt_LL        = insert_cr_after         hot("LL") -- similar to vi's o
alt_LK        = insert_cr_before        hot("LK") -- similar to vi's O
alt_LN        = toggle_line_numbers     hot("LN")
alt_LS        = ls_dir                  hot("LS")
alt_Ls        = ls_dir                  hot("Ls")
alt_LU        = set_lua_mode            hot("LU")
alt_M_squote  = function(name) set_mark(name); disp() end
alt_M_squote  = function(name) goto_mark(name); disp() end
alt_m         = set_nameless_mark       hot("m")
alt_MM        = goto_nameless_mark_prev hot("MM")
alt_Mn        = goto_nameless_mark_next hot("Mn")
alt_MN        = goto_nameless_mark_next hot("MN")
alt_MP        = goto_nameless_mark_prev hot("MP")
alt_Mlft      = set_min_lines_from_top
alt_Mlfb      = set_min_lines_from_bot
alt_n         = new_file                hot("n")
alt_Noco      = no_comment
-- alt_p      = spare                   hot("p") ####################
alt_OB        = function() set_page_offset_percent(0.99,0) end hot("OB") -- align cursor to bottom
alt_OL        = function() set_page_offset_percent(0.75,0) end hot("OL") -- align cursor to lower
alt_OM        = function() set_page_offset_percent(0.5,0) end  hot("OM") -- align cursor to middle
alt_OT        = function() set_page_offset_percent(0.01,0) end hot("OT") -- align cursor to top
alt_OU        = function() set_page_offset_percent(0.25,0) end hot("OU") -- align cursor to upper
alt_Ps        = set_pagesize -- used by page_up / page_down
alt_q         = wrap_line               hot("q")
alt_r         = page_up hot("r") -- reindent_selected       hot("r")
alt_Ralt      = remove_all_leading_tabs
alt_Rats      = remove_all_trailing_space
alt_Ratsall   = remove_all_trailing_space_all_files
alt_Relued    = relued -- reload lued script
alt_Reopen    = reopen_file
alt_RR        = tab_prev              hot("RR")
alt_Rt        = set_replace_tabs -- rt0 rt4
alt_Rts       = toggle_remove_trailing_spaces
alt_s         = word_left hot("s") -- save_file               hot("s")
alt_S         = save_as
alt_SA        = function() set_sel_start() sol() end
alt_Sall      = search_all_files
alt_Saveall   = save_all
alt_Setco     = set_comment           hot("Setco")
alt_Seti      = set_scope_indent -- SI2 SI3 SI4
alt_SF        = function() set_sel_start(); var_end(1); set_sel_end(); disp(); end hot("SF")
alt_SG        = function() set_sel_start(); eol(); set_sel_end() end hot("SG")
alt_t         = select_tab hot("t")
alt_TT        = tab_toggle              hot("TT")
alt_u         = recenter hot("u") -- function() set_page_offset_percent(0.10,0) end   hot("u")
alt_Up        = line_up -- Up23 moves up 23 lines
alt_v         = page_down hot("v") -- global_paste          hot("v")
alt_VV        = paste                 hot("VV")
alt_w         = magic_left hot("w") -- quit_session          hot("w")
alt_WW        = del_sow hot("WW")
alt_x         = global_cut            hot("x")
alt_y         = redo_cmd              hot("y")
alt_YY        = tab_next              hot("YY")
alt_z         = function() set_ctrl_z_suspend(true); undo_cmd() end  hot("z")

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
ctrl_U         = recenter

ctrl_I         = insert_tab        -- terminal <Tab> key (do not change)
ctrl_O         = open_file         -- alt_o
ctrl_P         = select_tab

ctrl_A         = sel_all           -- alt_a
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

