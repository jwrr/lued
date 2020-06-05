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

alt__caret_   = lued.del_sol                 lued.hot("^")
alt__dollar_  = cut_eol                 lued.hot("$")
alt__period_  = lued.sel_toggle              lued.hot(".")
alt__slash_   = lued.find_forward            lued.hot(",/,") -- FIXME make this regex
alt__equal_   = lued.tab_next                lued.hot("=")
alt__gt_      = lued.indent_selected         lued.hot(">")
alt__lt_      = lued.unindent_selected       lued.hot("<")
alt__plus_    = lued.sel_toggle              lued.hot(",+,")
alt_a         = lued.sel_all;                lued.hot("a")
alt_Abort     = lued.set_ctrl_c_abort
alt_AI        = lued.toggle_auto_indent;     lued.hot("AI")
alt_b         = lued.toggle_bottom           lued.hot("b")
alt_c         = lued.global_copy;            lued.hot("c")
alt_C         = lued.comment                 -- C42<enter> comments 5 lines. CO changes comment
alt_CC        = lued.comment;                lued.hot("CC")
alt_CD        = lued.cd_change_dir;          lued.hot("CD")
alt_CS        = lued.set_comment             lued.hot("CS")
alt_Dir       = lued.ls_dir                  lued.hot("Dir")
alt_DS        = lued.toggle_doublespeed      lued.hot("DS")
alt_e         = lued.del_eow                 lued.hot("e")
alt_ED        = set_edit_mode           lued.hot("ED")
alt_Efc       = set_enable_file_changed -- efc1 enables; efc0 disables
alt_f         = lued.find_forward            lued.hot("f")  -- make this non-regex
alt_Flow      = lued.set_ctrl_s_flow_control
alt_F         = lued.find_reverse            lued.hot("F")
-- alt_g      = sol;                    lued.hot("g")
alt_g         = lued.find_forward_again;     lued.hot("g")
alt_G         = lued.find_reverse_again;     lued.hot("G")
-- alt_h      = eol;                    lued.hot("h")
alt_h         = lued.find_forward_selected;  lued.hot("h")
alt_H         = lued.find_reverse_selected;  lued.hot("H")
-- alt_i      = lued.spare;                  lued.hot("i")  ####################
alt_I_squote  = indent_scope
alt_IS        = indent_scope            lued.hot("IS")
-- alt_j      = lued.find_reverse_again      lued.hot("j")
alt_j         = lued.sel_word                lued.hot("j")
alt_k         = lued.sel_word                lued.hot("k")
alt_l         = goto_line               lued.hot("l")
alt_LL        = cr_before               lued.hot("LL")
alt_LN        = toggle_line_numbers     lued.hot("LN")
alt_LS        = lued.ls_dir                  lued.hot("LS")
alt_Ls        = lued.ls_dir                  lued.hot("Ls")
alt_LU        = set_lua_mode            lued.hot("LU")
alt_M_squote  = function(name) set_mark(name); lued.disp() end
alt_M_squote  = function(name) goto_mark(name); lued.disp() end
alt_m         = lued.set_nameless_mark       lued.hot("m")
alt_MM        = lued.goto_nameless_mark_prev lued.hot("MM")
alt_Mn        = lued.goto_nameless_mark_next lued.hot("Mn")
alt_MN        = lued.goto_nameless_mark_next lued.hot("MN")
alt_Mp        = lued.goto_nameless_mark_prev lued.hot("Mp")
alt_Mlft      = lued.set_min_lines_from_top
alt_Mlfb      = lued.set_min_lines_from_bot
alt_n         = lued.new_file                lued.hot("n")
alt_Noco      = no_comment;
alt_o         = lued.open_file               lued.hot("o")
-- alt_p      = lued.spare;                  lued.hot("p") ####################
alt_OB        = function() lued.set_page_offset_percent(0.99,0) end lued.hot("OB") -- align cursor to bottom
alt_OL        = function() lued.set_page_offset_percent(0.75,0) end lued.hot("OL") -- align cursor to lower
alt_OM        = function() lued.set_page_offset_percent(0.5,0) end  lued.hot("OM") -- align cursor to middle
alt_OT        = function() lued.set_page_offset_percent(0.01,0) end lued.hot("OT") -- align cursor to top
alt_OU        = function() lued.set_page_offset_percent(0.25,0) end lued.hot("OU") -- align cursor to upper
alt_Ps        = lued.set_pagesize -- used by page_up / page_down
alt_q         = lued.quit_all                lued.hot("q")
alt_r         = lued.find_and_replace        lued.hot("r")
alt_Ralt      = remove_all_leading_tabs
alt_Rats      = remove_all_trailing_space
alt_Ratsall   = remove_all_trailing_space_all_files
alt_Relued    = lued.relued -- reload lued script
alt_Rt        = set_replace_tabs -- rt0 rt4
alt_Rts       = lued.toggle_remove_trailing_spaces
alt_s         = lued.save_file               lued.hot("s")
alt_S         = lued.save_as
alt_SA        = function() set_sel_start() sol() end
alt_Sall      = lued.search_all_files
alt_Saveall   = lued.save_all
alt_Setcase   = function() set_case_sensitive(0) end -- used for find/search
alt_Setcasei  = set_case_sensitive -- used for find/search
alt_Setco     = lued.set_comment           lued.hot("Setco")
alt_Seti      = lued.set_scope_indent -- SI2 SI3 SI4
alt_SF        = function() set_sel_start(); lued.var_end(1); set_sel_end(); lued.disp(); end lued.hot("SF")
alt_SG        = function() set_sel_start(); eol(); set_sel_end(); end lued.hot("SG")
alt__period_c = lued.toggle_ctrl_c_abort
alt__period_z = lued.toggle_ctrl_z_suspend
alt_t         = lued.select_tab            lued.hot("t")
alt_TT        = lued.tab_prev              lued.hot("TT")
alt_u         = function() lued.set_page_offset_percent(0.10,0) end   lued.hot("u")
alt_Up        = line_up -- Up23 moves up 23 lines
alt_v         = lued.global_paste          lued.hot("v")
alt_VV        = lued.paste                 lued.hot("VV")
alt_w         = lued.quit_session          lued.hot("w")
alt_x         = lued.global_cut            lued.hot("x")
alt_y         = lued.redo_cmd              lued.hot("y")
alt_z         = lued.undo_cmd              lued.hot("z")
alt__colon_w  = lued.save_file             lued.hot(":w")
--alt__lt_      = magic_left            lued.hot(">")
--alt__gt_      = magic_right           lued.hot("<")

