
# lued
lua-based text editor

Description
-----------
Lued is an extensible text editor written in C and Lua.


Basic Operations
----------------
* JUST START TYPING!!!! It should work as expected
* Arrow keys, <kbd>Delete</kbd>, <kbd>Backspace</kbd>, <kbd>PgUp</kbd>, <kbd>PgDn</kbd>, <kbd>Home</kbd> and <kbd>End</kbd> work as expected.
* <kbd>Shift</kbd>+<kbd>Delete</kbd> deletes a line.
* <kbd>Ctrl</kbd>+<kbd>s</kbd> and <kbd>Ctrl</kbd>+<kbd>q</kbd> save and quit as expected.
* <kbd>Ctrl</kbd>+<kbd>z</kbd> / <kbd>Ctrl</kbd>+<kbd>y</kbd> undo/redo as expected.
* <kbd>Ctrl</kbd>+<kbd>f</kbd> finds and <kbd>Alt</kbd>+<kbd>l (el)</kbd> finds again (<kbd>Alt</kbd>+<kbd>h</kbd> finds in reverse direction).
* <kbd>Ctrl</kbd>+<kbd>r</kbd> for Find and Replace.
* <kbd>Ctrl</kbd>+<kbd>d</kbd> is the same as <kbd>Delete</kbd>, <kbd>Alt<x/kbd>+<kbd>d</kbd> is the same as <kbd>Backspace</kbd>.
* <kbd>Alt</kbd>+<kbd>t</kbd> moves to the top (first line). Double tap (<kbd>Alt</kbd>+<kbd>tt</kbd>) goes to last line.
* <kbd>Alt</kbd>+<kbd>a</kbd> moves to start of line (Same as <kbd>Home</kbd>), <kbd>Alt</kbd>+<kbd>g</kbd> moves end of line (same as <kbd>End</kbd>).
* <kbd>Alt</kbd>+<kbd>s</kbd> moves left one word, <kbd>Alt</kbd>+<kbd>f</kbd> moves right one word.

Cut / Copy / Paste
------------------
* <kbd>Alt</kbd>+<kbd>z</kbd> starts selecting (similar to mouse press and hold)
* <kbd>Ctrl</kbd>+<kbd>x</kbd> / <kbd>Ctrl</kbd>+<kbd>c</kbd> / <kbd>Ctrl</kbd>+<kbd>v</kbd> cut, copy and paste as expected.
  * Copy and paste is <kbd>Alt</kbd>+<kbd>z</kbd>, move, <kbd>Ctrl</kbd>+<kbd>c</kbd>, move <kbd>Ctrl</kbd>+<kbd>v</kbd>.
  * Cut and paste is <kbd>Alt</kbd>+<kbd>z</kbd>, move, <kbd>Ctrl</kbd>+<kbd>x</kbd>, move <kbd>Ctrl</kbd>+<kbd>v</kbd>.

Special Select Commands
-----------------------
* <kbd>Alt</kbd>+<kbd>za</kbd> selects from beginning of line to cursor.
* <kbd>Alt</kbd>+<kbd>zg</kbd> selects from cursor to end of line.
* <kbd>Alt</kbd>+<kbd>zf</kbd> selects to end of word.
  * Keep hitting <kbd>Alt</kbd>+<kbd>zfff</kbd> to select more words.
* <kbd>Alt</kbd>+<kbd>k</kbd> selects the entire current word.
  *  A common sequence is <kbd>Alt</kbd>+<kbd>k</kbd>, <kbd>Alt</kbd>+<kbd>l (el)</kbd> to select a word and then find it.
* REMEMBER: <kbd>Alt</kbd>+<kbd>z</kbd> also turns off select.

Line Operations
---------------
* <kbd>Alt</kbd>+<kbd>c</kbd> copies the current line to the paste buffer.
  * Repeat to copy more lines to the paste buffer. For example, <kbd>Alt</kbd>+<kbd>cccc</kbd> copies 4 lines to paste buffer.
