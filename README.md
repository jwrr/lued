# lued
lua-based text editor

lued
====

Description
-----------
Lued is an extensible text editor written in C and Lua.


Basic Operations
----------------
* ** JUST TYPE!!!! **
* Arrow keys, <kbd>Delete</kbd>, <kbd>Backspace</kbd>, <kbd>PgUp</kbd>, <kbd>PgDn</kbd>, <kbd>Home</kbd> and <kbd>End</kbd> work as expected.
* <kbd>Shift</kbd>+<kbd>Delete</kbd> deletes a line
* <kbd>Ctrl</kbd>+<kbd>s</kbd> and <kbd>Ctrl</kbd>+<kbd>q</kbd> save and quit as expected
* <kbd>Ctrl</kbd>+<kbd>z</kbd> / <kbd>Ctrl</kbd>+<kbd>y</kbd> undo/redo as expected.
* <kbd>Ctrl</kbd>+<kbd>f</kbd> finds and <kbd>Alt</kbd>+<kbd>l (el)</kbd> finds again (<kbd>Ctrl</kbd>+<kbd>h</kbd> finds in reverse direction)
* <kbd>Ctrl</kbd>+<kbd>r</kbd> for Find and Replace
* <kbd>Ctrl</kbd>+<kbd>t</kbd> moves to Top (first line). Double tap goes to last line
* <kbd>Alt</kbd>+<kbd>a</kbd> moves to start of line (Same as <kbd>Home</kbd>), <kbd>Alt</kbd>+<kbd>g</kbd> moves end of line (same as <kbd>End</kbd>)
* <kbd>Alt</kbd>+<kbd>s</kbd> moves left one word, <kbd>Alt</kbd>+<kbd>f</kbd> moves right one word
* <kbd>Ctrl</kbd>+<kbd>d</kbd> is the same as <kbd>Delete</kbd>, <kbd>Alt</kbd>+<kbd>d</kbd> is the same as <kbd>Backspace</kbd>

Cut / Copy / Paste
------------------
* <kbd>Alt</kbd>+<kbd>z</kbd> starts selecting (similar to mouse press and hold)
* <kbd>Ctrl</kbd>+<kbd>x</kbd> / <kbd>Ctrl</kbd>+<kbd>c</kbd> / <kbd>Ctrl</kbd>+<kbd>v</kbd> cut, copy and paste as expected.
* A common cut and paste sequence is <kbd>Alt</kbd>+<kbd>z</kbd>, move, <kbd>Ctrl</kbd>+<kbd>c</kbd>, move <kbd>Ctrl</kbd>+<kbd>v</kbd>

Mouse
-----
* Try the Scroll Wheel... It should work
* Try Mouse select, right mouse button to copy/paste... It should work too.

Control Keys (Configurable in lued.lua)
---------------------------------------
* Q (Quit),      W (Close),  E (Spare),       R (Replace),      T (Top)
* Y (Redo),      I (Tab),    O (Open File),   P (spare),
* A (Sel All),   S (Save),   D (Word Left),   F (Find),         G (Word Right)
* H (Find Back), J (Enter),  K (Sel Word),    L (Find Selected),
* Z (undo),      X (Cut),    C (Copy),        V (Paste),        B (Show Buffers)
* N (New),       M (Enter)

Select Commands
---------------
* <kbd>Alt</kbd>+<kbd>z</kbd> starts selecting
  *  <kbd>Alt</kbd>+<kbd>z</kbd>,<kbd>Home</kbd> selects from beginning of line to cursor
  *  <kbd>Alt</kbd>+<kbd>z</kbd>,<kbd>End</kbd> selects from cursor to end of line
  *  <kbd>Alt</kbd>+<kbd>a</kbd>,<kbd>Alt</kbd>+<kbd>f</kbd> selects word. Keep hitting <kbd>Alt</kbd>+<kbd>f</kbd> to select more words