alt__period_ind = lued.toggle_auto_indent
alt__period_ctc = lued.set_ctrl_c_abort
alt__period_cts = lued.set_ctrl_s_flow_control
alt__period_ctz = lued.toggle_ctrl_z_suspend
alt__period_com = lued.set_comment
alt__period_dsp = lued.toggle_doublespeed
alt__period_edi = set_edit_mode
alt__period_fch = set_enable_file_changed
alt__period_num = toggle_line_numbers
alt__period_lua = set_lua_mode
alt__period_mlt = lued.set_min_lines_from_top
alt__period_mlb = lued.set_min_lines_from_bot
alt__period_tab = set_replace_tabs
alt__period_cas = function() set_case_sensitive(0) end -- used for find/search
alt__period_cai = set_case_sensitive -- used for find/search
alt__period_rts = lued.toggle_remove_trailing_spaces


alt__squote   = find
alt_p_squote  = lued.set_paste_buffer
alt_sa_squote = lued.save_as

ctrl__at_      = lued.disp           -- Called when resuming from Ctrl+Z (fg at shell prompt)
ctrl_Q         = lued.quit_all          -- alt_q
ctrl_W         = lued.quit_session      -- alt_x
ctrl_E         = lued.spare
ctrl_R         = lued.find_and_replace
ctrl_T         = lued.spare

ctrl_Y         = lued.redo_cmd          -- alt_z
ctrl_U         = lued.spare
ctrl_I         = lued.insert_tab        -- terminal <Tab> key (do not change)
ctrl_O         = lued.open_file         -- alt_o
ctrl_P         = lued.spare

ctrl_A         = lued.sel_all           -- alt_a
ctrl_S         = lued.save_file         -- alt_s
ctrl_D         = lued.spare
ctrl_F         = lued.find_forward      -- alt_f
ctrl_G         = lued.find_forward_again

ctrl_H         = lued.find_forward_selected
ctrl_J         = lued.dont_use          -- Same as <Enter>
ctrl_K         = lued.sel_word
ctrl_L         = goto_line

ctrl_Z         = lued.undo_cmd          -- alt_z
ctrl_X         = lued.global_cut        -- alt_x
ctrl_C         = lued.global_copy       -- alt_c
ctrl_V         = lued.global_paste      -- alt_v
ctrl_B         = lued.spare

ctrl_N         = lued.new_file          -- alt_n
ctrl_M         = lued.dont_use          -- Same as <Enter>

-- These keys produce escape sequences (escape is not pressed)
esc_backspace    = lued.del_backspace
esc_insert       = lued.toggle_overtype
esc_delete       = lued.del_char
esc_shift_delete = lued.cut_line
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
esc_mouse        = lued.mouse_event
esc_pastestart   = lued.bracket_paste_start
esc_pastestop    = lued.bracket_paste_stop

