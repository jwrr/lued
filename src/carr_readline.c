/* 
MIT License

Copyright (c) 2018 jwrr

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


#include <unistd.h>
#include <termios.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <signal.h>

#include "cis.h"
#include "carr.h"
#include "carr_esc.h"

static void set_flag(int tru, tcflag_t FLAG)
{
   struct termios term;
   tcgetattr(STDIN_FILENO, &term);
   term.c_lflag = tru ? term.c_lflag | (FLAG) : term.c_lflag & ~(FLAG);
   tcsetattr(STDIN_FILENO, TCSAFLUSH, &term);
}

static void esc_append(char* str, size_t* i, char c) {
   if (*i >= ESC_MAXSIZE-1) return;
   if isEQ(c,ESC) *i = 0;
   str[(*i)++] = c;
   str[*i] = '\0';
}

static void cursor_left(carr_t* line, size_t n) {
   if isNULL(line) return;
   n = min(n, carr_i(line));
   if isZERO(n) return;
   printf(ESC_LEFT_N, n);
   fflush(stdout);
   carr_set_it(line, carr_i(line) - n);
}

static void cursor_home(carr_t* line) {
   if isNULL(line) return;
   cursor_left(line, carr_i(line));
}

static void cursor_right(carr_t* line, size_t n) {
   if isNULL(line) return;
   if (carr_validi(line)) printf(ESC_RIGHT_N, n);
   fflush(stdout);
   carr_set_it(line, carr_i(line) + n);
   // carr_nexti(line);
}

static void cursor_end(carr_t* line) {
   if isNULL(line) return;
   cursor_right(line, carr_len(line) - carr_i(line));
}

static void insert_char(carr_t* line, char c) {
   if isNULL(line) return;
   carr_inserti(line,&c,1);
   printf(ESC_ICH"%c",c);
   fflush(stdout);
}

static void delete_char(carr_t* line) {
   if isNULL(line) return;
   if (!carr_validi(line)) return;
   carr_deli(line, 1);
   printf(ESC_DELCHAR);
   fflush(stdout);
}

static void backspace(carr_t* line, size_t n) {
   if isNULL(line) return;
   if isZERO(carr_i(line)) return;
   cursor_left(line, 1);
   delete_char(line);
}

static void history_prev(carr_t* history, carr_t* line) {
   if isNULL(history) return;
   if (carr_i(history)) {
      if (carr_i(line)) printf(ESC_LEFT_N, carr_i(line));
      carr_t* hline;
      carr_get_previ(history, &hline);
      carr_dup(line, hline);
      printf("%s"ESC_CLR_EOL, line->arr);
      fflush(stdout);
   }
}

static void history_next(carr_t* history, carr_t* line) {
   if isNULL(history) return;
   if (carr_isleni(history)) return;
   if (carr_i(line)) printf(ESC_LEFT_N, carr_i(line));
   carr_nexti(history);
   if isEQ( carr_i(history), carr_len(history) ) {
      carr_set_len(line, 0);
   } else {
      carr_t* hline;
      carr_geti(history, &hline);
      carr_dup(line, hline);
      printf("%s", line->arr);
   }
   printf(ESC_CLR_EOL);
   fflush(stdout);
}

static int is_inlist(const char* keylist, const carr_t* line) {
   if isNULL(keylist) return 0;
   const uint32_t len = carr_len(line);
   if isZERO(len) return 0;
   if isEQ(*keylist, 'a') return 1; // all mode returns true
   char str[len+5];
   char* str_p = str;
   safe_strncpy(str_p, ",", 2); // add leading comma
   str_p++;
   safe_strncpy(str_p, line->arr, len+1);
   str_p+=len;
   safe_strncpy(str_p, ",", 2); // add trailing comma
   int found = strstr(keylist,str) ? 1 : 0;
   return found;
}

void raw_off() { set_flag(1, ICANON | ECHO); }
void raw_on() {
   // static int cnt = 0;
   // if isZERO(cnt) atexit(raw_off);
   // cnt = 1;
   set_flag(0, ICANON | ECHO);
}

char getchar_raw(char *ch)
{
//  raw_on();
   int err = (read(STDIN_FILENO, ch, 1) < 1);
//  raw_off();
   *ch = err ? '\0' : *ch;
   return *ch;
}

static void getchar_until(carr_t* dest, const char* match) {
   char c;
   while (1) {
      getchar_raw(&c);
      carr_push(dest, &c);
      if (strstr(dest->arr, match)) break;
   }
}

carr_t* carr_readline(const char* prompt, carr_t* history, const char* hotkeys, const char* repeatables, const char* non_repeatables)
{
   static int oneline_cmd = 0;
   static int repeat_oneline_cmd = 0;
   signal(SIGINT, SIG_IGN);
   signal(SIGHUP, SIG_IGN);
   signal(SIGTERM, SIG_IGN);
   signal(SIGTSTP, SIG_IGN);
   signal(SIGQUIT, SIG_IGN);
   carr_t* line = carrs_new();
   if isNULL(line) return NULL;
   char c;
   char esc[ESC_MAXSIZE];
   if (prompt) {
      printf("%s",prompt);
      fflush(stdout);
   }
   size_t esc_i = 0;
   size_t mouse_i = 0;
   carr_set_it(history, carr_len(history));

   int use_repeat_oneline_cmd = !isNULL(hotkeys);

   while (1) {
      getchar_raw(&c);
      // printf("[%d,'%c']", c, c); fflush(stdout); if isEQ(c,'q') break; continue;

      int custom_esc_sequence = isEQ(esc_i,1) && !isEQ(c,'[');
      if (custom_esc_sequence) {
         esc_i = 0;
         esc[0] = '\0';
         if (use_repeat_oneline_cmd) oneline_cmd = 1;
      }

      if isEQ(c,ESC)  {
         esc_i = 0;
         esc_append(esc, &esc_i, c);
      }

      int screen_mode = oneline_cmd ? 0 : !isNULL(hotkeys) && isEQ(*hotkeys, 'a');

      if isEQ(c,'\n') {
         if (screen_mode && (!use_repeat_oneline_cmd || !repeat_oneline_cmd)) {
            carr_inserti(line, "ins_str(\"", 9);
            carr_inserti(line, "\\n", 2);
            carr_inserti(line, "\")",2);
         }
         if (use_repeat_oneline_cmd && oneline_cmd) {
            oneline_cmd = 0;
            if (!is_inlist(non_repeatables,line)) {
               repeat_oneline_cmd = 1;
            }
         }
         break;
      }

      if (use_repeat_oneline_cmd) repeat_oneline_cmd = 0;

      if (esc_i) {
         esc_append(esc, &esc_i, c);
         int in_esc = 0;
         if isEQS(esc,ESC_UP) {
            if (screen_mode) {carr_inserti(line, "esc_up", 0); break; }
            history_prev(history, line);
         } else if isEQS(esc, ESC_DOWN) {
            if (screen_mode) {carr_inserti(line, "esc_down", 0); break; }
            history_next(history, line);
         } else if isEQS(esc, ESC_RIGHT) {
            if (screen_mode) {carr_inserti(line, "esc_right", 0); break; }
            cursor_right(line, 1);
         } else if isEQS(esc, ESC_LEFT) {
            if (screen_mode) {carr_inserti(line, "esc_left", 0); break; }
            cursor_left(line, 1);
         } else if isEQS(esc, ESC_INSERT) {
            if (screen_mode) {carr_inserti(line, "esc_insert", 0); break; }
         } else if isEQS(esc, ESC_SHIFT_DELETE) {
            if (screen_mode) {carr_inserti(line, "esc_shift_delete", 0); break; }
         } else if isEQS(esc, ESC_DELETE) {
            if (screen_mode) {carr_inserti(line, "esc_delete", 0); break; }
            delete_char(line);
         } else if isEQS(esc, ESC_HOME) {
            if (screen_mode) {carr_inserti(line, "esc_home", 0); break; }
            cursor_home(line);
         } else if isEQS(esc, ESC_END) {
            if (screen_mode) {carr_inserti(line, "esc_end", 0); break; }
            cursor_end(line);
         } else if isEQS(esc, ESC_PAGEUP) {
            if (screen_mode) {carr_inserti(line, "esc_pageup", 0); break; }
            cursor_end(line);
         } else if isEQS(esc, ESC_PAGEDOWN) {
            if (screen_mode) {carr_inserti(line, "esc_pagedown", 0); break; }
            cursor_end(line);
         } else if isEQS(esc, ESC_PASTESTART) {
            if (screen_mode) {
               carr_import(line, "ins_str([====[", 0);
               getchar_until(line, ESC_PASTESTOP);
               carr_set_len(line, carr_len(line) - strlen(ESC_PASTESTOP) );
               carr_import(line, "]====])",0);
               break;
            }
            cursor_end(line);
         } else if isEQS(esc, ESC_PASTESTOP) {
            if (screen_mode) {
               break;
            }
            cursor_end(line);
         } else if isEQS(esc, ESC_MOUSEEVENT) {
            // if (screen_mode) {carr_inserti(line, "esc_mousemove", 0); break; }
            mouse_i = 1;
            esc_i = 0;
            strcpy(esc, "esc_mouse([=[" );
            esc_i = strlen(esc);
            in_esc = 1;
         } else if (mouse_i==3) {
            in_esc = 0;
            mouse_i = 0;
            esc_append(esc, &esc_i, ']');
            esc_append(esc, &esc_i, '=');
            esc_append(esc, &esc_i, ']');
            esc_append(esc, &esc_i, ')');
            if (screen_mode) {
               carr_inserti(line, esc, 0);
               // carr_inserti(line, esc, 0);
               break;
            }
         } else {
            if (mouse_i > 0) mouse_i++;
            in_esc = 1;
         }
         if (!in_esc) {
            esc_i = 0;
            esc[0] = '\0';
         }
      } else if isEQ(c,BACKSPACE) {
         if (screen_mode) {carr_inserti(line, "esc_backspace", 0); break; }
         backspace(line, 1);
      } else if (isprint(c)) {
         if (screen_mode) {
            carr_resize(line, 0);
            carr_import(line, "ins_str([====[", 0);
            carr_import(line, &c, 1);
            carr_import(line, "]====])", 0);
            break;
         }
         insert_char(line, c);
         const uint32_t hotkeys_len = isNULL(hotkeys) ? 0 : strlen(hotkeys);
         const uint32_t hotkeys_size = hotkeys_len + 1;
         char local_hotkeys[hotkeys_size];
         safe_strncpy(local_hotkeys, hotkeys, hotkeys_size);
         if isEQ(*local_hotkeys, 'a') *local_hotkeys = ' ';
         if (is_inlist(local_hotkeys, line)) {
            if (use_repeat_oneline_cmd) {
               oneline_cmd = 0;
               if (!is_inlist(non_repeatables,line)) {
                  repeat_oneline_cmd = 1;
               }
            }
            break;
         }
      } else if (c <= 26) {
         carr_resize(line,0);
         c = c + 'A' - 1;
         // if isEQ(c, 'K') {
         //   oneline_cmd = 1;
         // } else {
            carr_inserti(line, "ctrl_", 5);
            carr_inserti(line, &c, 1);
            if (use_repeat_oneline_cmd && is_inlist(repeatables,line)) {
               repeat_oneline_cmd = 1;
            }
            break;
         // }
      } else {
         printf("{%d, %c}", c, c);
         fflush(stdout);
      }
   } // while
   // raw_off(); // moved to main
   cursor_end(line);
   // signal(SIGINT, SIG_DFL);

   if isZERO(carr_len(line)) {
      line = carr_free(line);
      if (carr_len(history)) {
         carr_get(history, carr_len(history) - 1, &line);
      }
   } else {
      carr_t* tail = NULL;
      carr_get_last(history, &tail);
      if (isNULL(tail) || !isEQS(tail->arr, line->arr)) carr_push(history, &line);
   }

   return line;
}

