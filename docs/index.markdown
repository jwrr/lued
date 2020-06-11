---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

What is it?
-----------

Lued is a text editor that runs in the console like [emacs](https://www.gnu.org/software/emacs/)
and [vim](https://www.vim.org/).  The goal is to be comfortable 
for Windows users.  Common Windows keystrokes are supported.  For example,
<kbd>Ctrl+C</kbd>, <kbd>Ctrl+X</kbd>, <kbd>Ctrl+V</kbd> do copy, cut and paste, 
respectively. <kbd>Ctrl+Z</kbd> and <kbd>Ctrl+Y</kbd> undo and redo. 
<kbd>Ctrl+S</kbd>, <kbd>Ctrl+Q</kbd> save and quit. You move arrow using the 
arrow keys. PgUp, PgDn, Home and End work as expected. For more advanced 
commands, Lued attempts to be similar to [Sublime](https://www.sublimetext.com/)
or [VScode](https://code.visualstudio.com/).  You can use the
mouse to copy and paste and the scroll wheel lets you easily navigate up
and down the document.
 
Lued is compatible with most xterms such as Konsole and Gnome Terminal. It also
works well with [PuTTy](https://www.chiark.greenend.org.uk/~sgtatham/putty/)
and [tmux](https://github.com/tmux/tmux).


Get it
------

Lued source code is available under the [MIT License](https://opensource.org/licenses/MIT)
at [github.com/jwrr/lued](http://github.com/jwrr/lued).  You can download a zip file or 
clone the repo.

<button class="favorite styled" type="button">
  <a href="https://github.com/jwrr/lued/archive/master.zip">Download Lued from Github</a>
</button>

```
git clone https://github.com/jwrr/lued
```

Build it
--------

To build Lued just run the <code>COMPILE</code> script.  The script handles downloading Lua 5.2, applying
a few minor patches to the Lua release, running cmake and compiling lued.

You will need cmake.  On Ubuntu you can install with apt-get.

```
sudo apt-get -y install cmake
```

Try it
------

```
> ./lued filename.txt
```


Use it
------

You've gotten this far and you haven't turned away.  You want to know more.
Lued offers many ways to move, select, find and delete. I recommend you first
take a quick look at the [key bindings](/bindings).  And then dive into the
[User Guide](/ug).


Tweak it
-----------------------

You can easily change the key bindings.  The key bindings are defined in file
`lua_src/bindings/lued_bindings.lua`.  The bindings have the format alt_xxx and
ctrl_yyy (these are actually lua function calls but don't worry about that).  To 
change a binding, just find it and replace it with what you want.  For example,
say you want to change the replace to end-of-line command from <kbd>alt+XE</kbd> to
<kbd>ctrl+K</kbd>, as it is in Emacs.  You would open the lued_bindings.lua file
(using lued or your editor of choice), find 'alt_xe', <kbd>ctrl+F</kbd> and change
it to 'ctrl_K'.  Now restart lued and you're good to go. BTW, <kbd>Ctrl+K</kbd>
is not currently used, and is waiting for you to make this change.


Extend it
---------

All commands are implemented in Lua (there's some C under the hood but you'll 
never see it... unless you want to).  Lua is an easy to learn scripting language that
is powerful and blazingly fast.  You can modify the Lua code directly or you 
can develop a plugin (also written in Lua).  The plugins support 
[emmet](https://emmet.io/) snippets where you type a user-defined tag followed 
by <kbd>Tab</kbd> and a pre-defined template is printed out.


Fix it
------

Submit your [pull requests](https://github.com/jwrr/lued/pulls). Thanks


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







