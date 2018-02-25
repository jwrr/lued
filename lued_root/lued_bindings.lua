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

alt__period_ = sel_toggle;          hot(",.,")
alt__slash_ =  find_forward;        hot(",/,")
alt_a =     sel_all;                hot("a")
alt_Abort = set_ctrl_c_abort
alt_AI =    toggle_auto_indent;     hot("AI")
alt_b =     select_open_file;       hot("b")
alt_B =     buffer_prev;            hot("B")
alt_c =     global_copy;            hot("c")
alt_C =     copy_line                          -- C5 copies 5 lines to paste buffer
alt_CC =    copy_line2;             hot("CC")
alt_Cd =    change_dir;             hot("Cd")
alt_CD =    change_dir;             hot("CD")
alt_Ci =    function() set_case_sensitive(0) end -- used for find/search
alt_Co =    comment; -- Alt_Co comments line; Alt_Co5 comments 5 lines; Alt_Co(1,"#") sets comment marker
alt_Cs =    set_case_sensitive -- used for find/search
alt_D =     del_line -- Alt+d42<enter> deletes 42 lines. Alt+D$ deletes to end of file
alt_D_dollar_ = function() del_line( get_numlines() ) end hot("D$") -- delete lines to end of file
alt_Da =    del_sol
alt_Dir =   ls_dir                  hot("Dir")
-- FIXME alt_DS =  del_sow
alt_d =     del_line                hot("d")
alt_e =     del_eow                 hot("e")
alt_DG =    cut_eol                 hot("DG")
alt_ED =    set_edit_mode           hot("ED")
alt_Efc =   set_enable_file_changed -- efc1 enables; efc0 disables
--alt_EE =    exit_session -- save and close current session
--alt_EX =    exit_all -- save and close all sessions
alt_f =     find_forward            hot("f")
alt_Flow =  set_ctrl_s_flow_control
alt_FR =    find_reverse            hot("FR")
alt_g =     comment;                hot("g")
alt_I_squote = indent_scope
alt_IS =    indent_scope            hot("IS")
alt_j =     find_reverse_again      hot("j")
alt_k =     sel_word                hot("k")
alt_l =     find_forward_again      hot("l")
alt_LN =    toggle_line_numbers     hot("LN")
alt_LS =    ls_dir                  hot("LS")
alt_Ls =    ls_dir                  hot("Ls")
alt_LU =    set_lua_mode            hot("LU")
alt_M_squote = function(name) set_mark(name); disp() end
alt_M_squote = function(name) goto_mark(name); disp() end
alt_m =     set_nameless_mark       hot("m")
alt_MM =    goto_nameless_mark_prev hot("MM")
alt_Mn =    goto_nameless_mark_next hot("Mn")
alt_MN =    goto_nameless_mark_next hot("MN")
alt_Mp =    goto_nameless_mark_prev hot("Mp")
alt_Mlft =  set_min_lines_from_top
alt_Mlfb =  set_min_lines_from_bot
alt_n =     new_file                hot("n")
alt_Noco =  no_comment;
alt_o =     open_file               hot("o")
alt_p =     ls_dir                  hot("p")
alt_OB =    function() set_page_offset_percent(0.99,0) end hot("OB") -- align cursor to bottom
alt_OL =    function() set_page_offset_percent(0.75,0) end hot("OL") -- align cursor to lower
alt_OM =    function() set_page_offset_percent(0.5,0) end  hot("OM") -- align cursor to middle
alt_OT =    function() set_page_offset_percent(0.01,0) end hot("OT") -- align cursor to top
alt_OU =    function() set_page_offset_percent(0.25,0) end hot("OU") -- align cursor to upper
--alt_oo =  cr_before   OO = cr_after
alt_Ps =    set_pagesize -- used by page_up / page_down
alt_q =     quit_all                hot("q")
alt_r =     find_and_replace        hot("r")
alt_Ralt =  remove_all_leading_tabs
alt_Rats =  remove_all_trailing_space
alt_Ratsall = remove_all_trailing_space_all_files
alt_Relued =  relued -- reload lued script
alt_Rt =    set_replace_tabs -- rt0 rt4
alt_Rts =   toggle_remove_trailing_spaces
alt_s =     save_file               hot("s")
alt_SA =    function() set_sel_start(); sol(); end hot("SA")
alt_Sall =  search_all_files
alt_Saveall = save_all
alt_SI =    set_scope_indent -- Si2 Si3 Si4
alt_SN =    session_next            hot("SN")
alt_SF =    function() set_sel_start(); var_end(1); set_sel_end(); disp(); end hot("SF")
alt_SG =    function() set_sel_start(); eol(); set_sel_end(); end hot("SG")
alt_Suspend = set_ctrl_z_suspend
alt_t =     toggle_top            hot("t")
alt_u =     function() set_page_offset_percent(0.10,0) end                hot("u")
alt_Up =    line_up -- Up23 moves up 23 lines
alt_v =     global_paste          hot("v")
alt_VV =    paste                 hot("VV")
alt_w =     quit_session          hot("w")
alt_x =     global_cut            hot("x")
alt_y =     redo_cmd              hot("y")
alt_z =     undo_cmd              hot("z")
alt__colon_w = save_file          hot(":w")

alt__squote = find
alt_p_squote = set_paste_buffer
alt_sa_squote = save_as

ctrl__at_ = disp           -- Called when resuming from Ctrl+Z (fg at shell prompt)
ctrl_Q = quit_all          -- alt_q
ctrl_W = quit_session      -- alt_x
ctrl_E = spare
ctrl_R = spare
ctrl_T = spare

ctrl_Y = redo_cmd          -- alt_z
ctrl_U = spare
ctrl_I = insert_tab        -- terminal <Tab> key (do not change)
ctrl_O = open_file         -- alt_o
ctrl_P = spare

ctrl_A = sel_all           -- alt_a
ctrl_S = save_file         -- alt_s
ctrl_D = spare
ctrl_F = find_forward      -- alt_f
ctrl_G = spare

ctrl_H = spare
ctrl_J = dont_use          -- Same as <Enter>
ctrl_K = spare
ctrl_L = spare

ctrl_Z = undo_cmd          -- alt_z
ctrl_X = global_cut        -- alt_x
ctrl_C = global_copy       -- alt_c
ctrl_V = global_paste      -- alt_v
ctrl_B = spare

ctrl_N = new_file          -- alt_n
ctrl_M = dont_use          -- Same as <Enter>

-- These keys produce escape sequences (escape is not pressed)
esc_backspace = del_backspace
esc_insert = toggle_overtype
esc_delete = del_char
esc_shift_delete = del_line
--function() if is_sel_on() then sol_classic(1) set_sel_start() end line_down(1,1) end
esc_up = line_up
esc_down = line_down
esc_left = char_left
esc_right = char_right
esc_home = sol
esc_end = eol
esc_pageup = page_up
esc_pagedown = page_down
esc_mouse = mouse_event
esc_pastestart = bracket_paste_start
esc_pastestop  = bracket_paste_stop

