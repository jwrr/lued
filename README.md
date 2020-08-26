Lued
====
lua-based text editor

Description
-----------

Lued is a text editor.  It runs in a terminal window such as konsole, gnome-terminal or PuTTY.

If you can, use an IDE (such as IntelliJ or Eclipse) or GUI-based editor (such
as Sublime Text, VSCode or Atom). If you're stuck in a terminal, then try Vi
or Emacs. If those options don't work then give Lued a try. I use it regularly
and make tweaks as I go, but there's still work to be done.


Table of Contents
-----------------
* [Lued Docs](https://jwrr.github.io/lued)
* [Lued Key Bindings](https://jwrr.github.io/lued/bindings)
* [Lued User Guide](https://jwrr.github.io/lued/ug)
* [Contribute](#contribute)
* [Todo List](#tbd)

<hr>

<a name="contribute"></a>
Contribute
----------
Contributors are welcome.

This guide explains how to contribute to the project. The goal is to
streamline the development effort, avoid bottlenecks, and hopefully make
a pleasant experience to all involved.  It's okay if you don't follow these
steps, but it may lead to a less efficient process.

All contributions must be under the [MIT LICENSE](https://opensource.org/licenses/MIT).
This license is very permissive, granting the end-user maximum freedom.
It's also a very brief, readable license. [Lua](http://www.lua.org/) and many
Lua-based projects use this license.

Here is the typical flow for a contribution.

* Create an [issue](https://github.com/jwrr/lued/issues) that describes what
  you want and and why you want it.  The 'proper' flow is to create an issue 
  before doing any development. But in reality, it's likely you're already 
  done coding, you like how it works, and you're now ready to share.
* Create a [Fork](https://help.github.com/articles/fork-a-repo/) of the Lued
  repo (just click on the 'fork' button in the upper left of this page).
* Clone your fork: `git clone https://username@github.com/username/lued`
* Create a branch: `git checkout -b meaningful-branch-name`
* Make your changes.  Please remember test cases and documentation.
* Add and commit. The commit message should be a short title.  If more 
  description is needed then insert a blank line between the title line and 
  the detailed description.
* Push to your fork on Github: `git push origin branch-name`
* Create a pull request. Click 'Pull Request' on your fork's Github page.
* A maintainer will review your change and may make changes. When approved
  your changes (on your branch) will be pulled into the lued repo and merged
  to the dev branch. Eventually your changes will be merged into the master
  branch and will be part of the next release.

<hr>

<a name="tbd"></a>
TBD
---
* Update display_screen - done
* Exuberant Ctags - done
* alt__period_xxx - change sets to toggles - done
* Enable binary search mode - done (alt+>, alt+<) - done
* alt-- - return back to position when find (or ctag) was called. make it a stack - done
* move line numbers from c to lua. - done
* alt_fw - toggle find whole word -done
* alt_fc - toggle find case sensitive - done
* alt-bb goto bottom of file. alt+BB goto beginning of file. - done.
* tab (ctrl+I) - align with previous line's next non-whitespace. - done
* alt_c qwe - done
* alt_s qwe - done
* alt_x qwe - done
* mouse paste - remove trailing comma (if it's there) - done
* alt_de - delete to end. when at end then go down 1 line and delete to end. - done
* alt_incr. go down one line and increment count. If number then replace number. if blank line the duplicate line and incr. - done
* alt_decr - done
* alt_sm - Select from Mark to cursor. Sublime Ctrl+KA - done
* alt_xm - Delete from Mark to cursor. Sublime Ctrl+KW - done
* Swap two words. alt_bl, alt_br - done
* ctrl_H Case Sensitive Replace. 'Hello' 'Hi' replaces 'hello' with 'hi', 'Hello' with 'Hi' - done
* ctrl_T - Transpose two words (alt_bl). Similar to Sublime ctrl+T - done
* ctrl_H - J = fix Jagged edge after replace. - done
* insert_tab - if previous line is blank then check two lines above - done
* alt_ku/kl - if not selected then toupper/tolower the current char and move right - done

* ctrl_H - j. goto end of word and then tab - done
* alt_dw del to end of word. alt_DW delete to begining of word - done
* alt_de delete to end of line. alt_DE delete to beginning of line.
* change alt_dd to alt_DD - duplicate line (sublime ctrl+shift+D). alt_dd becomes delete word - done
* alt_x's -> alt_d's - done
* alt_d50 - delete 50 char - done
* alt_p10 - go down N (10) lines. set alt_pp page size to 10. - done
* alt_P10 - go up N (10) lines. set alt_PP page size to N. - done
* fix ctrl_H - case sensitive replace problem - done
* alt_vv - paste and find next. alt_VV - paste and find prev. - done
* alt_FR - Find in Reverse - done
* alt_dd deletes word - done
* <TAB> - If prev line is shorter than current pos then continuue searching up - done
* alt_sa - save as. prompt for overwrite? if file exists - done
* esc+review = Toggle Review Mode. In review mode save maps to save_as.
* Bug Fix - ctrl_D with one word on line causes hang. Did not range check index in Lua code. it when negative and never stopped decrementing. - done
* Add version - done
* Fix <TAB> if in middle of word, go to beginning of word before tabbing current word left - done
* Fix alt_ds hotkey not hot - done
* Change alt_he to alt_help - done
* Center screen (alt_kc) after last find and replace (ctrl_H) - done
* Fix Change_File_Tab (alt_tt) to not update last tab when tab doesn't change - done
* Add session support (alt_SaveSession, alt_LoadSession) - done
* alt_db/DB delete to File end or File start eof/sof - done
* alt_sb/SB select to File end or File start eof/sof - done
* alt_bb/BB goto File end or File start eof/sof - done
* add support for self-closing braces '()[]{}' - done
* Repeat previous N keystrokes - done
* add support for snippets - done
* Check compatibility with tmux and screen - done compatible with tmux. some conflicts with screen

* fixme - alt_cc delete space after comment if it's there - done
* fixme - alt_CC delete comment even with leading spaces - done
* fuxne - snippet lua.lua for_loop cleanup indenting - done
* fixme - alt_dw when over _asdf, only _ is deleted - done
* fixme - alt_dw/DW.  When over non-space, delete non-space and spaces - done
* fixme - alt_jj. remove extra whitespace between joined lines - done
* fixme - alt_cc doesn't work when selection is on. - done
* fixme - make comment highlighting filetype dependent - done
* fixme - alt+bb/BB (got to bottom/Beginning). turn off autorepeat - done
* change - move delete hot-keys from d? to x?. make them cut - done




==========================

* Split screen
* Document API for plugins
* toggle find whole word, case sensitive, regex, incremental
* Improve Goto Label
* CRASH REPORT when selecting and cursor moves above start
* Git Integration (init, push, pull, branch, stash, mark changes)
* Embedded Terminal
* ^`Lua repl
** highlight mixing of tabs and spaces
** Syntax Highlighting (lpeg+scintillua lexers)
** Highlite closing brackets, parentheses
** After Ctrl-Z, console's cut-n-paste has extraneous esc codes before and after the text.
   Fix: change settings back-to normal. On first keypress change settings back to what Lued needs.
** Save session. Option: with/without history.
** Should each file tab be in its own process?
** Change reindent_selected, indent_selected, unindent_selected to use foreach_selected
* Jump to Matching Bracket. Ctrl+M
* Select Content in Brackets Sublime Ctrl+shift+M
* Block Comment. Sublime Ctrl+Shift+/
* Paste and Indent Ctrl+Shift+V
* Auto Complete
* Clear Mark. Sublime Ctrl+KG
* Bringup Clipboard. Sublime Ctrl+KV
* Create movetab plug in. move_tab_up, move_tab_down, move_tab_to_first, move_tab_to_last, move_tab_to_n
  allows user to re-arrange the order of the file tabs.


* move 'file has changed' checking from C to Lua
del_sol_in_region.
esc_space goes into lua mode. any other esc seq exists lua mode

* ctrl_O - Use the currently opened file as the starting directory.
* Column/Block/Rectangle Select, Cut, Copy, Move
* Sort Selected. Sublime f9
* display without wrapping long lines.
* Incremental Search alt_ii (change indent to alt_in)
  Implement as either find_selected + one char OR find_previous + one char


* delete spaces in selection for alignment
*wrap text at 72

** Add global g_stop_at_line_boundary to enable/disable this feature.


* Change delete_n_char (alt_dN) to goto next line on repeat
** This is useful for deleting multline lines of same text
** alt_da/DA delete again goes to next/prev line and repetes delete
** Similar to delete_to_eol (alt_de) behavior
** Similar to delete_spaces (alt_ds) behavior
* Add delete_to_match (alt_df) to delete to find match
* Add support for macros (alt_mm)
* Enhance File open (ctrl_O) to perform partial match file open (ctrl_P) if file not found
* Add command alt_pwd to display current working directory
* Add command alt_os to get shell prompt
* Add command alt_lua to get to lua repl
* Enhance alt_tt to open file (ctrl_p) if file is not open
* Enhance ctrl_f to find without qualifiers (alt_fw,alt_fc) if not found
* Add List Tabs (Open Files - Alt_tt) alphabetically
* Add List Tabs (Open Files - Alt_tt) by most recent
* Find (ctrl_F, alt_ff alt_FF) ignore comments (alt_fc)

* alt_mm - toggle mouse between up/down and left/right
* alt_mN - change mouse step size
* alt_MM - toggle between stepsize of N and 1

* alt_db/DB delete to bottom/beginning of file - done
* alt_dl/DL delete to end/start of line - done
* add support for double ctrl-K hot.
* ctrl_H - when done with find and replace return page to original offset

# Subject Line
## Keep subject brief and meaningful
## Use imperative mode
### Subject should answer What will change if I apply this commit? If applied, this commit will ...
### Common imperative verbs: Add, Remove, Update, Fix, Refactor, Polish, Rework
## Separate subject from body with a blank line
## Capitalize first letter subject line
## Do not end subject line with period
# Body
## Explain what and why vs how## Ke
ep lines less than 72 char
## Resolves: #123## See also: #456
#789


* Should sel_word incldule set_sel_end()? or should it be an argument?
* <cr> in comment creates new comment line.
* Bracket highlighting
* Move to open/close of bracket
* Create php.lua language mode
* Map files extension to language mode
* Support php alternate mode for bracket highlighting
* alt_hh highlight selected text. this allows you to move without growing/shrinking/closing selected region.
* alt_HH turns off highlight
* Support multiple sessions. Each session has different set of files
* When ctrl+R immediately follows ctrl+E (or E follows R) move a half step
* Refine Jah when modifying partial word, and still maintaining alignment
* After quiting Find+Replace, return to original screen offset

* move goto_mark from c to lua

* feature - custom script.  load commands (similar to relued). readme files. examples...
* fixme - move line numbers from c to lua
* feature - grep - search all open files. return selectable list of matches
* feature - timestamp on save.
* feature - if moving away fro '()' then change to '('
* fixme - ctrl+d if partial word selected then deselect/reselect -

* fixme - highlight keywords if not in comment
* fixme - xxx_in_xxx. in matched, and shouldn't have
* fixme - if string not closed, highlight to end of page
* feature - multiline comments
* feature - pipes: find | get_select | format | paste;
*           grep rex1 * | grep_v rex2 | sed 's#abc#def#'
* feature - grep, sed, awk
* experimental - pforth
* experimental   - speedup reading large files. slurp into large, then break into lines
* feature - embed real regex support. lua patterns are powerful but not what end-user expects
* feature - find_last(pattern/regex) - find last occurrence of string.
* feature - insert_below(str) - insert str on line below
* feature - run script from command line: lued script file_list
* feature - run one-liner from command line: - lued -e 'find_last(pat) insert_below("string1\nstr")' file_list
* Compatiblity - Terminator, Guake, Tilda, Guake, Konsole
* feature - add support for ctrl-K,ctrl-?
* alt+jj joins two lines. if on omment line the remove next lines comment
* feature - test framework. open(filename) goto(r,c) del_word() save_as() diff(expect_file) report(stderr) quit()
* feature - lued -d script.lued filenames
* feature - lued -d script.lued < stdin > stdout > stderr
* feature - alt_X13 - delete previous 13 lines (including current line)
* fixme   - make relative line numbers solid
* feateure - on paste and mouse paste, delete leading spaces and indent to current position
* fixme    - square paren at end of line gets deleted.

Mag - Alt+xs del space. Press enter. Moves down line and deletes
Mag – Ctrl-X
Mag – Ctrl-C
Mag - Ctrl-R repeat n keystrokes
Mag - alt+>/< moving magic
Mag – ctags
Mag – alt+incr
Feat - alt+math = +5; -7; *3; /2;
Feat -  alt+box1, alt+box2, alt+boxclr
Doc - <section id="categories" markdown="1">
Fix - style return to previous instead of return to default
Fix - nostyle in comment
Feat - alt+xa cut aggregate.
Feat - alt+xc clear X aggregate buffer
Feat - alt+d? deletees without paste buffer
Feat - alt+xv views paste buffers
Feat - Alt+rN repeat previous command N times (alt+r123 repeats 123 times)
Feat - If multiline paste and current line contains text after cursor, goto next line and paste
Feat - If multiline paste and current line is indented then delete leading-ws in paste buffer before pasting
Doc  - READTHEDOCS.ORG
Feat - on_event("event", handler); on_signal(id, handler)
Feat - Table at beginning of line, when lined up with previous line's start, causes indent
https://bootstrapstarter.com/bootstrap-templates/template-basic-bootstrap-html/
Fix - alt+XW (cut-to-sow) bug when at eol
Feat - alt+dn. delete up to but not include find string.
Feat - alt+dn. if prev command was alt+dn then don't prompt
Feat - alt_xn. repeated xn grows paste buffer.





open auto-star - find file does not match then append '*' and try again
alt_fw/FW - find and select word
if seach is for one char then unselect after find.

refactor delete/cut to use cut_or_del_sel to remove duplicate code

readline -> preprocessor -> repl. This could be used for generic DSL.

rm ctag

RELEASE script  os_version date(yyyy.mm.dd) led_version; bump version; zip; sha; scp

Convert all script to lued or lua

Change x to “” in readline.  Add lued to all bindings.  For all misses prepend lued.

Alt+ra – replace all

Add stack routines push/pop pos,



Lued.push

Lued.stacks[type(arg)] = arg



Cur_pos_stack. Push_cur_pos. pop_cur_pos. clear_cur_pos.

Tab_complete

push_bool(g_dd)

g_dd = true

push_pos()

push_str(sel_sow)

find_reverse(pop_str)

push_str(sel_word)

pop_pos()

sel_word()

ins_str(pop_str)

g_dd = pop_bool()

ctrl_X paste appears broken
alt+DD appears broken
change alt+kc to ctrl+KC

----------------------------
enhancement open_file(filename,r,c,dd)
create and use session file of open_file and change tab
- when you open a file from command line it is opened along with all session files
delete file plugins/ctags.lua
remove comma from mouse paste
vhdl sig snippet does terrible things
new command alt+mr removes most recent mark
alt-incr should skip lines without numbers instead of just stopping.

alt_center - keep screen centered. alt_Center don't keep screen centered.
alt_ff(i,dd) - multiple find buffers
alt_findor(a,b,c,d...) find one of many
alt_loadcode  load this script
alt_rr - supress display until end of script
ctrl+R - don't run script, just create it
status line - add total number of lines to header
status line - make status line user configurable
alt_df/DF - if nothing selected then prompt for search string
alt_margin80 - set margin to 80. All subsequent lines will wrap at margin.  Similar to alt-QQ, but in real-time.
alt_qq incorrect splits at '.'.
alt_no alias for alt_nop, alt_noop


alt+BB - make no-repeat
Backspace - delete one indent when only spaces precede
language dependent indent
session - save session only if more than one file open. prompt if session file does not exist
session - don't fail if creation fails
) ) at end of line incorrect behavior
indentation marks
light yellow current line
alt-cc/CC - comment selected lines. undo just undo's one line at a time
alt-ii/II use indent_size constant (set by ait-is), but TAB does not
alt-todo = alt-f todo
max_comment_linelen, max_linelen hardwrap
ctrl-T - for history store the filename instead of the index number
tab - don't look for match if over space
