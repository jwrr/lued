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
* <kbd>Ctrl</kbd>+<kbd>f</kbd> finds and <kbd>Ctrl</kbd>+<kbd>l</kbd> finds again (<kbd>Ctrl</kbd>+<kbd>h</kbd> finds in reverse direction)
* <kbd>Ctrl</kbd>+<kbd>r</kbd> for Find and Replace
* <kbd>Ctrl</kbd>+<kbd>t</kbd> moves to Top (first line). Double tap goes to last line
* <kbd>Ctrl</kbd>+<kbd>g</kbd> moves right one word, <kbd>Ctrl</kbd>+<kbd>d</kbd> moves left one word

Cut / Copy / Paste
------------------
* <kbd>Ctrl</kbd>+<kbd>a</kbd> starts selecting (similar to mouse press and hold)
* <kbd>Ctrl</kbd>+<kbd>x</kbd> / <kbd>Ctrl</kbd>+<kbd>c</kbd> / <kbd>Ctrl</kbd>+<kbd>v</kbd> cut, copy and paste as expected.
* A common cut and paste sequence is <kbd>Ctrl</kbd>+<kbd>a</kbd>, move, <kbd>Ctrl</kbd>+<kbd>c</kbd>, move <kbd>Ctrl</kbd>+<kbd>v</kbd>

Mouse
-----
* Try the Scroll Wheel... It should work
* Try Mouse select, right mouse button to copy/paste... It should work too.

Control Keys (Configurable in lued.lua)
---------------------------------------
* Q (Quit),      W (Close),  E (Spare),       R (Replace),      T (Top)
* Y (Redo),      I (Tab),    O (Open File),   P (spare),
* A (Start Sel), S (Save),   D (Word Left),   F (Find),         G (Word Right)
* H (Find Back), J (Enter),  K (Select Word), L (Find Selected),
* Z (undo),      X (Cut),    C (Copy),        V (Paste),        B (Show Buffers)
* N (New),       M (Enter)

Select Commands
---------------
* <kbd>Ctrl</kbd>+<kbd>a</kbd> starts selecting
  *  <kbd>Ctrl</kbd>+a,<kbd>Home</kbd> selects from beginning of line to cursor
  *  <kbd>Ctrl</kbd>+<kbd>a</kbd>,<kbd>End</kbd> selects from cursor to end of line
  *  <kbd>Ctrl</kbd>+<kbd>a</kbd>,<kbd>Ctrl</kbd>+<kbd>g</kbd> selects word. Keep hitting <kbd>Ctrl</kbd>+<kbd>g</kbd> to select more words
* <kbd>Alt</kbd>+<kbd>s</kbd><Enter> selects the current line (same as <Home>,<kbd>Ctrl</kbd>+<kbd>d</kbd>,<kbd>Down-Arrow</kbd>)
  *  A common sequence is <kbd>Alt</kbd>+<kbd>s</kbd>, one or more <Enter> to select lines, <kbd>Ctrl</kbd>+<kbd>x</kbd> or <kbd>c</kbd>
  *  <kbd>Alt</kbd>+<kbd>s5</kbd> selects 5 lines
* <kbd>Ctrl</kbd>+<kbd>k</kbd> selects the current word
  *  A common sequence is <kbd>Ctrl</kbd>+k, <kbd>Ctrl</kbd>+<kbd>l</kbd> to select a word and then find it
  *  Keep hitting <kbd>Ctrl</kbd>+k to select more words

Delete/Cut/Copy Commands
------------------------
* <kbd>Alt</kbd>+<kbd>b</kbd> deletes to beginning of line (Same as <kbd>Ctrl</kbd>+<kbd>a</kbd>,<kbd>Home</kbd>,<Delete>)
* <kbd>Alt</kbd>+<kbd>e</kbd> deletes to end of line (Same as <kbd>Ctrl</kbd>+<kbd>a</kbd>,<kbd>End</kbd>,<Delete>)
* <kbd>Alt</kbd>+<kbd>x</kbd> deletes current line  (Same as <kbd>Shift</kbd>+<kbd>Delete</kbd>)
  * Multiple, Back-to-Back <kbd>Alt</kbd>+<kbd>x</kbd> will combine all deleted lines in the paste buffer.
* <kbd>Alt</kbd>+<kbd>d5</kbd><kbd>enter</kbd> deletes 5 lines   (Same as <kbd>Alt</kbd>+<kbd>s5</kbd>,<kbd>Delete</kbd>)
* <kbd>Alt</kbd>+<kbd>w</kbd> deletes to end of word    (Same as <kbd>Ctrl</kbd>+<kbd>a</kbd>,<kbd>Ctrl</kbd>+<kbd>g</kbd>,<kbd>Delete</kbd>)
* <kbd>Alt</kbd>+<kbd>c</kbd> copies current line to paste buffer. 
  * Repeat to copy more lines to the paste buffer.

Movement
--------
* <kbd>Alt</kbd>+<kbd>l420</kbd><kbd>Enter</kbd> goes to line 420

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

Complete Install
----------------
* cp lued to a folder in your path... or your home directory and use (~/lued)
* cp lued_scripts/lued.lua to your home directory

