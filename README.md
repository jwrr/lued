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
* Arrow keys, Delete, Backspace, PgUp, PgDn, Home and End work as expected.
* Shift+Delete deletes a line
* Ctrl+s and Ctrl+q save and quit as expected
* Ctrl+z / Ctrl+y undo/redo as expected.
* Ctrl+f finds and Ctrl+l finds again (Ctrl+h finds in reverse direction)
* Ctrl+r for Find and Replace
* Ctrl+t moves to Top (first line). Double tap goes to last line
* Ctrl+g moves right one word, Ctrl+d moves left one word

Cut / Copy / Paste
------------------
* Ctrl+a starts selecting (similar to mouse press and hold)
* Ctrl+x / Ctrl+c / Ctrl+v cut, copy and paste as expected.
* A common cut and paste sequence is Ctrl+a, move, Ctrl+c, move Ctrl+v

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
* Ctrl+a starts selecting
  *  Ctrl+a,<Home> selects from beginning of line to cursor
  *  Ctrl+a,<End> selects from cursor to end of line
  *  Ctrl+a,Ctrl+g selects word. Keep hitting Ctrl+g to select more words
* Alt+s<Enter> selects the current line (same as <Home>,Ctrl+d,Down-Arrow)
  *  A common sequence is Alt+s, one or more <Enter> to select lines, Ctrl+x or c
  *  Alt+s5 selects 5 lines
* Ctrl+k selects the current word
  *  A common sequence is Ctrl+k, Ctrl+l to select a word and then find it
  *  Keep hitting Ctrl+k to select more words

Delete/Cut/Copy Commands
------------------------
* Alt+b deletes to start of line  (Same as Ctrl+a,<Home>,<Delete>)
* Alt+e deletes to end of line    (Same as Ctrl+a,<End>,<Delete>)
* Alt+x deletes current line      (Same as Shift+Delete)
  * Multiple, Back-to-Back Alt+x will combine all deleted lines in the paste buffer.
* Alt+d5<enter> deletes 5 lines   (Same as Alt+S5,<Delete>)
* Alt+w deletes to end of word    (Same as Ctrl+a,Ctrl+g,<Delete>)
* Alt+c copies current line to paste buffer. 
  * Repeat to copy more lines to the paste buffer.

Movement
--------
* Alt+l420<enter> goes to line 420

Multiple Files
--------------
* Ctrl+o opens a file and Ctrl+n creates a new file
* Ctrl+b shows a selectable list of all open file buffers
* Alt+Shift+B goes to previous file buffer (useful when working with two files)

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

