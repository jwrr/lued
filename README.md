Lued
====

[Documentation on Github.io](https://jwrr.github.io/lued/)

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
* [Install](#install)
* [Contribute](#contribute)
* [Todo List](#tbd)

<hr>

<a name="install"></a>
## Install

```
git clone https://github.com/jwrr/lued .lued
cd .lued
source COMPILE
./lued README.md
```


<a name="contribute"></a>
## Contribute

Thanks for wanting to contribute to LUED. This guide will hopefully make the
process a little smoother.

### License

All contributions must be under the [MIT LICENSE](https://opensource.org/licenses/MIT).
The MIT license is permissive, brief and readable. [Lua](http://www.lua.org/) 
and many Lua-based projects use it.

### Steps

* Create an [issue](https://github.com/jwrr/lued/issues)
* Create a [Fork](https://help.github.com/articles/fork-a-repo/). There's
  a 'fork' button in the upper right of the Lued project page.
* Clone your fork: `git clone https://username@github.com/username/lued`
* Create a branch: `git checkout -b meaningful-branch-name`
* Make your changes.  Test cases and documentation are appreciated.
* Git commit to your local repo with a meaningful commit message
* Push to your fork: `git push origin branch-name`
* Create a pull request. Click 'Pull Request' on your fork's Github page.
* We'll review your changes. When approved we'll pull your changes into the 
  LUED repo.

<hr>

<a name="tbd"></a>
TBD
---

* Split screen - Is this worth it, because Lued works nicely with tmux
* Document API for plugins
* toggle find whole word, case sensitive, regex, incremental
* Improve Goto Label
* Git Integration (init, push, pull, branch, stash, mark changes)
* ^`Lua repl
** highlight mixing of tabs and spaces
** Syntax Highlighting (lpeg+scintillua lexers)
** Highlite closing brackets, parentheses
** After Ctrl-Z, console's cut-n-paste has extraneous esc codes before and after the text.
   Fix: change settings back-to normal. On first keypress change settings back to what Lued needs.
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
* Incremental Search
  Implement as either find_selected + one char OR find_previous + one char

* delete spaces in selection for alignment
*wrap text at 72

** Add global g_stop_at_line_boundary to enable/disable this feature.


* alt_rd/RD repeat delete on next/prev line
* Add delete_to_match (alt_df) to delete to find match
* Enhance File open (ctrl_O) to perform partial match file open (ctrl_P) if file not found
* Add command alt_lua to get to lua repl
* Enhance ctrl_T to open file (ctrl_p) if file is not open
* Enhance ctrl_f to find without qualifiers (alt_fw,alt_fc) if not found
* Add List Tabs (Open Files - Alt_tt) alphabetically
* Add List Tabs (Open Files - Alt_tt) by most recent
* Find (ctrl_F, alt_ff alt_FF) ignore comments (alt_fc)

* ctrl_H - when done with find and replace return page to original offset

* Should sel_word incldule set_sel_end()? or should it be an argument?
* <cr> in comment creates new comment line.
* Bracket highlighting
* Move to open/close of bracket
* Create php.lua language mode
  * Support php alternate mode for bracket highlighting
* alt_hh highlight selected text. this allows you to move without growing/shrinking/closing selected region.
* alt_HH turns off highlight
* Support multiple sessions. Each session has different set of files
* When ctrl+R immediately follows ctrl+E (or E follows R) move a half step
* After quiting Find+Replace, return to original screen offset

* move goto_mark from c to lua

* feature - custom script.  load commands (similar to relued). readme files. examples...
* fixme - move line numbers from c to lua
* feature - if moving away from '()' then change to '('

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
* feature - run script from command line: lued script file_list
* feature - run one-liner from command line: - lued -e 'find_last(pat) insert_below("string1\nstr")' file_list
* Compatiblity - Terminator, Guake, Tilda, Guake, Konsole
* alt+jj joins two lines. if on comment line the remove next lines comment
* feature - test framework. open(filename) goto(r,c) del_word() save_as() diff(expect_file) report(stderr) quit()
* feature - lued -d script.lued filenames
* feature - lued -d script.lued < stdin > stdout > stderr
* feateure - on paste and mouse paste, delete leading spaces and indent to current position
* fixdme    - square paren at end of line gets deleted.

Mag – Ctrl-X
Mag – Ctrl-C
Mag - Ctrl-R repeat n keystrokes
Mag - alt+>/< moving magic
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
Doc  - READTHEDOCS.ORG
Feat - on_event("event", handler); on_signal(id, handler)
Feat - Table at beginning of line, when lined up with previous line's start, causes indent
https://bootstrapstarter.com/bootstrap-templates/template-basic-bootstrap-html/


open auto-star - find file does not match then append '*' and try again
alt_fw/FW - find and select word
if seach is for one char then unselect after find.

refactor delete/cut to use cut_or_del_sel to remove duplicate code

readline -> preprocessor -> repl. This could be used for generic DSL.

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
change alt+kc to ctrl+KC

----------------------------
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
language dependent indent
session - don't fail if creation fails
indentation marks
light yellow current line
alt-cc/CC - comment selected lines. undo just undo's one line at a time
ctrl-f of close paren ')' causes error - seems fine
max_comment_linelen, max_linelen hardwrap
ctrl-T - for history store the filename instead of the index number
Don't highlight text in comments

vi style open file to previous row+col. (not session based)


bug - last letter of file gets chomped when last line is not empty.

* feature - grep - search all open files. return selectable list of matches
* Feat - alt+dn. delete up to but not include find string.
* Feat - alt+dn. if prev command was alt+dn then don't prompt
* Feat - alt_xn. repeated xn grows paste buffer.


TAB,back-arrow - If cursor ends in a word then goto end of word
ctrl+V - If on first col of line then don't delete leading spaces



n't is not the start of a comment so don't highlight

create backup with version number on every save, like vax edt
  purge command to delete old backups
  Step back/forward through backups
  diff between versions
side-by-side diff/merge tool
  possibly just re-formatted diff tool.
spell check
  use unix words. As word is found in words, move to local hash for speed. 
  alt+add - add word to file, project, user dictionary
  
git suppport
  add
  commit, commit-all, 
  push
  branch
  highlight delta
  merge
  status


look into vim/tabularize
Track Changes.
  highlight changes from specific version
  approve changes
  backout changes
  comment on changes
  
  
alt+LL - indent to level the current line is.

auto-close - [('""')] < autoclose > when line starts with  #include

tab - have ctrl-z work correctly for tab. ie:  cont<tab> -> continue ctrl_z -> cont

tab - search for matching word in file, project, user dictionary, global dictionary

alt+ln alt+ln alt+LN alt+ln - remember if absolute or relative line numbers is active  

alt----<tab> repeat - for the length of the line above
alt--===<tab> repeat = for the length of the line above
alt-###, *** ^^^ 3char<tab> repeats char for length of the previous line


duplicate line - done
  alt+DD fails when on last line.

auto-comment - done
  on <cr> if current line is a comment then make the next line a comment

Line number - done
  When line numbers are enable, put indicator around the current line number.
  
Long lines - done
  line-wrap=off - don't wrap lines that are too line

Status Line - done
  Top-line bug when window is narrow.  missing <cr>

grep - done
  alt+gg - list all matches in all open files
  alt+GG - list all matches in file
  alt+grep - lis all matches in glob of open files

tabs at start of line - done
  When on a blankline or in the leading whitespace the <tab> has two behaviors.
  If the cursor is before the first non-whitespace of the previos line then the
  cursor will align to the previous line's first non-whitespace. If the cursor
  is at or after the previous line's first non-whitespace then the cursor will
  advance to the next indent level.

Join Lines - done
alt+jj - this command joins two lines, the current line with the next line.
  When joining two comment lines, the comment indicator is removed from the
  second line.

Grep / Search all open files - done
alt+gg - When choosing file to goto, the user can enter a new search string to grep again.
alt+GG - Return to previous file after grepping. This is implemented as a stack so you can
  go back multiple files. 
  
Delete Multiple Characters - done
alt+dN - Delete N char (including current char). N must be less than 10.

Repeat Previous N Commands - done
alt+rN - Repeat the last N command

Ctrl-T - show most-recent 5 files after listing all files - done

alt-t - The file menu shows the most recent files even when the file filter is not "". This
  is confusing. Only show most recent when  filter="". done

==============================
find - highlight all matches number all matches. alt+f# jumps to the specific match

jah finds start_col of next word and after paste adds spaced to current word as needed to align next word to same start_col.
I don't know what the action is for this request.

tab-backspace
  needs cleanup
  goto save column, go down one
  if not is_space() then
    
Find and Replace
  Y - replace and stop at cursor
  N - dont' replace and stop at cursor
  Q - quit and stay at cursor
  
Dictionaries
  Add selected word to dictionary. highlight words not in dictionary.

alt-gg/grep/ct add support for most-recent lines

Comment contination - On <Enter> only start next line with comment if the
current and subsequent line starts with a comment.  Currently the next
line will start with a comment if the current line is a comment. This is
too aggressive.

alt-gg (grep) needs its own dedicated search history

paste indent needs fixing. sometimes it works, othertimes it doesn't.

if linenumber is greater than numlines then supress

find - if string is on the page then move the cursor, and keep page alignment the same.
find - bug find multiple occurrences on the same line sometimes doesn't work

Need better rules for quote/bracket completion. 


