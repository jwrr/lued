--[[
  MIT License, Copyright (c) 2018-2019 JWRR.COM, See LICENSE file
  Get LUED git clone https://github.com/jwr/lued
--]]

-- key bindings
-- set_hotkeys(",1,2,3,df,dg,dh,dd,ds,da,")
--  set_hotkeys( ",Sn,Sp,sw,v,VV,w,y,x,z,")

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


alt_aa        = sel_all hot("aa"); hot("aa")
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
alt_bb        = toggle_bottom           hot("bb")
alt_cd        = cd_change_dir;          hot("cd")
alt_cs        = set_comment             hot("cs")
-- alt_d         = word_right hot("d") -- cut_line                hot("d")
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
alt_jj        = join_lines              hot("jj")
alt_kc        = comment                 hot("kc")
alt_kk        = del_eol                 hot("kk")
alt_kj        = del_sol                 hot("kj")
alt_kl        = sel_to_lower            hot("kl")
alt_ku        = sel_to_upper            hot("ku")

alt_ll        = insert_cr_after         hot("ll") -- similar to vi's o
alt_lk        = insert_cr_before        hot("lk") -- similar to vi's O
alt_ln        = toggle_line_numbers     hot("ln")
alt_ls        = ls_dir                  hot("ls")
alt_lua       = set_lua_mode            hot("lua")
alt_M_squote  = function(name) set_mark(name); disp() end
alt_M_squote  = function(name) goto_mark(name); disp() end
alt_mm        = set_nameless_mark       hot("mm")
alt_mp        = goto_nameless_mark_prev hot("mp")
alt_mn        = goto_nameless_mark_next hot("mn")
alt_n         = new_file                hot("n")
alt_Noco      = no_comment
-- alt_p      = spare                   hot("p") ####################
alt_ob        = function() set_page_offset_percent(0.99,0) end hot("ob") -- align cursor to bottom
alt_ol        = function() set_page_offset_percent(0.75,0) end hot("ol") -- align cursor to lower
alt_om        = function() set_page_offset_percent(0.5,0) end  hot("om") -- align cursor to middle
alt_ot        = function() set_page_offset_percent(0.01,0) end hot("ot") -- align cursor to top
alt_ou        = function() set_page_offset_percent(0.25,0) end hot("ou") -- align cursor to upper
alt_qq        = wrap_line               hot("qq")
-- alt_r         = page_up  -- reindent_selected       
alt_ralt      = remove_all_leading_tabs
alt_rats      = remove_all_trailing_space
alt_ratsall   = remove_all_trailing_space_all_files
alt_relued    = relued -- reload lued script
alt_reopen    = reopen_file
alt_Rt        = set_replace_tabs -- rt0 rt4
alt_Rts       = toggle_remove_trailing_spaces
-- alt_s         = word_left hot("s") -- save_file               hot("s")
alt_ss        = sel_toggle hot("ss")
alt_S         = save_as
alt_SA        = function() set_sel_start() sol() end
alt_Saveall   = save_all
alt_Setco     = set_comment           hot("Setco")
alt_Seti      = set_scope_indent -- SI2 SI3 SI4
alt_SF        = function() set_sel_start(); var_end(1); set_sel_end(); disp(); end hot("SF")
alt_SG        = function() set_sel_start(); eol(); set_sel_end() end hot("SG")
alt_tt        = select_tab hot("tt")
alt_tr        = tab_prev              hot("tr")
alt_ty        = tab_next              hot("ty")
alt_TT        = tab_toggle              hot("TT")
alt_u         = recenter hot("u") -- function() set_page_offset_percent(0.10,0) end   hot("u")
alt_Up        = line_up -- Up23 moves up 23 lines
alt_w         = magic_left hot("w") -- quit_session          hot("w")
alt_WW        = del_sow hot("WW")
alt_x         = global_cut            hot("x")
alt_y         = redo_cmd              hot("y")
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
ctrl_U         = recenter

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

