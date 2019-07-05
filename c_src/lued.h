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


/// \file

#ifndef _LUED_H_
#define _LUED_H_

#include <stdlib.h>
#include <time.h>
#include "carr.h"

#define lua_reg(L,F1,F2) lua_pushcfunction(L, F1); lua_setglobal(L, F2 );

typedef struct lued_struct {
   carr_t*  text; // 2d carr array
   carr_t*  undo_str; // 2d carr array of char
   carr_t*  undo_cmd; // 1d carr array of char
   carr_t*  undo_row; // 1d carr array of uint32_t
   carr_t*  undo_col; // 1d carr array of uint32_t
   carr_t*  undo_end_row; // 1d carr array of uint32_t
   carr_t*  undo_end_col; // 1d carr array of uint32_t
   carr_t*  undo_start_row; // 1d carr array of uint32_t
   carr_t*  undo_start_col; // 1d carr array of uint32_t
   carr_t*  str; // 1d carr array of char;
   carr_t*  paste_str; // 1d carr array of char;
   carr_t*  find_str; // 1d carr array of char;
   carr_t*  mark_str; // 2d carr array of char
   carr_t*  mark_row; // 1d carr array of uint32_t
   carr_t*  mark_col; // 1d carr array of uint32_t
   uint32_t len; // number of characters (bytes)
   uint32_t cursor_row;
   uint32_t cursor_col;
   uint32_t page_row;
   uint32_t page_col;
   char*    filename;
   uint32_t sel_start_row;
   uint32_t sel_start_col;
   uint32_t sel_end_row;
   uint32_t sel_end_col;
   uint32_t sel_state; // 0=idle, 1=sel, 2=freeze, 3=blk_sel, 4=blk_freeze
   uint32_t save_it;
   uint32_t save_it_valid; // save_it goes invalid when it < save_it
   time_t   mtime;
   time_t   save_mtime;
   uint32_t show_line_numbers;
} lued_t;

int lued_main(int argc, char** argv);
int luedc_insertx(lued_t* l, uint32_t row, uint32_t col, char* str);

lued_t* luedc_open(const char* filename);
int luedc_numchar(lued_t* l, uint32_t* nchar);
int get_numlines(lued_t* l, uint32_t* nline);
char* get_page(uint32_t from_row, int highlight_trailing_spaces);
int luedc_close(lued_t* l);
int save_session(lued_t* session_p);
int luedc_overwrite(lued_t* l, uint32_t r, uint32_t c, char* s);
int luedc_insert(lued_t* l, uint32_t r, uint32_t c, char* s);
int luedc_extract(lued_t* l, uint32_t fr, uint32_t nr, char* s, uint32_t ss);
int luedc_get_cursor_position(lued_t* l, uint32_t* r, uint32_t* c);
int luedc_set_cursor_position(lued_t* l, uint32_t r, uint32_t c);

int luedc_find(const lued_t* l, uint32_t const fr, uint32_t const fc, char* const s, uint32_t* r, uint32_t* c, int* f);

int luedc_termsize(size_t* row, size_t* col);

#endif
