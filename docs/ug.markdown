---
layout: page
title: User Guide
permalink: /ug/
sidebar: toc
---

<style type="text/css">
kbd {
background-color: #eee;
border-radius: 3px;
border: 1px solid #b4b4b4;
box-shadow: 0 1px 1px rgba(0, 0, 0, .2), 0 2px 0 0 rgba(255, 255, 255, .7) inset;
color: #333;
display: inline-block;
font-size: .85em;
font-weight: 700;
line-height: 1;
padding: 2px 4px;
white-space: nowrap;
}
</style>

* TOC
{:toc}

Enter Magic
-------------------

First a little magic.  You enter an edit command, such as <kbd>alt+xw</kbd> to 
delete one word to the right.  Now you want to delete many words.  You
can keep pressing <kbd>alt+xw</kbd>... but it's a little annoying.  And here
enters the magic.  Press the <kbd>Enter</kbd> key instead. It repeats the
last <kbd>alt+??</kbd> command. This is a nice time saver, and may help keep the
carpal away.  Note, as soon as you enter another command, such as a <kbd>ctrl+?</kbd>
command or an arrow-key command, the <kbd>Enter</kbd> key reverts back to
being just a regular ole <kbd>Enter</kbd> key.

More Repeat Magic
-----------------
The above <kbd>Enter</kbd> repeats just the last <kbd>Alt</kbd> command.  Say
you just performed a sequence of commands that you want to repeat. <kbd>Ctrl+R</kbd>,
R for Repeat, shows a list of the most recent commands.  You enter the number of
commands you want to repeat and it is done.  Say you want to repeat it again.
Press <kbd>alt+rr</kbd> to repeat again.  Now if you to keep repeating, press
<kbd>Enter</kbd> repeatedly (or hold it down if you have alot of repeats).


Tab Magic
-----------------


Basic Control Key Commands
--------------------------

File Tab Commands
-----

Select Commands
-----

Movement Commands
-----

Ctags / Exuberant Tags
-----

Delete, Cut, Copy and Paste Commands
-----

Find and Replace Commands
-----

Line Swap Commands
-----

Indent and Align Commands
-----

Center Cursor Commands
-----

Comment Commands
-----

Upper / Lower Case Commands
-----

Mark Commands
-----

Insert Line Before / After Commands
-----

Page Up / Down Commands
-----

Remove Tabs and Spaces
-----

Configuration Commands
-----

Misc Commands
-----


Repeat Magic
-----------


Moving Around
-----------


Terminal/Console Limitations
--------------------

### Control Keys are Case Insensitive

The terminal maps upper and lower case <kbd>Ctrl</kbd>
key combinations to the same value.  So Lued can't
tell the difference.  For example, <kbd>Ctrl+d</kbd> (used by
Sublime to select a word) and <kbd>Shift+Ctrl+D</kbd>
(used by Sublime to duplicate a line) look the same to Lued.

Note, the <kbd>Alt</kbd> key combinations **are** case sensitive.


<hr style="margin-top:4em;">
Other JWRR projects
-------------------
* [carr](https://github.com/jwrr/carr) - C arrays. Support for large, dynamic
  arrays.  Lued uses this library as it's main data store.
* [efefomatic](https://github.com/jwrr/efefomatic) - Flat File web page cms.
  The main [JWRR site](http://jwrr.com) is implemented using efefomatic.  It's
  not much to look at, but it's mine.
* [vhdl examples](https://github.com/jwrr/vhdl_examples) - Example VHDL files.
  If you're interested in FPGAs and ASICs take a look.  I also have a
  [Verilog tutorial](http://jwrr.com/verilog).
* [My Gists](https://github.com/jwrr/gists) - it's easier to post here than on Github's gits site

<hr style="margin-top:4em;">







