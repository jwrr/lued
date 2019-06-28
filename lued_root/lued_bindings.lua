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

-- key bindings
-- set_hotkeys(",1,2,3,df,dg,dh,dd,ds,da,")
  set_hotkeys( ",Sn,Sp,sw,r,t,v,VV,w,y,x,z,")

  set_repeatables(",ctrl_F,")
-- set_repeatables(",,")
  set_non_repeatables(",alt_d,alt_da,alt_dg,")

-- alt-
-- esc-

alt__caret_   = del_sol                 hot("^")
alt__dollar_  = cut_eol                 hot("$")
alt__period_  = sel_toggle              hot(".")
alt__slash_   = find_forward            hot(",/,") -- FIXME make this regex
alt__equal_   = tab_next                hot("=")
alt__gt_      = indent_selected         hot(">")
alt__lt_      = unindent_selected       hot("<")
alt__plus_    = sel_toggle              hot(",+,")
alt_A         = align_selected
alt_a         = align_delimiter
alt_a_colon_  = function() align_delimiter(":") end
alt_a_comma_  = function() align_delimiter(",") end
alt_a_equal_  = function() align_delimiter("=") end
alt_a_gt_     = function() align_delimiter(">") end
alt_a_lt_     = function() align_delimiter("<") end
alt_a_minus_  = function() align_delimiter("-") end
alt_a_semi_   = function() align_delimiter(";") end
alt_a_slash_  = function() align_delimiter("/") end

alt_Abort     = set_ctrl_c_abort
alt_AI        = toggle_auto_indent;     hot("AI")
alt_b         = toggle_bottom           hot("b")
alt_c         = global_copy;            hot("c")
alt_C         = comment                 -- C42<enter> comments 5 lines. CO changes comment
alt_CC        = comment;                hot("CC")
alt_CD        = cd_change_dir;          hot("CD")
alt_CS        = set_comment             hot("CS")
alt_d         = cut_line                hot("d")
alt_D         = cut_line -- Alt+D42<enter> deletes 42 lines. Alt+D$ deletes to end of file
alt_D_dollar_ = function() cut_line( get_numlines() ) end -- delete lines to end of file
alt_Dir       = ls_dir                  hot("Dir")
alt_DS        = toggle_doublespeed      hot("DS")
alt_e         = del_eow                 hot("e")
alt_ED        = set_edit_mode           hot("ED")
alt_Efc       = set_enable_file_changed -- efc1 enables; efc0 disables
alt_f         = find_forward_again      hot("f")  -- make this non-regex
alt_F         = find_reverse_again      hot("F")
alt_Flow      = set_ctrl_s_flow_control
-- alt_g      = sol;                    hot("g")
alt_g         = find_forward_again;     hot("g")
alt_G         = find_reverse_again;     hot("G")
-- alt_h      = eol;                    hot("h")
alt_h         = find_forward_selected;  hot("h")
alt_H         = find_reverse_selected;  hot("H")
-- alt_i      = spare;                  hot("i")  ####################
alt_I_squote  = indent_scope
alt_IS        = indent_scope            hot("IS")
-- alt_j      = find_reverse_again      hot("j")
alt_j         = join_lines              hot("j")
--alt_k       = sel_word                hot("k")
alt_kc        = comment                 hot("kc")
alt_kk        = del_eol                 hot("kk")
alt_kj        = del_sol                 hot("kj")
alt_kl        = sel_to_lower            hot("kl")
alt_ku        = sel_to_upper            hot("ku")

alt_ll        = insert_cr_after         hot("ll") -- similar to vi's o
alt_lk        = insert_cr_before        hot("lk") -- similar to vi's O
alt_LL        = cr_before               hot("LL")
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
alt_Mp        = goto_nameless_mark_prev hot("Mp")
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
alt_r         = reindent_selected       hot("r")
alt_Ralt      = remove_all_leading_tabs
alt_Rats      = remove_all_trailing_space
alt_Ratsall   = remove_all_trailing_space_all_files
alt_Relued    = relued -- reload lued script
alt_Rt        = set_replace_tabs -- rt0 rt4
alt_Rts       = toggle_remove_trailing_spaces
alt_s         = save_file               hot("s")
alt_S         = save_as
alt_SA        = function() set_sel_start() sol() end
alt_Sall      = search_all_files
alt_Saveall   = save_all
alt_Setcase   = function() set_case_sensitive(0) end -- used for find/search
alt_Setcasei  = set_case_sensitive -- used for find/search
alt_Setco     = set_comment           hot("Setco")
alt_Seti      = set_scope_indent -- SI2 SI3 SI4
alt_SF        = function() set_sel_start(); var_end(1); set_sel_end(); disp(); end hot("SF")
alt_SG        = function() set_sel_start(); eol(); set_sel_end(); end hot("SG")
alt__period_c = toggle_ctrl_c_abort
alt__period_z = toggle_ctrl_z_suspend
alt_t         = select_tab            hot("t")
alt_TT        = tab_prev              hot("TT")
alt_u         = function() set_page_offset_percent(0.10,0) end   hot("u")
alt_Up        = line_up -- Up23 moves up 23 lines
alt_v         = global_paste          hot("v")
alt_VV        = paste                 hot("VV")
alt_w         = quit_session          hot("w")
alt_x         = global_cut            hot("x")
alt_y         = redo_cmd              hot("y")
alt_z         = undo_cmd              hot("z")
alt__colon_w  = save_file             hot(":w")
--alt__lt_      = magic_left            hot(">")
--alt__gt_      = magic_right           hot("<")

alt__period_ind = toggle_auto_indent
alt__period_ctc = set_ctrl_c_abort
alt__period_cts = set_ctrl_s_flow_control
alt__period_ctz = toggle_ctrl_z_suspend
alt__period_com = set_comment
alt__period_dsp = toggle_doublespeed
alt__period_edi = set_edit_mode
alt__period_fch = set_enable_file_changed
alt__period_num = toggle_line_numbers
alt__period_lua = set_lua_mode
alt__period_mlt = set_min_lines_from_top
alt__period_mlb = set_min_lines_from_bot
alt__period_tab = set_replace_tabs
alt__period_cas = function() set_case_sensitive(0) end -- used for find/search
alt__period_cai = set_case_sensitive -- used for find/search
alt__period_rts = toggle_remove_trailing_spaces


alt__squote   = find
alt_p_squote  = set_paste_buffer
alt_sa_squote = save_as

ctrl__at_      = disp           -- Called when resuming from Ctrl+Z (fg at shell prompt)
ctrl_Q         = quit_all          -- alt_q
ctrl_W         = quit_session      -- alt_x
ctrl_E         = spare
ctrl_R         = spare
ctrl_T         = spare

ctrl_Y         = redo_cmd          -- alt_z
ctrl_U         = spare
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
ctrl_X         = cut_line          -- global_cut        -- alt_x
ctrl_C         = copy_line         -- alt_c
ctrl_V         = global_paste      -- alt_v
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

