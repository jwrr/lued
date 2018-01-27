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


#include "headers.h"
#include "carr.h"
#include "carr_readline.h"
#include "carr_readline_lua.h"

// =========================================================

char hotkeys[LUA_MAXINPUT] = "";
int lua_set_hotkeys(lua_State *L) {
   strncpy(hotkeys, lua_tostring(L,1), LUA_MAXINPUT);
   return 0;
}

int lua_get_hotkeys(lua_State *L) {
   lua_pushstring(L,hotkeys);
   return 1;
}

// =========================================================

char repeatables[LUA_MAXINPUT] = ",ctrl_F,";
int lua_set_repeatables(lua_State *L) {
   strncpy(repeatables, lua_tostring(L,1), LUA_MAXINPUT);
   return 0;
}

int lua_get_repeatables(lua_State *L) {
   lua_pushstring(L,repeatables);
   return 1;
}

// =========================================================

char non_repeatables[LUA_MAXINPUT] = ",bo,sb,se,sl,sw,to,";
int lua_set_non_repeatables(lua_State *L) {
   strncpy(non_repeatables, lua_tostring(L,1), LUA_MAXINPUT);
   return 0;
}

int lua_get_non_repeatables(lua_State *L) {
   lua_pushstring(L,non_repeatables);
   return 1;
}

// =========================================================

carr_t* cmd_hist = NULL; // *******
carr_t* get_cmd_hist() {
   return cmd_hist;
}

int carr_readline_lua(char** line, const char* prmt) {
   *line = NULL;
   if isNULL(cmd_hist) cmd_hist = carrp_new();
   carr_t* c_line = NULL;
   c_line = carr_readline(prmt,1,cmd_hist,hotkeys,repeatables,non_repeatables);
   if isNULL(c_line) return 0;
   carr_readline_postprocessor(c_line,1);

   int l_size = carr_len(c_line) + 100;
   char* l = malloc(l_size * sizeof(char));
   if isNULL(l) return 0;
   safe_strncpy(l, c_line->arr, l_size);
   *line = l;
   return 1;
}

// =========================================================

carr_t* io_hist = NULL; // *******

const carr_t* carr_readline_io(const char* prmt, const char* hot) {
   if isNULL(io_hist) io_hist = carrp_new();
   const carr_t* c_str = carr_readline(prmt, 0, io_hist, hot, NULL, NULL);
   return c_str;
}

int lua_io_read(lua_State *L) {
   const char* prompt  = lua_gettop(L)>0 ? lua_tostring(L, 1) : NULL;
   // const char* hist_id = lua_gettop(L)>1 ? lua_tostring(L, 2) : NULL;
   const char* hot     = lua_gettop(L)>2 ? lua_tostring(L, 3) : NULL;
   const carr_t* c_str = carr_readline_io(prompt, hot);
   if (c_str) {
      lua_pushstring(L, c_str->arr);
   } else {
      lua_pushstring(L, "");
   }

   return 1;
}

// =========================================================

carr_t* find_hist = NULL; // *******

carr_t* carr_readline_find(const char* prmt) {
   if isNULL(find_hist) find_hist = carrp_new();
   carr_t* c_str = carr_readline(prmt, 1, find_hist, NULL, NULL, NULL);
   return c_str;
}

int lua_find_read(lua_State *L) {
   const char* prompt = lua_tostring(L, 1);
   const carr_t* c_str = carr_readline_find(prompt);
   if (c_str) {
      lua_pushstring(L, c_str->arr);
   } else {
      lua_pushstring(L, "");
   }
   return 1;
}

// =========================================================

carr_t* replace_hist = NULL; // *******

carr_t* carr_readline_replace(const char* prmt) {
   if isNULL(replace_hist) replace_hist = carrp_new();
   carr_t* c_str = carr_readline(prmt, 1, replace_hist, NULL, NULL, NULL);
   return c_str;
}

int lua_replace_read(lua_State *L) {
   const char* prompt = lua_tostring(L, 1);
   const carr_t* c_str = carr_readline_replace(prompt);
   if (c_str) {
      lua_pushstring(L, c_str->arr);
   } else {
      lua_pushstring(L, "");
   }
   return 1;
}