* <kbd>Alt</kbd>+<kbd>s</kbd><Enter> selects the current line (same as <Home>,<kbd>Ctrl</kbd>+<kbd>d</kbd>,<kbd>Down-Arrow</kbd>)
  *  A common sequence is <kbd>Alt</kbd>+<kbd>s</kbd>, one or more <Enter> to select lines, <kbd>Ctrl</kbd>+<kbd>x</kbd> or <kbd>c</kbd>
  *  <kbd>Alt</kbd>+<kbd>s5</kbd> selects 5 lines
* <kbd>Alt</kbd>+<kbd>k</kbd> selects the current word
  *  A common sequence is <kbd>Alt</kbd>+<kbd>k</kbd>, <kbd>Alt</kbd>+<kbd>l (el)</kbd> to select a word and then find it
  *  Keep hitting <kbd>Ctrl</kbd>+k to select more words

Delete/Cut/Copy Commands
------------------------
* <kbd>Alt</kbd>+<kbd>b</kbd> deletes to beginning of line (Same as <kbd>Alt</kbd>+<kbd>z</kbd>,<kbd>Home</kbd>,<Delete>)
* <kbd>Alt</kbd>+<kbd>e</kbd> deletes to end of line (Same as <kbd>Alt</kbd>+<kbd>z</kbd>,<kbd>End</kbd>,<Delete>)
* <kbd>Alt</kbd>+<kbd>x</kbd> deletes current line  (Same as <kbd>Shift</kbd>+<kbd>Delete</kbd>)
  * Multiple, Back-to-Back <kbd>Alt</kbd>+<kbd>x</kbd> will combine all deleted lines in the paste buffer.
* <kbd>Alt</kbd>+<kbd>w</kbd> deletes to end of word    (Same as <kbd>Alt</kbd>+<kbd>z</kbd>,<kbd>Alt</kbd>+<kbd>f</kbd>,<kbd>Delete</kbd>)
* <kbd>Alt</kbd>+<kbd>c</kbd> copies current line to paste buffer.
  * Repeat to copy more lines to the paste buffer.

Movement
--------
* <kbd>Ctrl</kbd>+<kbd>l (el)</kbd> goes to line number

Multiple Files
--------------
* <kbd>Ctrl</kbd>+<kbd>o</kbd> opens a file and <kbd>Ctrl</kbd>+<kbd>n</kbd> creates a new file
* <kbd>Ctrl</kbd>+<kbd>b</kbd> shows a selectable list of all open file buffers
* <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>B</kbd> goes to previous file buffer (useful when working with two files)

Installation
------------
* cd src
* make
  * make will use wget to download lua

Trial Run
---------
* ./lued
* ./lued one or more filenames

Finish Installation
-------------------
* cp lued to a folder in your path... or your home directory and use (~/lued)
* cp lued_scripts/lued.lua to your home directory

XTERM Work-arounds
------------------
* Alt+V - Gnome Terminal provides many keyboard shortcuts (https://help.gnome.org/users/gnome-terminal/stable/adv-keyboard-shortcuts.html.en). Sometimes the Gnome bindings conflict with LuEd bindings.  For example, <kbd>Alt</kbd>+<kbd>V</kbd> opens the Gnome Terminal View Menu.  To disable Gnome's <kbd>Alt</kbd>+<kbd>V</kbd> behavior do the following: Edit > Keyboard Shortcuts..., and then unselect "Enable menu access keys".
* Ctrl+S - Terminals usually stop when Ctrl+S (XOFF) is pressed and remain suspended until Ctrl+Q (XON) is presed.  This behavior may be confusing and a user may think the application is hung. The KDE Konsole terminal attempts to help by printing a warning message "Output has been suspended by pressing Ctrl+S. Press Ctrl+Q to resume". LuEd, and many other text editors, use stty to disable the Ctrl+S (XOFF) and Ctrl+Q (XON) behavior.  Unfortunately older versions of Konsole have a bug that incorrectly show the error message even when Ctrl+S (XOFF) is disabled.  Lued provides an alternative keyboard binding, <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>S</kbd><kbd>Enter</kbd>, to work around this <a href="https://bugs.kde.org/show_bug.cgi?id=151966">Konsole bug</a>.
