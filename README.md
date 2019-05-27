
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
* [Working with Multiple Files](#files)
* [Moving Around](#moving)
* [Select, Copy, Cut, Delete and Paste](#select)
* [Find and Replace](#find)
* [Indent Selection and Auto-Indent](#indent)
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
* To minimize clashes with the terminal window, Lued uses the <kbd>Alt</kbd>
  key for most of its commands.
* All of the above <kbd>Ctrl</kbd> keystroke commands have an equivalent,
  similarly named <kbd>Alt</kbd> command.
* Pressing <kbd>Esc</kbd> and then pressing a key is equivalent to
  simultaneously pressing <kbd>Alt</kbd> and the key.  Some keystrokes may be
  more comfortable with <kbd>Esc</kbd>, while others may be easier with <kbd>Alt</kbd>.
  Note, this behavior is a feature of the terminal and is not unique to Lued.

<a name="files"></a>
Working with Multiple Files
----------------------
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
* Block Select, Cut, Copy, Move
* Split screen
* Document API for plugins
* Exuberant Ctags
* Syntax Highlighting (lpeg+scintillua lexers)


