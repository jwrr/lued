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


#ifndef _CARR_READLINE_LUA_
#define _CARR_READLINE_LUA_
#include "carr_readline.h"

int lua_io_read(lua_State *L);
int lua_find_read(lua_State *L);
int lua_replace_read(lua_State *L);

int carr_readline_lua(char** buffer, const char* prmt);
int carr_readline_postprocessor(carr_t* c_str, uint32_t max_leading_spaces); 
carr_t* get_cmd_hist(); // from lua.c
int lua_set_hotkeys (lua_State *L);
int lua_get_hotkeys (lua_State *L);
int lua_set_repeatables (lua_State *L);
int lua_get_repeatables (lua_State *L);
int lua_set_non_repeatables (lua_State *L);
int lua_get_non_repeatables (lua_State *L);
int lua_interactive (lua_State *L, int argc, char **argv);

#ifndef LUA_MAXINPUT
#define LUA_MAXINPUT 51200
#endif

#endif
