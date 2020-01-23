hello
<table>
<tr><th>Key Binding</th><th>Description</th></tr>
## File Tab Commands
<table>
<tr><td>`K'Alt+_equal_</td><td>Change to next file tab. Similar to Sublime next_view Ctrl+Tab.</td></tr>
<tr><td>`K'Alt+_plus_</td><td>Change to previous file tab. Similar to Sublime prev_view Ctrl+Shift+Tab.</td></tr>
<tr><td>`K'Alt+tt</td><td>Select file tab from list of open files.</td></tr>
<tr><td>`K'Alt+TT</td><td>Toggle to previous file tab</td></tr>
<tr><td>`K'Alt+aa</td><td>Align char on current line with previous line</td></tr>
<tr><td>`K'Alt+af</td><td>Align first char on next line with current line. If lines selected then align all lines with first line.</td></tr>
<tr><td>`K'Alt+bb</td><td>Goto bottom of file</td></tr>
<tr><td>`K'Alt+BB</td><td>Goto top of file</td></tr>
<tr><td>`K'Alt+bd</td><td>line sinks to bottom of file. Similar to sublime Ctrl+Shift+Down</td></tr>
<tr><td>`K'Alt+bu</td><td>line floats to top of file. Similar to sublime Ctrl+Shift+Up</td></tr>
<tr><td>`K'Alt+cb</td><td>ctag back</td></tr>
<tr><td>`K'Alt+cf</td><td>ctag forward in stack </td></tr>
<tr><td>`K'Alt+ct</td><td>ctag jump. Similar Sublime Ctrl+R</td></tr>
<tr><td>`K'Alt+cr</td><td>ctag read</td></tr>
<tr><td>`K'Alt+cx</td><td>ctag delete history</td></tr>
<	able>
## Comment Commands
<table>
<tr><td>`K'Alt+cc</td><td>Similar to Sublime Ctrl+/. Comment Line</td></tr>
<tr><td>`K'Alt+cs           = set_comment             hot("cs")</td></tr>
<	able>
# Copy Commands
<table>
<tr><td>`K'Alt+ce</td><td>copy current pos to eol</td></tr>
<tr><td>`K'Alt+cq</td><td>copy sol to current pos</td></tr>
<tr><td>`K'Alt+cu</td><td>comment remove</td></tr>
<tr><td>`K'Alt+cw</td><td>comment remove</td></tr>
<tr><td>`K'Alt+dd</td><td>Similar to Sublime Ctrl+Shift+D</td></tr>
<	able>
## Find and Replace Commands
<table>
<tr><td>`K'Alt+fa</td><td>Similar to Sublime Ctrl+Shift+F. search all open files for match</td></tr>
<tr><td>`K'Alt+fb</td><td>find back. return to position before find operation.</td></tr>
<tr><td>`K'Alt+ff</td><td>Similar to Sublime F3. Find next occurrence of search text.</td></tr>
<tr><td>`K'Alt+FF</td><td>Similar to Sublime Shift+F3. Find previous occurrence.</td></tr>
<tr><td>`K'Alt+fc</td><td>toggle find case sensitive</td></tr>
<tr><td>`K'Alt+fw</td><td>toggle find whole word</td></tr>
<tr><td>`K'Alt+hh           = replace_again           hot("hh")</td></tr>
<tr><td>`K'Alt+he           = open_file_bindings      hot("he")</td></tr>
<tr><td>`K'Alt+_minus_      = jump_back               hot(",-,") -- Jump back to previous position before Find. Similar to Sublime jump_back.</td></tr>
<tr><td>`K'Alt+_</td><td>Jump forward to next position in jump stack. Similar to Sublime jump_forward.</td></tr>
<	able>
## Indent Commands
<table>
<tr><td>`K'Alt+ii           = indent_selected         hot("ii")</td></tr>
<tr><td>`K'Alt+ir           = reindent_selected       hot("ir")</td></tr>
<tr><td>`K'Alt+is           = set_indent_size         hot("is")</td></tr>
<	able>
## Center Cursor Commands
<table>
<tr><td>`K'Alt+kc</td><td>Similar to Sublime's CTRL+KC. vim's zz/zt. recenters cursor to top, press again and recenters to center. </td></tr>
<	able>
## Case Commands
<table>
<tr><td>`K'Alt+kl</td><td>Similar to Sublime Ctrl+KL. Convert to Lower Case</td></tr>
<tr><td>`K'Alt+ku</td><td>Similar to Sublime Ctrl+KU. Convert to Upper Case</td></tr>
<	able>
## Mark Commands
<table>
<tr><td>`K'Alt+ka</td><td>Similar to Sublime Ctrl+KA. Select from mark to cursor (set mark with `K'Alt+mm)</td></tr>
<tr><td>`K'Alt+kw</td><td>Similar to Sublime Ctrl+KW. Delete from mark to cursor (set mark with `K'Alt+mm)</td></tr>
<tr><td>`K'Alt+M_squote     = function(name) set_mark(name); disp() end</td></tr>
<tr><td>`K'Alt+M_squote     = function(name) goto_mark(name); disp() end</td></tr>
<tr><td>`K'Alt+mm</td><td>Similar to Sublime Ctrl+K+space. Set Mark</td></tr>
<tr><td>`K'Alt+mp</td><td>Goto previous mark</td></tr>
<tr><td>`K'Alt+mn</td><td>Goto next mark in stack</td></tr>
<	able>
## Insert Line Before / After Commands
<table>
<tr><td>`K'Alt+ll</td><td>similar to vi's o. Similar to Sublime Ctrl+Enter</td></tr>
<tr><td>`K'Alt+lk</td><td>similar to vi's O. Similar to Sublime Ctrl+Shift+Enter</td></tr>
<	able>
## Page Up / Down Commands
<table>
<tr><td>`K'Alt+pp</td><td>Similar to Sublime <PageDown>, move down one page</td></tr>
<tr><td>`K'Alt+PP</td><td>Similar to Sublime <PageUP>, move up one page</td></tr>
<	able>
## Remove Tabs and Spaces
<table>
<tr><td>`K'Alt+ralt</td><td>Replace all leading tabs with spaces at start of line</td></tr>
<tr><td>`K'Alt+rats</td><td>Remove all trailing spaces at end of line</td></tr>
<tr><td>`K'Alt+ratsall</td><td>Remove all trailing spaces in all files</td></tr>
<	able>
## Select Commands
<table>
<tr><td>`K'Alt+si</td><td>Similar to Sublime Ctrl+shift+J.  Select lines with the indentation.</td></tr>
<tr><td>`K'Alt+sq</td><td>Select from cursor to start of line</td></tr>
<tr><td>`K'Alt+sb</td><td>Select inside curly brace</td></tr>
<tr><td>`K'Alt+se</td><td>Select from cursor to end of line</td></tr>
<tr><td>`K'Alt+sq</td><td>Select from cursor to start of file</td></tr>
<tr><td>`K'Alt+sg</td><td>Select from cursor to end of file</td></tr>
<tr><td>`K'Alt+sm</td><td>Select from mark (alt+mm) to cursor. Similar to Sublime Ctrl+K</td></tr>
<tr><td>`K'Alt+ss</td><td>Turn off/on selection. Similar to Sublime <ESC>.</td></tr>
<tr><td>`K'Alt+sw</td><td>Select Word (same as Ctrl+D). Similar to Sublime Ctrl+D</td></tr>
<	able>
## Line Swap Commands
<table>
<tr><td>`K'Alt+sn</td><td>Swap current line with next line. Similar to Sublime Ctrl+DOWN arrow</td></tr>
<tr><td>`K'Alt+sp</td><td>Swap current line with prev line. Similar to Sublime Ctrl+UP arrow</td></tr>
<	able>
## Move Commands
<table>
<tr><td>`K'Alt+u</td><td>Move N lines up. `K'Alt+u42<Enter> moves up 42 lines</td></tr>
<tr><td>`K'Alt+uu</td><td>Move N lines up. `K'Alt+u42<Enter> moves up 42 lines</td></tr>
<tr><td>`K'Alt+ui</td><td>Unindent selection one level</td></tr>
<tr><td>`K'Alt+ww</td><td>Move right one word. Similar to Sublime Ctrl+right_arrow.</td></tr>
<tr><td>`K'Alt+WW</td><td>Move left one word. Similar to Sublime Ctrl+left_arrow.</td></tr>
<tr><td>`K'Alt+wq</td><td>Move to Start of Line. Similar to Sublime <Home>.</td></tr>
<tr><td>`K'Alt+we</td><td>Move to End of Line. Similar to Sublime <End>.</td></tr>
<tr><td>`K'Alt+_gt_</td><td>Move right half the distance</td></tr>
<tr><td>`K'Alt+_lt_</td><td>Move left half the distance</td></tr>
<tr><td>`K'Alt+l</td><td>Move N char left.  `K'Alt+l42<Enter> moves 42 char to the left</td></tr>
<tr><td>`K'Alt+r</td><td>Move N char right.  `K'Alt+r42<Enter> moves 42 char to the right</td></tr>
<	able>
## Delete / Cut and Paste Commands
<table>
<tr><td>`K'Alt+xq</td><td>Similar to Sublime Ctrl_K+<Backspace></td></tr>
<tr><td>`K'Alt+xe</td><td>Similar to Sublime Ctrl+KK</td></tr>
<tr><td>`K'Alt+xm</td><td>Delete from mark (alt+mm) to cursor</td></tr>
<tr><td>`K'Alt+xs</td><td>Delete spaces from cursor to non-whitespace.  If on non-whitespace then go to next line and do it.</td></tr>
<tr><td>`K'Alt+xw</td><td>Delete word under cursor</td></tr>
<tr><td>`K'Alt+xx</td><td>Similar to Sublime Ctrl+KW</td></tr>
<tr><td>`K'Alt+XX</td><td>Similar to Sublime Ctrl+Backspace</td></tr>
<tr><td>`K'Alt+pl</td><td>Paste line after current line</td></tr>
<tr><td>`K'Alt+pk</td><td>Past line before current line</td></tr>
<tr><td>`K'Alt+z</td><td>Similar to Sublime Ctrl-z. Undo. After alt-z is used, ctrl-z becomes unix suspend command.</td></tr>
<tr><td>`K'Alt+_period_c</td><td>Toggle Ctrl+C between Cut and Kill Process</td></tr>
<tr><td>`K'Alt+_period_ind</td><td>Turn auto-indent on/off</td></tr>
<tr><td>`K'Alt+_period_cts  = set_`K'Ctrl+s_flow_control</td></tr>
<tr><td>`K'Alt+_period_ctz  = toggle_`K'Ctrl+z_suspend</td></tr>
<tr><td>`K'Alt+_period_dsp  = toggle_doublespeed</td></tr>
<tr><td>`K'Alt+_period_edi</td><td>Change from Lua mode to Edit mode. You almost always want to be in edit mode. </td></tr>
<tr><td>`K'Alt+_period_fch  = toggle_enable_file_changed</td></tr>
<tr><td>`K'Alt+_period_lua</td><td>Toggle to Lua mode to enter lua commands. Rarely used.</td></tr>
<tr><td>`K'Alt+_period_mlt</td><td>Set minimum lines to from top of page to cursor</td></tr>
<tr><td>`K'Alt+_period_mlb</td><td>Set minimum lines from cursor to bottom of page</td></tr>
<tr><td>`K'Alt+_period_ps</td><td>Change number of lines for page up/down command</td></tr>
<tr><td>`K'Alt+_period_sl</td><td>Toggle on/off the status line</td></tr>
<tr><td>`K'Alt+_period_slr</td><td>Toggle status line being shown in reverse video</td></tr>
<tr><td>`K'Alt+_period_tab</td><td>Toggle replace tabs with spaces as you type (defaults to replace)</td></tr>
<tr><td>`K'Alt+_period_rts</td><td>Toggle on/off remove trailing spaces as you type (defaults to don't remove)</td></tr>
<tr><td>`K'Alt+p_squote</td><td>Put string into paste buffer</td></tr>
<	able>
## Control Key Commands
<table>
<tr><td>`K'Ctrl+_at_</td><td>Called when resuming from Ctrl+Z (fg at shell prompt)</td></tr>
<tr><td>`K'Ctrl+Q</td><td>Quit or Exit. Similar to Sublime Ctrl-Q.</td></tr>
<tr><td>`K'Ctrl+W</td><td>Close window or tab. Similar to Sublime Ctrl-W.</td></tr>
<tr><td>`K'Ctrl+E</td><td>Spare</td></tr>
<tr><td>`K'Ctrl+R</td><td>Spare</td></tr>
<tr><td>`K'Ctrl+T</td><td>Spare</td></tr>
<tr><td>`K'Ctrl+Y</td><td>Redo (undo undo). Similar to Sublime Ctrl+Y</td></tr>
<tr><td>`K'Ctrl+U</td><td>Spare</td></tr>
<tr><td>`K'Ctrl+I</td><td>Do Not Use. Terminal interprets as `Tab` key</td></tr>
<tr><td>`K'Ctrl+O</td><td>Open File. Similar to Word Ctrl+O</td></tr>
<tr><td>`K'Ctrl+P</td><td>Open File from partial name. Similar to Sublime Ctrl+P</td></tr>
<tr><td>`K'Ctrl+A</td><td>Select All (Entire File). Similar to Sublime Ctrl+A.</td></tr>
<tr><td>`K'Ctrl+S</td><td>Save File. Similar to Sublime Ctrl+S.</td></tr>
<tr><td>`K'Ctrl+D</td><td>Select Word under cursor. Similar to Sublime Ctrl+D</td></tr>
<tr><td>`K'Ctrl+F</td><td>Find. Similar to Sublime Ctrl+F.  If text is selected the find selected text (Similar to Sublime Ctrl+F3). Related commands are `K'Alt+ff (find_forward_again) and `K'Alt+FF (find_reverse_again).</td></tr>
<tr><td>`K'Ctrl+G</td><td>Goto Line Number. Similar to Sublime Ctrl+G</td></tr>
<tr><td>`K'Ctrl+H</td><td>Find and Replace. Similar to Sublime Ctrl+H.</td></tr>
<tr><td>`K'Ctrl+J</td><td>Do Not Use. Same as <Enter></td></tr>
<tr><td>`K'Ctrl+K</td><td>Spare</td></tr>
<tr><td>`K'Ctrl+L</td><td>Select entire line. Similar to Sublime Ctrl+L</td></tr>
<tr><td>`K'Ctrl+Z</td><td>Undo. Similar to Sublime Ctrl+Z</td></tr>
<tr><td>`K'Ctrl+X</td><td>Cut. Similar to Word and Sublime Shift+Delete</td></tr>
<tr><td>`K'Ctrl+C</td><td>Copy. Similar to Word</td></tr>
<tr><td>`K'Ctrl+V</td><td>Paste. Similar to Word</td></tr>
<tr><td>`K'Ctrl+B</td><td>Spare.</td></tr>
<tr><td>`K'Ctrl+N</td><td>Create New File. Similar to Word.</td></tr>
<tr><td>`K'Ctrl+M</td><td>Do Not Use.</td></tr>
<	able>
## Misc Commands
<table>
<tr><td>`K'Alt+_caret_</td><td>delete from cursor to start of line</td></tr>
<tr><td>`K'Alt+_dollar_</td><td>delete from cursor to end of line</td></tr>
<tr><td>`K'Alt+_slash_</td><td>find forward</td></tr>
<tr><td>`K'Alt+_colon_w</td><td>Save File. Similar to Vi :w</td></tr>
<tr><td>`K'Alt+cd</td><td>Change directory</td></tr>
<tr><td>`K'Alt+ed</td><td>Change to EDIT mode. You almost always want to be in EDIT mode.</td></tr>
<tr><td>`K'Alt+jj</td><td>Similar to Sublime Ctrl+J. Join lines.</td></tr>
<tr><td>`K'Alt+ln</td><td>show line numbers</td></tr>
<tr><td>`K'Alt+ls</td><td>unix ls command. dos dir command</td></tr>
<tr><td>`K'Alt+LU</td><td>Change to LUA mode. You rarely want to be in lua mode.</td></tr>
<tr><td>`K'Alt+wl</td><td>Wrap line at cursor. Subsequent lines end at previous line.</td></tr>
<tr><td>`K'Alt+relued</td><td>Reload lued script</td></tr>
<tr><td>`K'Alt+rl</td><td>Reload current file</td></tr>
<tr><td>`K'Alt+sa</td><td>Similar to Sublime Ctrl+Shift+S. File Save as.</td></tr>
<tr><td>`K'Alt+Seti</td><td>Set Scope Indent SI2 SI3 SI4</td></tr>
</table>