// =========================================================
/*
carr_t* open_files = NULL; // *******

int carr_readline_open_files(const char* prmt) {
   if isNULL(open_files) open_files = carrp_new();
   carr_t* c_str = carr_readline(prmt, 0, open_files, NULL, NULL, NULL);
   return c_str;
}

int lua_find_read(lua_State *L) {
   const char* prompt = lua_tostring(L, 1);
   const carr_t* c_str = carr_readline_find(prompt);
   if (c_str) {
      lua_pushstring(L, c_str->arr);
   } else {
      lua_pushstring(L, "");
   }
   return 1;
}
*/
// =========================================================

static int is_inrange(char ch, char lower, char upper) {
   return (lower <= ch) && (ch <= upper);
}

static char *get_word(char* str) {
   if (str == NULL) return str;
   char *p = str;
   int letter_found = 0;
   int under_found = 0;
   int cnt = 0;
   while (*p) {
      int is_long_cmd = (cnt > 4);
      int is_letter = is_inrange(*p, 'a', 'z') ||
         is_inrange(*p, 'A', 'Z');
      int is_digit = is_inrange(*p, '0', '9') && letter_found &&
         (is_long_cmd || under_found);
      // int is_underscore =  ('_' == *p) && letter_found;
      int is_underscore =  ('_' == *p);
      under_found |= is_underscore;
      letter_found |= is_letter;
      int valid = is_letter || is_digit || is_underscore;
      if (!valid) return p;
      p++;
   }
   return p;
}

static char *get_number_or_comma(char* str) {
   if (str == NULL) return str;
   char *p = str;
   int digit_found = 0;
   while (*p) {
      int is_digit = is_inrange(*p, '0', '9');
      int is_comma =  (',' == *p) && digit_found;
      digit_found |= is_digit;
      int valid = is_digit || is_comma;
      if (!valid) return p;
      p++;
   }
   return p;
}

static int just_a_number(carr_t* str) {
   if isNULL(str) return 0;
   if isZERO(str->arr) return 0;

   int i = 0;
   for (; i < carr_len(str); i++) {
      char ch;
      carr_get(str, i, &ch);
      if (isEQ(ch,'\n') && isZERO(i)) return 0;
      if isEQ(ch,'\n') break;
      if (ch < '0' || '9' < ch) return 0;
   }

   carr_set_it(str, 0);
   carr_inserti(str, "goto_line(", 0);
   carr_set_it(str, carr_len(str) );
   carr_inserti(str, ")", 0);
   return 1;
}

static size_t subst(char* from, const char* to, carr_t* c_str) {
   if isNULL(from) return 0;
   if isNULL(to) return 0;
   if isNULL(c_str) return 0;
   uint32_t from_len = strlen(from);
   uint32_t to_len = strlen(to);
   char* str = c_str->arr;
   if isNULL(str) return 0;
   uint32_t c_str_len = carr_len(c_str);
   if (isZERO(c_str_len) || isEQ(str[0],' ')) return 0;

   char* oparen = strstr(str,"(");
   char* squote = strstr(str,"'");
   char* dquote = strstr(str,"\"");
   char* last = oparen;
   if (isNULL(last) || (!isNULL(squote) && squote < last)) last = squote;
   if (isNULL(last) || (!isNULL(dquote) && dquote < last)) last = dquote;

   size_t count = 0;
   char* p = strstr(str,from);
   while (p) {
      if (last && p >= last) break;
      uint32_t p_offset = p - str;
      carr_set_it(c_str, p_offset);
      carr_deli(c_str, from_len);
      carr_inserti(c_str, to, 0);
      last += (to_len - from_len);

      /// del_char(p,1);
      /// insert_string(p, to, LUA_MAXINPUT-16);
      p = strstr(str,from);
      count++;
   }
   return count;
}

