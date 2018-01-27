/*
MIT License

Copyright (c) 2018 JWRR.COM

git clone https://github.com/jwrr/lued.git

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/


#ifndef _CARR_ESC_
#define _CARR_ESC_
#define ESC 27
#define ESC_UP       "\e[A"
#define ESC_DOWN     "\e[B"
#define ESC_RIGHT    "\e[C"
#define ESC_RIGHT_N  "\e[%dC"
#define ESC_LEFT     "\e[D"
#define ESC_LEFT_N   "\e[%dD"
#define ESC_GOHOME   "\e[H"
#define ESC_GOTO     "\e[%d;%dH"
#define ESC_INSERT   "\e[2~"
#define ESC_DELETE   "\e[3~"
#define ESC_SHIFT_DELETE "\e[3;2~"
#define ESC_ICH      "\e[@"
#define ESC_CLR_EOL  "\e[0K"
#define ESC_CLR_EOS  "\e[0J"
#define ESC_CLR_ALL  "\e[2J"
#define ESC_HOME     "\e[1;2D"
#define ESC_HOME2    "\eOH"
#define ESC_HOME3    "\e[1~"
#define ESC_HOME4    "\e[H"
#define ESC_END      "\e[1;2C"
#define ESC_END2     "\eOF"
#define ESC_END3     "\e[4~"
#define ESC_END4     "\e[F"
#define ESC_PAGEDOWN "\e[1;2B"
#define ESC_PAGEDOWN2 "\e[6~"
#define ESC_PAGEUP   "\e[1;2A"
#define ESC_PAGEUP2  "\e[5~"
#define ESC_DELCHAR  "\e[1P"
#define ESC_CHA      "\e[%dG"
#define ESC_NORMAL   "\e[0m"
#define ESC_BOLD     "\e[1m"
#define ESC_UNDER    "\e[4m"
#define ESC_BLINK    "\e[5m"
#define ESC_REVERSE  "\e[7m"
#define ESC_MAXSIZE  30
#define BACKSPACE    127

#define ESC_ALTSCREEN "\e[?47;h"
#define ESC_NORMSCREEN "\e[?47;l"

#define ESC_MOUSEENABLE "\e[?1000h"
// # define ESC_MOUSETRACK  "\e[1002;1;1;1;80T"
#define ESC_MOUSEEVENT  "\e[M"

#define ESC_PASTEON    "\e[?2004h"
#define ESC_PASTEOFF   "\e[?2004l"
#define ESC_PASTESTART "\e[200~"
#define ESC_PASTESTOP  "\e[201~"

/*
ESC [ Ps ;...; Ps h             Set Mode
     ESC [ Ps ;...; Ps l             Reset Mode
           Ps = 4            (A)     Insert Mode
                20           (A)     Automatic Linefeed Mode.
                34                   Normal Cursor Visibility
                ?1           (V)     Application Cursor Keys
                ?3           (V)     Change Terminal Width to 132 columns
                ?5           (V)     Reverse Video
                ?6           (V)     Origin Mode
                ?7           (V)     Wrap Mode
                ?9                   X10 mouse tracking
                ?25          (V)     Visible Cursor
                ?47                  Alternate Screen (old xterm code)
                ?1000        (V)     VT200 mouse tracking
                ?1047                Alternate Screen (new xterm code)
                ?1049                Alternate Screen (new xterm code)

Normal tracking mode
It is enabled by specifying parameter 1000 to DECSET.  On button press or
release, xterm sends CSI M CbCxCy. xterm sends CSI M CbCxCy (3 characters).
o   The low two bits of Cb encode button information: 0=MB1 pressed,
    1=MB2 pressed, 2=MB3 pressed, 3=release.
o   The next three bits encode the modifiers which were down when the
    button was pressed and are added together:  4=Shift, 8=Meta, 16=Con-
    trol.

=================


#define ESC_MOUSETRACKING "\e[1002;1;1;1;80T"
CSI Ps ; Ps ; Ps ; Ps ; Ps T .
The parameters are func, startx, starty, firstrow, and lastrow.
func is non-zero to initiate highlight tracking and zero to abort.
startx and starty give the starting x and y location for the highlighted region.
The ending location tracks the mouse, but will never be above row firstrow and
will always be above row lastrow. (The top of the screen is row 1.

#define ESC_MOUSE1EVENT   "\e[M@"
CSI M @ Cx Cy . ( @ = 32 + 0 (button 1) + 32 (motion indicator)

*/

#endif