* <kbd>Alt</kbd>+<kbd>x</kbd> cuts the current line to the paste buffer.
  * Repeat to cut more lines to the paste buffer. For example  <kbd>Alt</kbd>+<kbd>xxx</kbd> will cut 3 lines to the paste buffer.
* <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>C42</kbd><kbd>Enter</kbd> will copy 42 lines to the paste buffer.
* <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>X420</kbd><kbd>Enter</kbd> will cut 420 lines to the paste buffer.

Mouse
-----
* Try the Scroll Wheel... It should work
* Try Mouse select... It should work too
  * Left Mouse Button to select, Middle Mouse Button to paste at cursor. Or...
  * Left Mouse Button to select, Right Mouse Button to copy/paste to/from system buffer.

Control Keys (Configurable in lued.lua)
---------------------------------------
* Q (Quit),    W (Close),    E (Spare),     R (Replace),   T (Spare)
* Y (Redo),    U (Spare),    I (Don't Use), O (Open File), P (Spare)
* A (Sel All), S (Save),     D (Delete),    F (Find),      G (Spare)
* H (Spare),   J (Dont Use), K (Spare),     L (Spare),
* Z (Undo),    X (Cut),      C (Copy),      V (Paste),     B (Spare)
* N (New),     M (Don't Use)


Delete/Cut/Copy Commands
------------------------
* <kbd>Alt</kbd>+<kbd>b</kbd> deletes to beginning of line (Same as <kbd>Alt</kbd>+<kbd>z</kbd>,<kbd>Home</kbd>,<Delete>)
* <kbd>Alt</kbd>+<kbd>e</kbd> deletes to end of line (Same as <kbd>Alt</kbd>+<kbd>z</kbd>,<kbd>End</kbd>,<Delete>)
* <kbd>Alt</kbd>+<kbd>w</kbd> deletes to end of word    (Same as <kbd>Alt</kbd>+<kbd>z</kbd>,<kbd>Alt</kbd>+<kbd>f</kbd>,<kbd>Delete</kbd>)

Movement
--------
* <kbd>Esc</kbd>+<kbd>123</kbd><kbd>Enter</kbd> goes to line number 123

Multiple Files
--------------
* <kbd>Ctrl</kbd>+<kbd>o</kbd> opens a file and <kbd>Ctrl</kbd>+<kbd>n</kbd> creates a new file
* <kbd>Alt</kbd>+<kbd>b</kbd><kbd>Enter</kbd> shows a selectable list of all open file buffers
* <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>B</kbd> goes to previous file buffer (useful when working with two files)

Installation
------------
* make
  * make will clone carr repo
  * make will use wget to download lua

Trial Run
---------
* ./lued
* ./lued one or more filenames

Finish Installation
-------------------
* cp lued to a folder in your path... or your home directory and use (~/lued)
* cp lued.lua to your home directory

XTERM Work-arounds
------------------
* Alt+V - Gnome Terminal provides many keyboard shortcuts (https://help.gnome.org/users/gnome-terminal/stable/adv-keyboard-shortcuts.html.en). Sometimes the Gnome bindings conflict with LuEd bindings.  For example, <kbd>Alt</kbd>+<kbd>V</kbd> opens the Gnome Terminal View Menu.  To disable Gnome's <kbd>Alt</kbd>+<kbd>V</kbd> behavior do the following: Edit > Keyboard Shortcuts..., and then unselect "Enable menu access keys".
* Ctrl+S - Terminals usually stop when Ctrl+S (XOFF) is pressed and remain suspended until Ctrl+Q (XON) is presed.  This behavior may be confusing and a user may think the application is hung. The KDE Konsole terminal attempts to help by printing a warning message "Output has been suspended by pressing Ctrl+S. Press Ctrl+Q to resume". LuEd, and many other text editors, use stty to disable the Ctrl+S (XOFF) and Ctrl+Q (XON) behavior.  Unfortunately older versions of Konsole have a bug that incorrectly show the error message even when Ctrl+S (XOFF) is disabled.  Lued provides an alternative keyboard binding, <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>S</kbd><kbd>Enter</kbd>, to work around this <a href="https://bugs.kde.org/show_bug.cgi?id=151966">Konsole bug</a>.

