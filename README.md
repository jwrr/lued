Lued
====
lua-based text editor

Description
-----------
Lued is an extensible, terminal-based text editor written in C and Lua.

Table of Contents
-----------------
* [Basic Operations](#basic)
* [Ctrl, Alt and Esc](#ctrl)
* [Esc vs Alt](#esc-alt)
* [Working with Multiple Files](#files)
* [Moving Around](#moving)
* [Select, Copy, Cut, Delete and Paste](#select)
* [Find and Replace](#find)
* [Indent Selection and Auto-Indent](#indent)
* [Enable and Goto Line Numbers](#line-numbers)
* [Comments](#comments)
* [Trailing Whitespace](#trailing)
* [Using the Mouse](#mouse)
* [Installation](#install)
* [Trial Run](#trial)
* [Customize Keyboard](#keyboard)
* [Extending Lued](#extending)
* [Terminal Work-Arounds](#xterm)
* [TBD](#tbd)

<a name="basic"></a>
Basic Operations Work as Expected
---------------------------------
* Open a file with 'lued filename.txt' and JUST START TYPING...
* Arrow keys, <kbd>Delete</kbd>, <kbd>Backspace</kbd>, <kbd>PgUp</kbd>,
  <kbd>PgDn</kbd> work as expected.
* <kbd>Home</kbd> and <kbd>End</kbd> go to the beginning and end of line,
  respectively.
* <kbd>Ctrl</kbd>+<kbd>s</kbd> saves the file.
* <kbd>Ctrl</kbd>+<kbd>a</kbd> selects all of the text in the file.
* <kbd>Ctrl</kbd>+<kbd>f</kbd> finds a string.
* <kbd>Ctrl</kbd>+<kbd>r</kbd> replaces a string.
* <kbd>Ctrl</kbd>+<kbd>z</kbd> / <kbd>Ctrl</kbd>+<kbd>y</kbd> undo and redo,
  repectively, as expected.
* <kbd>Ctrl</kbd>+<kbd>o</kbd> opens an existing file.
* <kbd>Ctrl</kbd>+<kbd>n</kbd> opens a new file.
* <kbd>Ctrl</kbd>+<kbd>c</kbd>, <kbd>Ctrl</kbd>+<kbd>x</kbd> and
  <kbd>Ctrl</kbd>+<kbd>v</kbd> copy, cut and paste.
* <kbd>Ctrl</kbd>+<kbd>q</kbd> quits the editor and
  <kbd>Ctrl</kbd>+<kbd>w</kbd> closes the document.

<a name="ctrl"></a>
Ctrl, Alt and Esc
-----------------
To minimize clashes with the terminal window, Lued uses the <kbd>Alt</kbd> key
for most of its commands. All of the above <kbd>Ctrl</kbd> keystroke commands
have an equivalent, similarly named <kbd>Alt</kbd> command.

By default Lued uses the <kbd>Ctrl</kbd>+<kbd>c</kbd> to copy and
<kbd>Ctrl</kbd>+<kbd>z</kbd> to undo.  This conflicts with expected terminal
behavior where <kbd>Ctrl</kbd>+<kbd>c</kbd> kills the process and
<kbd>Ctrl</kbd>+<kbd>z</kbd> suspends the process.  The following commands
enables you to restore typical terminal behavior.

* <kbd>Alt</kbd>+<kbd>.</kbd>+<kbd>z</kbd>+<kbd>Enter</kbd> enables Ctrl-Z to
  suspend Lued.  To resume Lued enter ```fg``` at the terminal prompt.
* <kbd>Alt</kbd>+<kbd>.</kbd>+<kbd>c</kbd>+<kbd>Enter</kbd> enables Ctrl-c to
  Kill Lued.  All unsaved edits will be lost.
* **Note:** To **copy** and **undo** you can always use <kbd>Alt</kbd>+<kbd>c</kbd>
  to copy and <kbd>Alt</kbd>+<kbd>z</kbd> to undo.

<a name="esc-alt"></a>
Escape vs Alt
-------------
Pressing <kbd>Esc</kbd> and then pressing a key is equivalent to simultaneously
pressing <kbd>Alt</kbd> and the key.  Some keystrokes may be more comfortable
with <kbd>Esc</kbd>, while others may be easier with <kbd>Alt</kbd>. Note, this
behavior is a feature of the terminal and is not unique to Lued.

<a name="files"></a>
Working with Multiple Files
----------------------
* <kbd>Alt</kbd>+<kbd>S</kbd>+<kbd>Enter</kbd> Save As. Saves current file
  with a new name.
* <kbd>Alt</kbd>+<kbd>o</kbd> opens another file. Each file is contained in a
  tab.
* <kbd>Alt</kbd>+<kbd>t</kbd> selects one of the open tabs.
* <kbd>Alt</kbd>+<kbd>=</kbd> walks through tabs.
* <kbd>Alt</kbd>+<kbd>TT</kbd> Tab Toggle switches to previous tab.
* <kbd>Alt</kbd>+<kbd>o</kbd> opens an existing file.
* <kbd>Alt</kbd>+<kbd>n</kbd> creates a new file.
* <kbd>Alt</kbd>+<kbd>q</kbd> quits the editor and <kbd>Alt</kbd>+<kbd>w</kbd>
  closes the document.

<a name="moving"></a>
Moving Around
-------------
* The arrow keys move the cursor as expected.
* <kbd>End</kbd> jumps to the end of the line.
* <kbd>Home</kbd> jumps to the beginning of the line. When the line
  is indented the cursor moves to the first non-space of the line. If the
  cursor is on the first non-space then the cursor moves to the first character
  of the line.
* <kbd>Shift</kbd>+<kbd>Right Arrow</kbd> moves a word to the left.
* <kbd>Shift</kbd>+<kbd>Right Arrow</kbd> moves a word to the right.
* <kbd>Shift</kbd>+<kbd>Down Arrow</kbd> moves down a partial page (the partial
  page size is configurable).
* <kbd>Shift</kbd>+<kbd>Up Arrow</kbd> moves up a partial page.
* <kbd>Alt</kbd>+<kbd>b</kbd> moves to the bottom, last line. When the cursor
  is already on the bottom line it moves to the first line of the file.  It
  is common to tap Alt+b twice to get to the top of the file.
* <kbd>Alt</kbd>+<kbd>u</kbd> moves the cursor and the line it's on to the
  upper part of the screen.  This is useful when you're at the bottom of the
  screen and the text you're interested in is hidden on the next page.
* <kbd>Alt</kbd>+<kbd>LL</kbd> inserts a line above the current line and
  indents appropriately.  This is useful when you want to add a line before
  the current line.
* <kbd>Shift</kbd>+<kbd>Right Arrow</kbd>+<kbd>Enter</kbd> inserts a line
  after the current line and indents appropriately.
* The Mouse Scroll Wheel quickly moves up and down in steps of five lines (the
  number of lines is configurable).
* <i>DoubleSpeed</i> moves the cursor faster when using the arrow keys. After
  two moves in a direction, subsequent moves in that same direction advance
  two steps instead of one.
  * <kbd>Alt</kbd>+<kbd>DS</kbd> turns on/off the Double-Speed feature.
* <i>MagicMove</i> uses <kbd>Alt</kbd>+<kbd><</kbd> and <kbd>Alt</kbd>+<kbd>></kbd>
  to speed up movement on a line by log2.  The first step goes half the
  distance to the end (or beginning) of the line.  The second step goes half
  the distance again. If the cursor goes too far then use the other MagicMove
  key to go in the other direction.

<a name="select"></a>
Select, Copy, Cut, Delete and Paste
-----------------------------------
* <kbd>Alt</kbd>+<kbd>k</kbd> selects the current word.
* <kbd>Alt</kbd>+<kbd>c</kbd> copies selected text to the paste buffer.
* <kbd>Alt</kbd>+<kbd>x</kbd> cuts selected text to the paste buffer.
* <kbd>Alt</kbd>+<kbd>v</kbd> writes the paste buffer into the text.
* <kbd>Alt</kbd>+<kbd>e</kbd> deletes to the end of word.  If the cursor is
  over whitespace then it deletes the whitespace up to the start of the next
  word.
* <kbd>Alt</kbd>+<kbd>d</kbd> cuts an entire line into the paste buffer.
  * Continue hitting <kbd>Alt</kbd>+<kbd>d</kbd> adds each deleted line to the
    paste buffer, so the paste buffer will contain multiple lines. You can
    then <kbd>Alt</kbd>+<kbd>v</kbd> to restore the text, move to another
    location and <kbd>Alt</kbd>+<kbd>v</kbd> again, to duplicate the text.
* <kbd>Alt</kbd>+<kbd>+</kbd> starts selecting text. Move the
  cursor to the end of the selection and press <kbd>Alt</kbd>+<kbd>c</kbd> or
  <kbd>Alt</kbd>+<kbd>x</kbd> to copy or cut the selection into the paste
  buffer. Press <kbd>Alt</kbd>+<kbd>+</kbd> to stop selecting.
  * If you start typing when a region is selected, the region will be deleted
    and replaced with the typing.
  * Press <kbd>Alt</kbd>+<kbd>+</kbd> to abort the selection.

<a name="find"></a>
Find and Replace
----------------
* <kbd>Alt</kbd>+<kbd>f</kbd> is the forward find command and presents a dialog
  to enter a search string. Previous searches can be accessed quickly using
  the up arrow key.
* <kbd>Alt</kbd>+<kbd>F</kbd> is the reverse find command.
* <kbd>Alt</kbd>+<kbd>h</kbd> is the find selected command.  If text is selected
  then the selected text will be searched for. A quick way to select a word is
  <kbd>Alt</kbd>+<kbd>j</kbd>.
* <kbd>Alt</kbd>+<kbd>H</kbd> finds the previous occurrence of the selected
  string.
* <kbd>Alt</kbd>+<kbd>g</kbd> finds the next occurrence of the search string.
* <kbd>Alt</kbd>+<kbd>G</kbd> finds the previous occurrence of the search
  string.
* <kbd>Alt</kbd>+<kbd>r</kbd> is the find and replace command.
* <kbd>Alt</kbd>+<kbd>Sall</kbd> searches all tabs.

<a name="indent"></a>
Indent Selection and Auto-Indent
--------------------------------
* <kbd>Alt</kbd>+<kbd>+</kbd> starts selection.
* Move to one line beyond last line
* <kbd>Alt</kbd>+<kbd>&gt;</kbd> to indent
* <kbd>Alt</kbd>+<kbd>&lt;</kbd> to unindent

Auto-indent is on by default.  Each line is indented the same as the previous
line.

<a name="line-numbers"></a>
Line Numbers
------------
* <kbd>Alt</kbd>+<kbd>LN</kbd> toggles (turns off/on) the line numbers.
* <kbd>Ctrl or Alt</kbd>+<kbd>l</kbd> goes to a specific line number.

<a name="comments"></a>
Comments
--------
* <kbd>Alt</kbd>+<kbd>CC</kbd> comments out the line and advances to the next
  line
* <kbd>Alt</kbd>+<kbd>CS</kbd> sets the comment to a custom string value.

<a name="trailing"></a>
Remove All Trailing Spaces
--------------------------
* Trailing whitespace is highlighted.
* <kbd>Alt</kbd>+<kbd>Rats</kbd> removes all trailing spaces.
  * <kbd>Esc</kbd>+<kbd>Rats</kbd> is equivalent

<a name="mouse"></a>
Mouse
-----
* Try the Scroll Wheel... It should work
* Try Mouse select... It should work too
  * Left Mouse Button to select, Middle Mouse Button to paste at cursor. Or...
  * Left Mouse Button to select, Right Mouse Button to copy/paste to/from
  system buffer.

<a name="install"></a>
Installation
------------
* git clone https://github.com/jwrr/lued.git
* cd lued
* make install
  * make uses wget to download Lua 5.2.4 from https://www.lua.org/ftp
  * make clones the carr repo from https://github.com/jwrr/carr
    * carr provides support for large, dynamic arrays written in the C
      programming language.
  * make compiles the source code
  * make creates and populates ~/.lued
  * make prompts to add lued to path

<a name="trial"></a>
Trial Run
---------
* ./lued TreasureIsland.txt ## [courtesy of Project Guttenberg](https://www.gutenberg.org)

<a name="keyboard"></a>
Customize Keyboard Bindings
---------------------------
You can easily modify the keyboard bindings. The Lua file lued_bindings.lua
contains the keyboard bindings.

<a name="extending"></a>
Extending Lued
--------------
You can write new Lued features and store them in the .lued/plugin directory.
Files in this directory are automatically read at startup. lued_lib.lua
contains the default Lued commands an provides a reference for new features.

<a name="xterm"></a>
Terminal Work-arounds
---------------------
* Alt+V - Gnome Terminal provides many keyboard shortcuts
  (https://help.gnome.org/users/gnome-terminal/stable/adv-keyboard-shortcuts.html.en).
  Sometimes the Gnome bindings conflict with LuEd bindings.
  * For example, <kbd>Alt</kbd>+<kbd>V</kbd> opens the Gnome Terminal View
    Menu. To disable Gnome's <kbd>Alt</kbd>+<kbd>V</kbd> behavior do the
    following:
    * Edit > Keyboard Shortcuts..., and then unselect "Enable menu access keys".
  * If you want to keep the Gnome behavior, Lued provides an alternative
    keyboard binding, <kbd>Ctrl</kbd>+<kbd>V</kbd> instead of
    <kbd>Alt</kbd>+<kbd>V</kbd>.
* Ctrl+S - Terminals usually stop when Ctrl+S (XOFF) is pressed and remain
  suspended until Ctrl+Q (XON) is presed. This behavior may be confusing and a
  user may think the application is hung. The KDE Konsole terminal attempts to
  help by printing a warning message "Output has been suspended by pressing
  Ctrl+S. Press Ctrl+Q to resume". LuEd, and other text editors, use the stty
  command to disable the Ctrl+S (XOFF) and Ctrl+Q (XON) behavior.
  Unfortunately, older versions of Konsole have a bug that incorrectly shows
  the error message even when Ctrl+S (XOFF) is disabled.
  * Lued provides an alternative keyboard binding,
    <kbd>Alt</kbd>+<kbd>s</kbd><kbd>Enter</kbd>, to work around this
    <a href="https://bugs.kde.org/show_bug.cgi?id=151966">Konsole bug</a>.

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