static void special_char(carr_t* str) {
   subst("~", "_tilde_", str);
   subst("`", "_backtick_", str);
   subst("!", "_emark_", str);
   subst("@", "_at_", str);
   subst("#", "_pound_", str);
   subst("$", "_dollar_", str);
   subst("%", "_percent_", str);
   subst("^", "_caret_", str);
   subst("&", "_amp_", str);
   subst("*", "_star_", str);
   // subst("(", "_oparen_", str);
   // subst(")", "_cparen_", str);
   subst("-", "_minus_", str);
   subst("+", "_plus_", str);
   subst("=", "_equal_", str);
   subst("{", "_obrace_", str);
   subst("}", "_cbrace_", str);
   subst("[", "_obracket_", str);
   subst("]", "_cbracket_", str);
   subst("|", "_vbar_", str);
   // subst("\\", "_backslash_", str);
   subst(":", "_colon_", str);
   subst(";", "_semi_", str);
   // subst("\"", "_dquote_", str);
   // subst("'", "_squote_", str);
   subst("<", "_lt_", str);
   subst(">", "_gt_", str);
   //subst(",", "_comma_", str);
   subst(".", "_period_", str);
   subst("?", "_qmark_", str);
   subst("/", "_slash_", str);
}

int carr_readline_postprocessor(carr_t* c_str, uint32_t max_leading_spaces) {
   if isNULL(c_str) return 0;

   carr_set_it(c_str, 0);
   char ch;
   carr_geti(c_str,&ch);
   int i = 0;
   for (;i++ < max_leading_spaces && isEQ(ch,' '); carr_nexti(c_str)) {
      carr_geti(c_str,&ch);
   }
   if (!carr_validi(c_str)) return 0;
   if (just_a_number(c_str)) return 4; // goto_line
   special_char(c_str);

   char* p = get_word(c_str->arr);
   char* str = c_str->arr;
   if (isEQ(p,str) && *p != '\'' && *p!='"' && *p!='/') return 0; // line does not start with command. do nuthing.

   uint32_t index = p - str;
   carr_set_it(c_str, index);

   // Handle simple command with no arguments. Add empty parentheses.
   if ( isEQ(*p, '\n') || isEQ(*p, '\0') ) {
      if isEQ(*p, '\n') carr_deli(c_str,1);
      carr_inserti(c_str, "()", 0);
      return 1;
   }

   // command with string argument.
   // 'lua rocks -> _squote("lua rocks")
   // f"lua rocks -> f_dquote("lua rocks")
   int is_squote = ('\'' == *p);
   int is_dquote = ('"' == *p);
   int is_fslash = ('/' == *p);
   if (is_squote || is_dquote || is_fslash) {
      carr_deli(c_str, 1);
      if (is_squote) {
         carr_inserti(c_str, "_squote([=====[", 0);
      } else if (is_dquote) {
         carr_inserti(c_str, "_dquote([=====[", 0);
      } else {
         carr_inserti(c_str, "_fslash([=====[", 0);
      }
      while (*p != '\n' && *p != '\0') p++;
      index = p - str;
      carr_set_it(c_str, index);
      if isEQ(*p, '\n') carr_deli(c_str,1);
      carr_inserti(c_str, "]=====])", 0);
      return 2;
   }

   int is_digit = is_inrange(*p, '0', '9');
   int is_space = (' ' == *p);
   int args_available = is_space || is_digit;
   if (!args_available) return 0;
   char *first_space = p;
   if (is_space) p++;

   char *start_arg = p;
   p = get_number_or_comma(start_arg);
   if (p == start_arg) return 0; // no arguments found. do nuthing

   // Handle simple command with comma separated arguments (no embedded spaces)
   // Add parentheses around arguments.
   if ( isEQ(*p,'\n') || isEQ(*p,'\0') ) {
      index = p - str;
      carr_set_it(c_str, index);
      if isEQ(*p, '\n') carr_deli(c_str,1);
      carr_inserti(c_str, ")", 0);
      index = first_space - str;
      carr_set_it(c_str, index);
      carr_inserti(c_str, "(", 0);
      return 3;
   }

   // Not a simple command. do nuthing
   return 0;
}


