
# lued
lua-based text editor

Description
-----------
Lued is an extensible, terminal-based text editor written in C and Lua.

The Basic Operations Work as Expected
--------------------------------------
* Open a file with 'lued filename.txt' and JUST START TYPING...
* Arrow keys, <kbd>Delete</kbd>, <kbd>Backspace</kbd>, <kbd>PgUp</kbd>, <kbd>PgDn</kbd> work as expected.
* <kbd>Home</kbd> and <kbd>End</kbd> go to the beginning and end of line, respectively.
* <kbd>Ctrl</kbd>+<kbd>s</kbd> saves the file.
* <kbd>Ctrl</kbd>+<kbd>a</kbd> selects all of the text in the file.
* <kbd>Ctrl</kbd>+<kbd>f</kbd> finds a string.
* <kbd>Ctrl</kbd>+<kbd>r</kbd> replaces a string.
* <kbd>Ctrl</kbd>+<kbd>z</kbd> / <kbd>Ctrl</kbd>+<kbd>y</kbd> undo and redo, repectively, as expected.
* <kbd>Ctrl</kbd>+<kbd>o</kbd> opens an existing file.
* <kbd>Ctrl</kbd>+<kbd>n</kbd> opens a new file.
* <kbd>Ctrl</kbd>+<kbd>c</kbd>, <kbd>Ctrl</kbd>+<kbd>x</kbd> and <kbd>Ctrl</kbd>+<kbd>v</kbd> copy, cut and paste.
* <kbd>Ctrl</kbd>+<kbd>q</kbd> quits the editor and <kbd>Ctrl</kbd>+<kbd>w</kbd> closes the document.

Ctrl vs. Alt vs Esc
-------------------
* To minimize clashes with the terminal window, Lued uses the <kbd>Alt</kbd> key for most of its commands.
* All of the above <kbd>Ctrl</kbd> keystroke commands have an equivalent, similarly named <kbd>Alt</kbd> command.
* Pressing <kbd>Esc</kbd> and then pressing a key is equivalent to simultaneously pressing <kbd>Alt</kbd> and
the key.  Some keystrokes may be more comfortable with <kbd>Esc</kbd>, while others may be easier with <kbd>Alt</kbd>.
Note, this behavior is a feature of the terminal and is not unique to Lued.

Working Multiple Files
----------------------
* <kbd>Alt</kbd>+<kbd>o</kbd> opens another file. Lued supports multiple tabs.
* <kbd>Alt</kbd>+<kbd>t</kbd> allows you to select one of the open tabs. Lued supports.
* <kbd>Alt</kbd>+<kbd>tt</kbd> switches to the next tab.
* <kbd>Alt</kbd>+<kbd>ty</kbd> toggles between the last to tabs.
* <kbd>Alt</kbd>+<kbd>o</kbd> opens an existing file.
* <kbd>Alt</kbd>+<kbd>n</kbd> opens a new file.
* <kbd>Alt</kbd>+<kbd>q</kbd> quits the editor and <kbd>Alt</kbd>+<kbd>w</kbd> closes the document.

Moving Around
-------------
* The arrow keys move as expected.
* <kbd>Shift</kbd>+<kbd>Right Arrow</kbd> moves to the end of the line.
* <kbd>Shift</kbd>+<kbd>Left Arrow</kbd> moves to the beginning of the line.  When the line is indented then
the cursor moves the first non-space of the line.  If you're on the first non-space the cursor moves to the
first character of the line.
* <kbd>Alt</kbd>+<kbd>g</kbd> moves a word to the left.
* <kbd>Alt</kbd>+<kbd>h</kbd> moves a word to the right.
* <kbd>Shift</kbd>+<kbd>Down Arrow</kbd> moves down a partial page (the partial page size is configurable).
* <kbd>Shift</kbd>+<kbd>Up Arrow</kbd> moves up a partial page.
* <kbd>Alt</kbd>+<kbd>b</kbd> moves to the bottom, last line, of the file if the cursor is on the first line.
Otherwise, it moves to the first line of the file.
* <kbd>Alt</kbd>+<kbd>u</kbd> moves the cursor and the line it's on to the upper part of the screen.  This is
useful when you're at the bottom of the screen and the text you're interested in is hidden on the next page.
* <kbd>Alt</kbd>+<kbd>LL</kbd> inserts a line above the current line and indents appropriately.  This is
useful when you want to add a line before the current line.
* <kbd>Shift</kbd>+<kbd>Right Arrow</kbd>+<kbd>Enter</kbd> inserts a line below the current line and indents appropriately.
* FIXME TBD - ADD WORD LEFT and WORD RIGHT
* The Mouse Scroll Wheel moves up and down in steps of five lines (the number of lines is configurable).
* <i>Double-Speed</i> moves the cursor faster when using the arrow keys. After two moves in a direction, subsequent moves in that
same direction advance two steps instead of one.
* <i>Magic Move</i> uses <kbd>Alt</kbd>+<kbd><</kbd> and <kbd>Alt</kbd>+<kbd>></kbd> to speed up movement on a line by log2.  The
first step goes half the distance to the end (or beginning) of the line.  The second step goes half the distance again. If
the cursor goes too far then use the other Magic Move key to go in the other direction.

Select / Cut / Copy / Delete / Paste
---------------------------
* <kbd>Alt</kbd>+<kbd>k</kbd> selects the current word.
  * <kbd>Alt</kbd>+<kbd>c</kbd> will copy it to the paste buffer.
* <kbd>Alt</kbd>+<kbd>v</kbd> writes the paste buffer into the text.
* <kbd>Alt</kbd>+<kbd>e</kbd> deletes to the end of word.  If the cursor is over whitespace then it deletes the whitespace
  up to the start of the next word.
* <kbd>Shift</kbd>+<kbd>Delete</kbd> cuts a line into the paste buffer.
  * <kbd>Alt</kbd>+<kbd>d</kbd> also a line into the paste buffer.
  * Continue hitting <kbd>Alt</kbd>+<kbd>d</kbd> will add each line to the paste buffer, so the paste buffer will contain
    multiple lines.
* <kbd>Alt</kbd>+<kbd>.</kbd> starts selecting text. Move the cursor to the end of the selection and press
  <kbd>Alt</kbd>+<kbd>c</kbd> or <kbd>Alt</kbd>+<kbd>x</kbd> to copy or cut the selection into the paste buffer.
  * If you start typing when a region is selected, the region will be deleted and replaced with the typing.
  * Press <kbd>Alt</kbd>+<kbd>.</kbd> to abort the selection.
* <kbd>Alt</kbd>+<kbd>Sall</kbd> searches all tabs.

Find and Replace
----------------
* <kbd>Alt</kbd>+<kbd>f</kbd> is the forward find command and presents a dialog to enter search string.
  Previous searches can be accessed using the up arrow key.
* <kbd>Alt</kbd>+<kbd>F</kbd> is the reverse find command.
* <kbd>Alt</kbd>+<kbd>l</kbd> is the find next command.  If text is selected then the selected text will
  be searched for.
* <kbd>Alt</kbd>+<kbd>l</kbd> is the reverse find next command.
* <kbd>Alt</kbd>+<kbd>r</kbd> is the find and replace command.

Comments
--------
* <kbd>Alt</kbd>+<kbd>CC</kbd> comments out the line and advances to the next line
* <kbd>Alt</kbd>+<kbd>CS</kbd> sets the comment to a custom string value.

Remove All Trailing Spaces
--------------------------
* Trailing whitespace is highlighted.
* <kbd>Alt</kbd>+<kbd>Rats</kbd> removes all trailing spaces.
  * <kbd>Esc</kbd>+<kbd>Rats</kbd> is equivalent

Mouse
-----
* Try the Scroll Wheel... It should work
* Try Mouse select... It should work too
  * Left Mouse Button to select, Middle Mouse Button to paste at cursor. Or...
  * Left Mouse Button to select, Right Mouse Button to copy/paste to/from system buffer.

Installation
------------
* make install
  * make will clone carr repo
  * make will use wget to download lua
  * make will create and populate ~/.lued
  * make will prompt to add lued to path

Trial Run
---------
* lued
* lued one or more filenames

XTERM Work-arounds
------------------
* Alt+V - Gnome Terminal provides many keyboard shortcuts (https://help.gnome.org/users/gnome-terminal/stable/adv-keyboard-shortcuts.html.en).
  Sometimes the Gnome bindings conflict with LuEd bindings.  For example, <kbd>Alt</kbd>+<kbd>V</kbd> opens the Gnome Terminal View Menu.  To
  disable Gnome's <kbd>Alt</kbd>+<kbd>V</kbd> behavior do the following: Edit > Keyboard Shortcuts..., and then unselect "Enable menu access keys".
* Ctrl+S - Terminals usually stop when Ctrl+S (XOFF) is pressed and remain suspended until Ctrl+Q (XON) is presed.  This behavior may be confusing
  and a user may think the application is hung. The KDE Konsole terminal attempts to help by printing a warning message "Output has been suspended
  by pressing Ctrl+S. Press Ctrl+Q to resume". LuEd, and many other text editors, use stty to disable the Ctrl+S (XOFF) and Ctrl+Q (XON) behavior.
  Unfortunately older versions of Konsole have a bug that incorrectly show the error message even when Ctrl+S (XOFF) is disabled.  Lued provides
  an alternative keyboard binding, <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>S</kbd><kbd>Enter</kbd>, to work around this
  <a href="https://bugs.kde.org/show_bug.cgi?id=151966">Konsole bug</a>.

TBD
---
* Indent Selection
* Block Select, Cut, Copy, Move
* Split screen
* Document API for plugins
* Syntax Highlighting
