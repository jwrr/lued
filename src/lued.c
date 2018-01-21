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




#include "headers.h"

#define LUED_SELOFF 0
#define LUED_SELEND 1
#define LUED_SELENDBLK 2
#define LUED_SELON 3
#define LUED_SELONBLK 4

carr_t* LUED_SESSIONS;


static lued_t* get_session(carr_t* all_sessions) {
   if isNULL(all_sessions) return NULL;
   if isZERO(carr_len(all_sessions)) return NULL;
   uint32_t it = min(carr_i(all_sessions), carr_len(all_sessions) - 1);
   carr_set_it(all_sessions, it);
   lued_t* session_p = NULL;
   carr_geti(all_sessions, &session_p);
   return session_p;
}

static carr_t* get_text(carr_t* all_sessions) {
   lued_t* session_p = get_session(all_sessions);
   if isNULL(session_p) return NULL;
   carr_t* text_p = session_p->text;
   return text_p;
}

static carr_t* get_carr_line(carr_t* all_sessions) {
   carr_t* text_p = get_text(all_sessions);
   if isNULL(text_p) return NULL;
   carr_t* line_p = NULL;
   carr_geti(text_p, &line_p);
   return line_p;
}

static const char* get_line(carr_t* all_sessions) {
   carr_t* line_p = get_carr_line(all_sessions);
   if isNULL(line_p) return NULL;
   return line_p->arr;
}

static int lua_get_line(lua_State* L) {
   const char* line = get_line(LUED_SESSIONS);
   lua_pushstring(L, line);
   return 1;
}

static time_t get_file_modified(const char* filename) {
   if isNULL(filename) return 0;
   struct stat fstat;
   stat(filename, &fstat);
   time_t modified_time = fstat.st_mtime;
   return modified_time;
}

static int is_file_modified(lued_t* session_p, int use_save_mtime) {
   if isNULL(session_p) return 0;
   time_t mtime = get_file_modified(session_p->filename);
   time_t timestamp = use_save_mtime ? session_p->save_mtime : session_p->mtime;
   int is = (mtime > timestamp) ? 1 : 0;
   if (is) {
     if (session_p) session_p->mtime = mtime;
   }
   return is;
}

int lua_is_file_modified(lua_State* L) {
   if isNULL(L) return 0;
   int use_save_mtime = lua_tonumber(L,1);
   lued_t* session_p = get_session(LUED_SESSIONS);
   if isNULL(session_p) return 0;
   int is = is_file_modified(session_p,use_save_mtime);
   time_t mtime = get_file_modified(session_p->filename);
   lua_pushnumber(L,is);
   lua_pushnumber(L,mtime);
   lua_pushnumber(L,session_p->mtime);
   return 3;
}

int prompt(char* question, char* response, size_t size)
{
   printf("%s: ",question);
   int valid = (fgets(response, size, stdin) != NULL);
   if (!valid) return 0;

   int i;
   for (i=0; response[i]!='\0' && i < size-1; i++) {
      if (response[i] == '\n') break;
   }
   response[i] = '\0';
   return (i > 0);
}

int lua_set_color(lua_State *L)
{
   int color = lua_tonumber(L, 1);
   printf("IN C: set_color: color = %d\n", color);
   return 0;
}

static int get_termsize(size_t* row, size_t* col)
{
   *row = *col = 0;
   struct winsize w;
   ioctl(0, TIOCGWINSZ, &w);
   *row = w.ws_row - 3;
   *col = w.ws_col;
   return 0;
}

int lua_get_termsize(lua_State* L)
{
   size_t row, col;
   get_termsize(&row, &col);
   lua_pushnumber(L, row);
   lua_pushnumber(L, col);
   return 2;
}

int set_cursor_position(lued_t* l, uint32_t r, uint32_t c)
{
   if isNULL(l) return 1;
   carr_t* text = l->text;
   if isNULL(text) return 1;

   uint32_t row_old = l->cursor_row;
   uint32_t row_offset = l->cursor_row - l->page_row;

   carr_set_it(text, r);
   l->cursor_row = carr_i(text);

   carr_t* carr_line = NULL;
   carr_geti(text, &carr_line);
   carr_set_it(carr_line, c);
   l->cursor_col = c; // carr_i(carr_line);

   size_t rows, cols;
   get_termsize(&rows, &cols);
   int page_change = 0;
   if (l->cursor_row < row_old) {
      uint32_t row_delta = row_old - l->cursor_row;
      page_change = (row_delta > row_offset);
   } else if (l->cursor_row > row_old) {
      uint32_t row_delta = l->cursor_row - row_old;
      page_change = (row_offset + row_delta >= rows);
   }

   if (page_change) {
      if (l->cursor_row > row_offset) {
         l->page_row = l->cursor_row - row_offset;
      } else {
         l->page_row = 0;
      }
   }
   return 0;
}

static int set_cur_pos(uint32_t row, uint32_t col) {
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   set_cursor_position(session_p, row, col);
   return 0;
}

static int lua_set_cur_pos(lua_State* L) {
   if isNULL(L) return 0;
   double rdouble = lua_tonumber(L, 1);
   double cdouble = lua_tonumber(L, 2);
   uint32_t r = (rdouble < 1) ? 1 : rdouble;
   uint32_t c = (cdouble < 1) ? 1 : cdouble;
   set_cur_pos(r-1, c-1);
   return 0;
}

int lued_insertx(lued_t* l, uint32_t row, uint32_t col, char* str)
{
    if isNULL(l) return 1;
    if isNULL(str) return 0;
    uint32_t r = min(row, l->text->len - 1);
    carr_t* carr_line;
    carr_get(l->text, r, &carr_line);
    carr_insert(carr_line, str, 0, col);
    return 0;
}

lued_t* lued_open(carr_t* all_sessions, const char* filename)
{
   if isNULL(filename) return NULL;
   carr_t* s1 = carr_read(filename);
   uint32_t s1_len = carr_len(s1);
   carr_t* text = carrp_new();
   carr_t* delims = carrs_init("\n");
   carr_split(text, s1, delims);
   carr_free(delims);
   carr_free(s1);

   lued_t* l = malloc(sizeof(lued_t));  if isNULL(l) return NULL;
   l->undo_str = carrp_new();   if isNULL(l->undo_str) return NULL;
   l->undo_cmd = carrs_new();   if isNULL(l->undo_cmd) return NULL;
   uint32_t usize = sizeof(uint32_t);
   l->undo_row = carr_new(0,usize); if isNULL(l->undo_row) return NULL;
   l->undo_col = carr_new(0,usize); if isNULL(l->undo_col) return NULL;
   l->undo_end_row = carr_new(0,usize); if isNULL(l->undo_end_row) return NULL;
   l->undo_end_col = carr_new(0,usize); if isNULL(l->undo_end_col) return NULL;
   l->undo_start_row = carr_new(0,usize); if isNULL(l->undo_start_row) return NULL;
   l->undo_start_col = carr_new(0,usize); if isNULL(l->undo_start_col) return NULL;
   l->str = carrs_new();        if isNULL(l->str) return NULL;
   l->paste_str = carrs_new();  if isNULL(l->paste_str) return NULL;
   l->find_str = carrs_new();   if isNULL(l->find_str) return NULL;
   l->mark_str = carrp_new();   if isNULL(l->mark_str) return NULL;
   l->mark_row = carr_new(0,usize); if isNULL(l->mark_row) return NULL;
   l->mark_col = carr_new(0,usize); if isNULL(l->mark_col) return NULL;

   l->text = text;
   l->len = s1_len;
   l->cursor_row = 0;
   l->cursor_col = 0;
   l->page_row = 0;
   l->page_col = 0;
   l->filename = malloc(strlen(filename)+1);
   strcpy(l->filename, filename);
   l->sel_start_row = 0;
   l->sel_start_col = 0;
   l->sel_end_row = 0;
   l->sel_end_col = 0;
   l->sel_state = 0; // 0=idle, 1=sel, 2=freeze, 3=blk_sel, 4=blk_freeze
   l->save_it = 0;
   l->save_it_valid = 1;
   l->save_mtime = get_file_modified(filename);
   l->mtime = l->save_mtime;
   l->show_line_numbers = 0;
   carr_push(all_sessions, &l);
   return l;
}

static void set_show_line_numbers(lued_t* session_p, uint32_t val) {
   if isNULL(session_p) return;
   session_p->show_line_numbers = val;
}

static int lua_set_show_line_numbers(lua_State* L) {
   uint32_t val = lua_tonumber(L,1);
   lued_t* session_p = get_session(LUED_SESSIONS);
   if isNULL(session_p) return 0;
   set_show_line_numbers(session_p, val);
   return 0;
}

int lua_lued_open(lua_State* L)
{
   const char* filename = lua_tostring(L, 1);
   lued_t* new_session = lued_open(LUED_SESSIONS, filename);
   if (new_session) {
     lua_pushnumber(L, carr_len(LUED_SESSIONS) );
     return 1;
   } else {
     return 0;
   }
}

lued_t* reopen(carr_t* all_sessions)
{
   lued_t* l = get_session(all_sessions);
   if isNULL(l) return NULL;
   carr_free2d(l->text);

   carr_t* s1 = carr_read(l->filename);
   uint32_t s1_len = carr_len(s1);
   carr_t* text = carrp_new();
   carr_t* delims = carrs_init("\n");
   carr_split(text, s1, delims);
   carr_free(delims);
   carr_free(s1);

   l->save_mtime = get_file_modified(l->filename);
   l->mtime = l->save_mtime;
   l->len = s1_len;
   l->text = text;
   return l;
}

int lua_reopen(lua_State* L)
{
   reopen(LUED_SESSIONS);
   return 0;
}


uint32_t get_numchar(lued_t* session_p)
{
   if isNULL(session_p) return 0;
   return session_p->len;
}

int lua_get_numchar(lua_State* L)
{
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   const uint32_t numchar = get_numchar(session_p);
   lua_pushnumber(L, numchar);
   return 1;
}

int get_numlines(lued_t* l, uint32_t* numlines)
{
   *numlines = 0;
   if isNULL(l) return 1;
   *numlines = carr_len(l->text);
   return 0;
}

int lua_get_numlines(lua_State* L)
{
   uint32_t numlines = 0;
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   get_numlines(session_p, &numlines);
   lua_pushnumber(L, numlines);
   return 1;
}

int get_numsessions(carr_t* all_sessions, uint32_t* numsessions)
{
   *numsessions = 0;
   if isNULL(all_sessions) return 1;
   *numsessions = carr_len(all_sessions);
   return 0;
}

int lua_get_numsessions(lua_State* L)
{
   uint32_t numsessions = 0;
   get_numsessions(LUED_SESSIONS, &numsessions);
   lua_pushnumber(L, numsessions);
   return 1;
}

int save_session(lued_t* session_p)
{
   if isNULL(session_p) return 1;
   int err = carr_write2d(session_p->text, session_p->filename);
   session_p->save_mtime = get_file_modified(session_p->filename);
   session_p->mtime = session_p->save_mtime;
   session_p->save_it = session_p->undo_str->it;
   session_p->save_it_valid = 1;
   return err;
}

int lua_save_session(lua_State* L) {
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   save_session(session_p);
   return 0;
}

static void free_session(lued_t* session_p) {
   carr_free2d(session_p->text);
   carr_free2d(session_p->undo_str);
   carr_free(session_p->undo_cmd);
   carr_free(session_p->undo_row);
   carr_free(session_p->undo_col);
   carr_free(session_p->undo_end_row);
   carr_free(session_p->undo_end_col);
   carr_free(session_p->undo_start_row);
   carr_free(session_p->undo_start_col);
   carr_free(session_p->str);
   carr_free(session_p->paste_str);
   carr_free(session_p->find_str);
   carr_free2d(session_p->mark_str);
   carr_free(session_p->mark_row);
   carr_free(session_p->mark_col);
}

static void close_session(carr_t* all_sessions) {
   lued_t* session_p = get_session(all_sessions);
   if isNULL(session_p) {
      printf("\n\n");
      exit(0); // exit program if there are no sessions
   }
   free_session(session_p);
   carr_deli(all_sessions, 1);
   if (!isZERO(all_sessions->len) && isEQ(all_sessions->it, all_sessions->len)) {
      carr_set_it(all_sessions, carr_len(all_sessions) - 1);
   }
}

int lua_close_session(lua_State* L) {
   close_session(LUED_SESSIONS);
   return 0;
}

int luedc_overwrite(lued_t* l, uint32_t r, uint32_t c, char* s)
{
   if isNULL(l) return 1;
   if (isNULL(l->text) && (r > 0 || c > 0)) return 1;
   carr_t* line;
   carr_get(l->text, r, &line);
   carr_overwrite(line, s, 0, c);
   return 0;
}

int luedc_insert(lued_t* l, uint32_t r, uint32_t c, char* s)
{
   if isNULL(l) return 1;
   if (isNULL(l->text) && (r > 0 || c > 0)) return 1;
   carr_t* line;
   carr_get(l->text, r, &line);
   carr_insert(line, s, 0, c);
   return 0;
}

static int get_sel(lued_t* l, uint32_t* sel_st,
                   uint32_t* sel_sr, uint32_t* sel_sc,
                   uint32_t* sel_er, uint32_t* sel_ec)
{
   if (sel_st) *sel_st = l->sel_state;
   *sel_sr = l->sel_start_row;
   *sel_er = l->sel_end_row;
   *sel_sc = l->sel_start_col;
   *sel_ec = l->sel_end_col;
   if isNULL(l) return 0;
   if ((*sel_sr > *sel_er) || (isEQ(*sel_sr,*sel_er) && *sel_sc > *sel_ec)) {
      *sel_sr = l->sel_end_row;
      *sel_er = l->sel_start_row;
      *sel_sc = l->sel_end_col;
      *sel_ec = l->sel_start_col;
   }
   return 0;
}

static int get_cursor_position(lued_t* l, uint32_t* r, uint32_t* c) {
   *r = *c = 0;
   if isNULL(l) return 1;
   *r = l->cursor_row;
   *c = l->cursor_col;
   return 0;
}

static void get_cur_pos(uint32_t* row, uint32_t* col) {
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   get_cursor_position(session_p, row, col);
}

static int lua_get_cur_pos(lua_State* L)
{
   uint32_t row, col;
   get_cur_pos(&row, &col);
   lua_pushnumber(L, row+1);
   lua_pushnumber(L, col+1);
   return 2;
}

uint32_t my_strcpy(char* base, uint32_t offset, const char* src, uint32_t max_size) {
   if isNULL(src) return 0;
   if (max_size != 0 && offset >= max_size) return 0;
   uint32_t max_len = max_size - 1;
   char* dest = base + offset;
   uint32_t cnt = 0;
   while (isZERO(max_size) || offset < max_len) {
      if (base) *dest++ = *src;
      if isZERO(*src) break;
      src++;
      offset++;
      cnt++;
   }
   if (base) *dest = '\0';
   return cnt;
}

static int find_trailing_space(carr_t* line, uint32_t* col) {
   uint32_t len = carr_len(line);
   if isZERO(len) return 0;
   char* str = line->arr;
   for (uint32_t i = len; i > 0; i--) {
      if (!isspace(str[i-1])) {
        *col = i;
        return (i<len);
      }
   }
   *col = 0;
   return 1;
}

size_t count_char(const char* str, const int start, const int end) {
   size_t count = 0;
   for (int i = start; i < end; i++) count += isEQ(str[i],'\t');
   return count;
}

size_t tab_size(const char* str, size_t offset) {
   size_t tab_size = 8;
   size_t actual_tab_size = 0;
   size_t actual_offset = 0;
   for (int i=0; i<=offset; i++) {
      if isEQ(str[i],'\t') {
         actual_tab_size = tab_size - (actual_offset % tab_size);
         actual_offset += actual_tab_size;
      } else {
         actual_offset++;
      }
   }
   return actual_tab_size;
}

int luedc_get_page(lued_t* l, uint32_t from_row, uint32_t num_rows,
                   char* dest, uint32_t dest_size, int highlight_trailing_spaces)
{
   if (!isNULL(dest)) dest[0] = '\0';
   if isNULL(l) return 0;
   if isZERO(num_rows) return 0;
   carr_t* text = l->text;
   if isNULL(text) return 0;

   uint32_t sel_state, sel_sr, sel_sc, sel_er, sel_ec;
   get_sel(l, &sel_state, &sel_sr, &sel_sc, &sel_er, &sel_ec);

   uint32_t count = 0;
   const char* cr = "\n";
   uint32_t dest_len = 0;
   int selon = isEQ(sel_state, LUED_SELON) || isEQ(sel_state, LUED_SELEND);
   // int selonblk = isEQ(sel_state, LUED_SELONBLK) || isEQ(sel_state, LUED_SELENDBLK);
   // dest_len += my_strcpy(dest, dest_len, ESC_REVERSE, dest_size);
   size_t term_rows, term_cols;
   term_rows = term_cols = 0;
   get_termsize(&term_rows, &term_cols);
   uint32_t cur_row, cur_col;
   get_cur_pos(&cur_row, &cur_col);
   uint32_t to_row = from_row + num_rows;
   uint32_t wrap_count = 0;
   for (uint32_t line_number = from_row; line_number <= to_row; line_number++) {
      if (line_number >= carr_len(text)) break;
      carr_t* line;
      carr_get(text, line_number, &line);
      uint32_t wc = carr_len(line) / term_cols;
      if (count + wrap_count + wc > num_rows) break;
      count++;
      wrap_count += wc;

      if (l->show_line_numbers) {
         uint32_t tmp = to_row;
         uint32_t digit_cnt = 2;
         while (tmp > 10) {
            digit_cnt++;
            tmp /= 10;
         }
         char line_number_str[16] = "";
         sprintf(line_number_str,"%*d: ", digit_cnt, line_number+1);
         dest_len += my_strcpy(dest, dest_len, line_number_str, dest_size); // start line
      }

      bool turn_selon = false;
      uint32_t turn_selon_at = 0;
      uint32_t turn_seloff_at = 0;
      if (selon) {
         if ((sel_sr < line_number) && (line_number < sel_er)) {
            turn_selon = true;
            turn_selon_at = 0;
         } else if ((sel_sr < line_number) && isEQ(line_number, sel_er) && (sel_ec > 0)) {
            turn_selon = true;
            turn_selon_at = 0;
         } else if (isEQ(sel_sr, line_number) && (sel_er > sel_sr || sel_ec > 0)) {
            turn_selon = true;
            turn_selon_at = sel_sc;
         }
      } else if (highlight_trailing_spaces && !isEQ(line_number,cur_row)) {
         turn_selon = find_trailing_space(line, &turn_selon_at);
         turn_seloff_at = carr_len(line);
         if isZERO(turn_selon_at) turn_selon = 0;
      }

      if (selon && turn_selon) {
         if ((sel_er > line_number)) {
            turn_seloff_at = carr_len(line);
         } else if isEQ(sel_er, line_number) {
            turn_seloff_at = min(sel_ec, carr_len(line));
         }
      }

      char* src_ptr = line->arr;
      uint32_t offset = 0;
      if (turn_selon) {
         uint32_t src_len = turn_selon_at;
         uint32_t max_size = min(dest_size, dest_len+src_len+1);
         dest_len += my_strcpy(dest, dest_len, src_ptr, max_size); // start line
         dest_len += my_strcpy(dest, dest_len, ESC_REVERSE, dest_size);
         src_ptr += src_len;
         src_len = turn_seloff_at - turn_selon_at;
         max_size = min(dest_size, dest_len+src_len+1);
         dest_len += my_strcpy(dest, dest_len, src_ptr, max_size);
         dest_len += my_strcpy(dest, dest_len, ESC_NORMAL, dest_size);
         src_ptr += src_len;
         offset = src_ptr - line->arr;
      }
      if (isEQ(line_number, carr_i(text)) && (offset <= carr_i(line)) ) {
         uint32_t len_part1 = carr_i(line) - offset;
         uint32_t max_size = min(dest_size, dest_len+len_part1+1);
         dest_len += my_strcpy(dest, dest_len, src_ptr, max_size);
         src_ptr += len_part1;
         dest_len += my_strcpy(dest, dest_len, ESC_REVERSE, dest_size);
         if isZERO(*src_ptr) {
            dest_len += my_strcpy(dest, dest_len, " ", dest_size);
         } else {
            max_size = min(dest_size, dest_len+1+1);
            if isEQ(*src_ptr, '\t') {
               uint32_t offset = carr_i(line);
               uint32_t actual_tab_size = tab_size(line->arr,offset);
               char tab_replacement[16] = "TTTTTTTTTTTTTTT";
               // for (int i=0; i<16; i++) tab_replacement[i] = 175;
               tab_replacement[actual_tab_size] = '\0';
               dest_len += my_strcpy(dest, dest_len, tab_replacement, 0);
            } else {
              dest_len += my_strcpy(dest, dest_len, src_ptr, max_size);
            }
            src_ptr++;
         }
         dest_len += my_strcpy(dest, dest_len, ESC_NORMAL, dest_size);
         dest_len += my_strcpy(dest, dest_len, src_ptr, dest_size);
      } else {
         dest_len += my_strcpy(dest, dest_len, src_ptr, dest_size);
      }
      dest_len += my_strcpy(dest, dest_len, cr, dest_size);
   }

   for (u_int32_t i = count+wrap_count; i < num_rows; i++) {
      dest_len += my_strcpy(dest, dest_len, cr, dest_size);
   }
   return dest_len;
}

char* get_page(uint32_t from_row, int highlight_trailing_spaces) {
   size_t num_row;
   size_t col;
   get_termsize(&num_row, &col);
   num_row--;

   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   if isNULL(session_p) return NULL;

   uint32_t len = luedc_get_page(session_p, from_row, num_row, NULL, 0, 0) + 20000; // 12*num_row + 1;
   char* str = malloc(len);
   if isNULL(str) return NULL;

   luedc_get_page(session_p, from_row, num_row, str, len, highlight_trailing_spaces);
   return str;
}

int lua_get_page(lua_State* L)
{
   uint32_t from_row = lua_tonumber(L, 1);
   int highlight_trailing_spaces = lua_tonumber(L, 2);
   size_t num_rows = 0;
   size_t col = 0;
   get_termsize(&num_rows, &col);
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   uint32_t len = luedc_get_page(session_p, from_row, num_rows, NULL, 0, highlight_trailing_spaces);
   char str[len+1];
   luedc_get_page(session_p, from_row, num_rows, str, len+1, highlight_trailing_spaces);
   lua_pushstring(L, str);
   return 1;
}

static int is_sel_off(carr_t* all_sessions) {
   lued_t* session_p = get_session(all_sessions);
   if isNULL(session_p) return 0;
   int is = isEQ(session_p->sel_state, LUED_SELOFF) ? 1 : 0;
   return is;
}

int lua_is_sel_off(lua_State* L) {
   if isNULL(L) return 0;
   int is  = is_sel_off(LUED_SESSIONS);
   if (!is) return 0;
   lua_pushnumber(L, is);
   return 1;
}

static int is_sel_end(carr_t* all_sessions) {
   lued_t* session_p = get_session(all_sessions);
   if isNULL(session_p) return 0;
   return ( isEQ(session_p->sel_state, LUED_SELEND) || isEQ(session_p->sel_state, LUED_SELENDBLK));
}

int lua_is_sel_end(lua_State* L) {
   if isNULL(L) return 0;
   int is = is_sel_end(LUED_SESSIONS);
   lua_pushnumber(L, is);
   return 1;
}

static int set_sel_start(int only_if_off) {
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   if isNULL(session_p) return 0;
   if (only_if_off && !is_sel_off(LUED_SESSIONS)) return 0;
   uint32_t row, col;
   get_cursor_position(session_p, &row, &col);
   session_p->sel_start_row = row;
   session_p->sel_start_col = col;
   session_p->sel_end_row = row;
   session_p->sel_end_col = col;
   session_p->sel_state = LUED_SELON;
   return 0;
}

int lua_set_sel_start(lua_State* L) {
   if isNULL(L) return 0;
   int only_if_off = lua_gettop(L) ? lua_tonumber(L,1) : 0;
   set_sel_start(only_if_off);
   return 0;
}

static int set_sel_end(int update_state) {
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   if isNULL(session_p) return 0;
   if (session_p->sel_state < LUED_SELON) return 0;
   uint32_t row, col;
   get_cur_pos(&row, &col);
   session_p->sel_end_row = row;
   session_p->sel_end_col = col;
   if isFALSE(update_state) return 0;
   session_p->sel_state = isEQ(session_p->sel_state,LUED_SELONBLK) ?
                          LUED_SELENDBLK : LUED_SELEND;
   return 0;
}

int lua_set_sel_end(lua_State* L) {
   if isNULL(L) return 0;
   set_sel_end(1);
   return 0;
}

static int set_sel() {
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   if isNULL(session_p) return 0;
   if (session_p->sel_state < LUED_SELON) {
      set_sel_start(0);
   } else {
      set_sel_end(1);
   }
   return 0;
}

int lua_set_sel(lua_State* L) {
   if isNULL(L) return 0;
   set_sel();
   return 0;
}

static void set_sel_off(carr_t* all_sessions) {
   lued_t* session = get_session(all_sessions);
   if isNULL(session) return;
   session->sel_state = LUED_SELOFF;
   return;
}

int lua_set_sel_off(lua_State* L) {
   if isNULL(L) return 0;
   set_sel_off(LUED_SESSIONS);
   return 0;
}

int lua_get_sel(lua_State* L) {
   if isNULL(L) return 0;
   uint32_t sel_state, sel_sr, sel_sc, sel_er, sel_ec;
   sel_state = sel_sr = sel_sc = sel_er = sel_ec = 0;
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   if (session_p) {
      get_sel(session_p, &sel_state, &sel_sr, &sel_sc, &sel_er, &sel_ec);
   }
   lua_pushnumber(L, sel_state);
   lua_pushnumber(L, sel_sr);
   lua_pushnumber(L, sel_sc);
   lua_pushnumber(L, sel_er);
   lua_pushnumber(L, sel_ec);
   return 5;
}

int find_string(const lued_t* l, uint32_t fr, uint32_t fc, const char* s,
                int mode, uint32_t* r, uint32_t* c, int* found)
{
   if (!isNULL(found)) *found = 0;
   if isNULL(l) return 1;
   if isNULL(l->text) return 0;
   if (!isNULL(s) && !isZERO(*s)) {
      l->find_str->len = 0;
      l->find_str->it = 0;
      carr_inserti(l->find_str, s, 0);
   }
   const char* search_str = l->find_str->arr;
   if (isNULL(search_str) || isZERO(*search_str)) return 0;
   carr_t* carr_lines = l->text;
   carr_t* carr_line;
   for (uint32_t line_number = fr; line_number <= carr_lines->len; line_number++) {
      carr_get(carr_lines, line_number, &carr_line);
      if isNULL(carr_line) continue;
      char* p = carr_line->arr;
      if isEQ(line_number, fr) {
         if (fc >= carr_line->len) continue;
         p += fc;
      }
      char* const px = strstr(p, search_str);
      if isNULL(px) continue;
      // printf("carr_line->arr=%p, p=%p, px=%p\n", carr_line->arr, p, px);

      if (!isNULL(r)) *r = line_number;
      if (!isNULL(c)) *c = (px - carr_line->arr);
      if (!isNULL(found)) *found = 1;
      set_cur_pos(*r, *c);
      set_sel_start(0);
      set_cur_pos(*r, *c + strlen(search_str));
      set_sel_end(1);
      set_cur_pos(fr,fc);
      return 0;
   }
   if (!isNULL(found)) *found = 0;
   return 0;
}

static int find_str(const char* str, int mode, uint32_t* r, uint32_t* c) {
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   if isNULL(session_p) return 0;
   carr_t* text_p = session_p->text;
   if isNULL(text_p) return 0;
   carr_t* line_p = NULL;
   carr_geti(text_p, &line_p);
   if isNULL(line_p) return 0;
   uint32_t from_row, from_col;
   get_cur_pos(&from_row, &from_col);
   from_col++;
   int found = 0;
   find_string(session_p, from_row, from_col, str, mode, r, c, &found);
   return found;
}

int lua_find_str(lua_State* L) {
   if isNULL(L) return 0;
   const char* str = lua_tostring(L, 1);
   uint32_t r, c;
   int found = find_str(str, 0, &r, &c);
   lua_pushnumber(L, found);
   lua_pushnumber(L, r+1);
   lua_pushnumber(L, c+1);
   return 3;
}

static void set_fileid(uint32_t id) {
   if isNULL(LUED_SESSIONS) return;
   if isZERO(LUED_SESSIONS->len) return;
   LUED_SESSIONS->it = (id % LUED_SESSIONS->len);
}

int lua_set_fileid(lua_State* L) {
   if isNULL(L) return 0;
   double did = lua_tonumber(L, 1);
   uint32_t id = (did < 1) ? carr_len(LUED_SESSIONS) : (uint32_t)did;
   id = max(1, id);
   set_fileid(id-1);
   return 0;
}

static uint32_t get_fileid() {
   return carr_i(LUED_SESSIONS);
}

int lua_get_fileid(lua_State* L)
{
   if isNULL(L) return 0;
   uint32_t fileid = get_fileid();
   lua_pushnumber(L, fileid+1);
   return 1;
}

void set_filename(lued_t* session_p, const char* filename) {
   if isNULL(filename) return;
   if isZERO(*filename) return;
   if isNULL(session_p) return;

   size_t size = strlen(filename)+1;
   char* filename_tmp = session_p->filename;
   if (!isNULL(filename_tmp)) free(filename_tmp);
   filename_tmp = malloc(size);
   safe_strncpy(filename_tmp, filename, size);
   session_p->filename = filename_tmp;
}

int lua_set_filename(lua_State* L) {
   const char* filename = lua_tostring(L,1);
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   set_filename(session_p, filename);
   return 0;
}

void get_filename(uint32_t id, char* filename, size_t n) {
   filename[0] = '\0';
   lued_t* session_p = NULL;
   carr_get(LUED_SESSIONS, id, &session_p);
   if isNULL(session_p) return;
   safe_strncpy(filename, session_p->filename, n);
   return;
}

int lua_get_filename(lua_State* L)
{
   char filename[1024];
   uint32_t id = lua_tonumber(L,1);
   id = max(id,1);
   get_filename(id-1, filename, sizeof(filename));
   lua_pushstring(L, filename);
   return 1;
}

static int get_page_position(lued_t* l, uint32_t* r, uint32_t* c) {
   *r = *c = 0;
   if isNULL(l) return 1;
   *r = l->page_row;
   *c = l->page_col;
   return 0;
}

static void get_page_pos(uint32_t* row, uint32_t* col) {
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   get_page_position(session_p, row, col);
}

static int lua_get_page_pos(lua_State* L)
{
   uint32_t row, col;
   get_page_pos(&row, &col);
   lua_pushnumber(L, row+1);
   lua_pushnumber(L, col+1);
   return 2;
}

static void set_page_pos(uint32_t row, uint32_t col) {
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   session_p->page_row = row;
   session_p->page_col = col;
}

static int lua_set_page_pos(lua_State* L)
{
   uint32_t row, col;
   row = lua_tonumber(L, 1);
   col = lua_tonumber(L, 2);
   set_page_pos(row-1, col-1);
   return 0;
}

static void set_page_offset(carr_t* all_sessions, uint32_t delta_row, uint32_t delta_col) {
   lued_t* session_p = NULL;
   carr_geti(all_sessions, &session_p);
   if isNULL(session_p) return;
   delta_row = min(delta_row, session_p->cursor_row);
   session_p->page_row = session_p->cursor_row - delta_row;
   session_p->page_col = 0; // (session_p->cursor_col > delta_col) ? session_p->cursor_col - delta_col : 0;
}

static int lua_set_page_offset(lua_State* L) {
  uint32_t delta_row = lua_tonumber(L,1);
  uint32_t delta_col = lua_tonumber(L,2);
  set_page_offset(LUED_SESSIONS, delta_row, delta_col);
  return 0;
}

static uint32_t get_line_len() {
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   if isNULL(session_p) return 0;
   carr_t* text_p = session_p->text;
   if isNULL(text_p) return 0;
   carr_t* line_p = NULL;
   carr_geti(text_p, &line_p);
   if isNULL(line_p) return 0;
   return line_p->len;
}

static int lua_get_line_len(lua_State* L) {
   uint32_t len = get_line_len();
   lua_pushnumber(L, len);
   return 1;
}

static char get_char(carr_t* all_sessions) {
   carr_t* line_p = get_carr_line(all_sessions);
   uint32_t row, col;
   get_cur_pos(&row, &col);
   char ch = '\0';
   if (carr_i(line_p) >= carr_len(line_p)) {
      ch = '\n';
      set_cur_pos(row+1, 1);
   } else {
      carr_geti(line_p, &ch);
      set_cur_pos(row, col+1);
   }
   return ch;
}

static int lua_get_char(lua_State* L) {
   char ch = get_char(LUED_SESSIONS);
   char ch_str[2] = " ";
   ch_str[0] = ch;
   lua_pushstring(L, ch_str);
   return 1;
}

static const char* get_str(carr_t* all_sessions, uint32_t sr, uint32_t sc, uint32_t er, uint32_t ec) {
   if isNULL(all_sessions) return NULL;
   lued_t* session_p = get_session(all_sessions);
   if isNULL(session_p) return NULL;
   carr_t* text_p = get_text(all_sessions);
   if isNULL(text_p) return NULL;

   carr_resize(session_p->str, 0);
   carr_set_it(text_p,sr);
   int more_lines = 1;
   while (more_lines) {
      carr_t* line;
      carr_geti(text_p, &line);
      uint32_t line_number = carr_i(text_p);
      uint32_t start_col = isEQ(line_number, sr) ? sc : 0;
      uint32_t end_col   = isEQ(line_number, er) ? ec : carr_len(line);
      uint32_t copy_len  = (end_col > start_col) ? end_col - start_col : 0;
      char* line_str = (char*)(line->arr);
      line_str += start_col;
      if (copy_len) carr_import(session_p->str, line_str, copy_len);
      more_lines = carr_i(text_p) < er;
      if (more_lines) {
         carr_import(session_p->str, "\n", 0);
         carr_nexti(text_p);
      }
   }
   return session_p->str->arr;
}

int lua_get_str(lua_State* L) {
   uint32_t sr = lua_tonumber(L, 1);
   uint32_t sc = lua_tonumber(L, 2);
   uint32_t er = lua_tonumber(L, 3);
   uint32_t ec = lua_tonumber(L, 4);
   const char* str = get_str(LUED_SESSIONS, sr, sc, er, ec);
   lua_pushstring(L, str);
   return 1;
}

static const char* set_paste(carr_t* all_sessions, const char* str) {
   lued_t* session_p = get_session(all_sessions);
   if isNULL(session_p) return NULL;
   if isNULL(str) {
      uint32_t sel_state, sr, sc, er, ec;
      sel_state = sr = sc = er = ec = 0;
      get_sel(session_p, &sel_state, &sr, &sc, &er, &ec);
      get_str(all_sessions, sr, sc, er, ec);
      carr_dup(session_p->paste_str, session_p->str);
   } else {
      carr_resize(session_p->paste_str, 0);
      carr_import(session_p->paste_str, str, 0);
   }
   return session_p->paste_str->arr;
}

int lua_set_paste(lua_State *L) {
   uint32_t num_arg = lua_gettop(L);
   const char* str = num_arg ? lua_tostring(L,1) : NULL;
   const char* pb = set_paste(LUED_SESSIONS, str);
   if (pb) {
      lua_pushstring(L, pb);
      return 1;
   }
   return 0;
}

static const char* get_paste(carr_t* all_sessions) {
   lued_t* session_p = get_session(all_sessions);
   if isNULL(session_p) return NULL;
   return session_p->paste_str->arr;
}

int lua_get_paste(lua_State *L) {
   const char* pb = get_paste(LUED_SESSIONS);
   lua_pushstring(L, pb);
   return 1;
}

static void push_undo(carr_t* all_sessions, char cmd, uint32_t row, uint32_t col,
uint32_t end_row, uint32_t end_col, uint32_t start_row, uint32_t start_col, const char* str) {
   if isNULL(all_sessions) return;
   if isNULL(str) return;
   if isZERO(strlen(str)) return;
   if isZERO(cmd) return;

   lued_t* session_p = get_session(all_sessions);
   if isNULL(session_p) return;

   carr_t* carr_str = carrs_init(str);
   carr_set_len(session_p->undo_str, carr_i(session_p->undo_str));
   carr_set_len(session_p->undo_cmd, carr_i(session_p->undo_cmd));
   carr_set_len(session_p->undo_col, carr_i(session_p->undo_col));
   carr_set_len(session_p->undo_row, carr_i(session_p->undo_row));
   carr_set_len(session_p->undo_end_col, carr_i(session_p->undo_end_col));
   carr_set_len(session_p->undo_end_row, carr_i(session_p->undo_end_row));
   carr_set_len(session_p->undo_start_col, carr_i(session_p->undo_start_col));
   carr_set_len(session_p->undo_start_row, carr_i(session_p->undo_start_row));
   carr_push(session_p->undo_str, &carr_str);
   carr_push(session_p->undo_cmd, &cmd);
   carr_push(session_p->undo_row, &row);
   carr_push(session_p->undo_col, &col);
   carr_push(session_p->undo_end_row, &end_row);
   carr_push(session_p->undo_end_col, &end_col);
   carr_push(session_p->undo_start_row, &start_row);
   carr_push(session_p->undo_start_col, &start_col);

   if (session_p->undo_str->it <= session_p->save_it) {
      session_p->save_it_valid = 0;
   }
}

static int find_mark(const carr_t* mark_names, const char* name, uint32_t* mark_i) {
   uint32_t mark_len = carr_len(mark_names);
   for (int i = 0; i < mark_len; i++) {
      carr_t* mark_name = NULL;
      carr_get(mark_names, i, &mark_name);
      if isEQS(mark_name->arr, name) {
         *mark_i = i;
         return 1; // found
      }
   }
   return 0; // not found
}

static void move_marks(lued_t* session_p, uint32_t row, int32_t delta) {
   if isNULL(session_p) return;
   if isZERO(delta) return;
   uint32_t mark_len = carr_len(session_p->mark_row);
   for (int i = 0; i < mark_len; i++) {
      uint32_t mark_row = 0;
      carr_get(session_p->mark_row, i, &mark_row);
      if (mark_row >= row) {
         mark_row += delta;
         carr_set(session_p->mark_row, i, &mark_row);
      }
   }
}

static void set_mark(carr_t* all_sessions, const char* name) {
   lued_t* session_p = get_session(all_sessions);
   if isNULL(session_p) return;
   uint32_t r, c;
   r = c = 0;
   get_cur_pos(&r, &c);
   uint32_t mark_i = 0;
   const int mark_exists = find_mark(session_p->mark_str, name, &mark_i);
   if (mark_exists) {
      carr_set(session_p->mark_row, mark_i, &r);
      carr_set(session_p->mark_col, mark_i, &c);
   } else {
      carr_t* carr_str = carrs_init(name);
      if isNULL(carr_str) return;
      uint32_t r, c;
      r = c = 0;
      get_cur_pos(&r, &c);
      carr_push(session_p->mark_str, &carr_str);
      carr_push(session_p->mark_row, &r);
      carr_push(session_p->mark_col, &c);
   }
}

int lua_set_mark(lua_State* L) {
  const char* name = lua_tostring(L,1);
  set_mark(LUED_SESSIONS, name);
  return 0;
}

static int goto_mark(carr_t* all_sessions, const char* name) {
   lued_t* session_p = get_session(all_sessions);
   if isNULL(session_p) return 0;
   uint32_t mark_i = 0;
   const int found = find_mark(session_p->mark_str, name, &mark_i);
   if (found) {
      uint32_t r, c;
      const carr_t* mark_name;
      carr_get(session_p->mark_str, mark_i, &mark_name);
      carr_get(session_p->mark_row, mark_i, &r);
      carr_get(session_p->mark_col, mark_i, &c);
      set_cur_pos(r, c);
   }
   return found;
}

int lua_goto_mark(lua_State* L) {
  const char* name = lua_tostring(L,1);
  int found = goto_mark(LUED_SESSIONS, name);
  if (found) {
     lua_pushnumber(L, found);
     return 1;
  }
  return 0;
}

static carr_t* split_lines(const char* str, const char* delim) {
   if isNULL(str) return NULL;
   if isNULL(delim) return NULL;
   carr_t* c_delims = carrs_init(delim);
   if isNULL(c_delims) return NULL;
   carr_t* c_str = carrs_init(str);
   if isNULL(c_delims) return NULL;
   carr_t* lines = carrp_new();
   if isNULL(lines) return NULL;
   carr_split(lines, c_str, c_delims);
   carr_free(c_str);
   carr_free(c_delims);
   return lines;
}

static void insert_str(carr_t* all_sessions, const char* str, int enable_push_undo) {
   if isNULL(str) return;
   if isZERO(*str) return;
   if isNULL(all_sessions) return;
   carr_t* new_lines = split_lines(str, "\n"); // must free
   if isNULL(new_lines) return;
   uint32_t numlines = carr_len(new_lines);
   uint32_t r, c;
   get_cur_pos(&r, &c);
   carr_t* line_p = get_carr_line(all_sessions);
   carr_t* line_to_eol = carr_slicei(line_p, carr_to_end(line_p)); // must free
   carr_deli(line_p, carr_to_end(line_p));

   carr_t* first_line = NULL;
   carr_get(new_lines, 0, &first_line);
   uint32_t first_line_len = carr_len(first_line);
   carr_append(line_p, first_line);
   carr_free(first_line); // free first new line
   carr_del(new_lines, 1, 0); // delete first new line

   carr_t* text_p = get_text(all_sessions);

   uint32_t new_c = c;
   uint32_t new_r = r;
   carr_t* last_line = NULL;
   if (new_lines->len) {
      carr_nexti(text_p);
      carr_inserti(text_p, new_lines->arr, new_lines->len);
      carr_previ(text_p);
      carr_geti(text_p, &last_line);
      new_r += numlines - 1;
      new_c = carr_len(last_line);
   } else {
      carr_geti(text_p, &last_line);
      new_c += first_line_len;
   }
   carr_free(new_lines);

   carr_append(last_line, line_to_eol);
   free(line_to_eol);
   set_cur_pos(new_r, new_c);
   lued_t* session_p = get_session(all_sessions);
   move_marks(session_p, new_r+1, new_r-r);
   if (enable_push_undo) push_undo(all_sessions, 'i', r, c, new_r, new_c, r, c, str);
}

static int lua_insert_str(lua_State* L) {
   const char* str = lua_tostring(L, 1);
   uint32_t r,c;
   get_cur_pos(&r, &c);
   insert_str(LUED_SESSIONS, str, 1);
   return 0;
}


static void delete_selected(carr_t* all_sessions) {
   if isNULL(all_sessions) return;
   lued_t* session_p = get_session(all_sessions);
   if isNULL(session_p) return;

   uint32_t sel_state, sel_sr, sel_sc, sel_er, sel_ec;
   get_sel(session_p, &sel_state, &sel_sr, &sel_sc, &sel_er, &sel_ec);
   if isZERO(sel_state) return;

   carr_t* text_p = get_text(all_sessions);
   if isNULL(text_p) return;

   set_sel_end(1);
   uint32_t start_r, start_c;
   get_cur_pos(&start_r, &start_c);
   const char* undo_str = get_str(all_sessions, sel_sr, sel_sc, sel_er, sel_ec);
   carr_del2d(text_p, sel_sr, sel_sc, sel_er, sel_ec);
   set_sel_off(all_sessions);
   set_cur_pos(sel_sr, sel_sc);
   move_marks(session_p, sel_er+1, sel_sr-sel_er); // negative move
   push_undo(all_sessions, 'd', sel_sr, sel_sc, sel_er, sel_ec, sel_sr, sel_sc, undo_str);
}

static int lua_delete_selected(lua_State* L) {
   delete_selected(LUED_SESSIONS);
   return 0;
}

static void undo(carr_t* all_sessions) {
   if isNULL(all_sessions) return;
   lued_t* session_p = get_session(all_sessions);
   if isNULL(session_p) return;
   if isZERO(carr_i(session_p->undo_str)) return;

   carr_t* carr_str = NULL;
   char cmd = '\0';
   uint32_t row = 0;
   uint32_t col = 0;
   uint32_t end_row = 0;
   uint32_t end_col = 0;
   uint32_t start_row = 0;
   uint32_t start_col = 0;

   carr_previ(session_p->undo_str);
   carr_previ(session_p->undo_cmd);
   carr_previ(session_p->undo_row);
   carr_previ(session_p->undo_col);
   carr_previ(session_p->undo_end_row);
   carr_previ(session_p->undo_end_col);
   carr_previ(session_p->undo_start_row);
   carr_previ(session_p->undo_start_col);

   carr_geti(session_p->undo_str, &carr_str);
   carr_geti(session_p->undo_cmd, &cmd);
   carr_geti(session_p->undo_row, &row);
   carr_geti(session_p->undo_col, &col);
   carr_geti(session_p->undo_end_row, &end_row);
   carr_geti(session_p->undo_end_col, &end_col);
   carr_geti(session_p->undo_start_row, &start_row);
   carr_geti(session_p->undo_start_col, &start_col);

   if isNULL(carr_str) return;
   if isZERO(cmd) return;

   if isEQ(cmd, 'i') {
      carr_t* text_p = get_text(all_sessions);
      carr_del2d(text_p, row, col, end_row, end_col);
      set_cur_pos(start_row, start_col);
   } else if isEQ(cmd, 'd') {
      set_cur_pos(row, col);
      insert_str(all_sessions, carr_str->arr, 0);
      set_cur_pos(start_row, start_col);
   }
}

int lua_undo(lua_State* L) {
   undo(LUED_SESSIONS);
   return 0;
}

static void redo(carr_t* all_sessions) {
   if isNULL(all_sessions) return;
   lued_t* session_p = get_session(all_sessions);
   if isNULL(session_p) return;

   if (!carr_validi(session_p->undo_str)) return;

   carr_t* carr_str = NULL;
   char cmd = '\0';
   uint32_t row = 0;
   uint32_t col = 0;
   uint32_t end_row = 0;
   uint32_t end_col = 0;
   uint32_t start_row = 0;
   uint32_t start_col = 0;

   carr_geti(session_p->undo_str, &carr_str);
   carr_geti(session_p->undo_cmd, &cmd);
   carr_geti(session_p->undo_row, &row);
   carr_geti(session_p->undo_col, &col);
   carr_geti(session_p->undo_end_row, &end_row);
   carr_geti(session_p->undo_end_col, &end_col);
   carr_geti(session_p->undo_start_row, &start_row);
   carr_geti(session_p->undo_start_col, &start_col);

   carr_nexti(session_p->undo_str);
   carr_nexti(session_p->undo_cmd);
   carr_nexti(session_p->undo_row);
   carr_nexti(session_p->undo_col);
   carr_nexti(session_p->undo_end_row);
   carr_nexti(session_p->undo_end_col);
   carr_nexti(session_p->undo_start_row);
   carr_nexti(session_p->undo_start_col);

   if isNULL(carr_str) return;
   if isZERO(cmd) return;

   if isEQ(cmd, 'd') {
      carr_t* text_p = get_text(all_sessions);
      carr_del2d(text_p, row, col, end_row, end_col);
      set_cur_pos(start_row, start_col);
   } else if isEQ(cmd, 'i') {
      set_cur_pos(row, col);
      insert_str(all_sessions, carr_str->arr, 0);
      set_cur_pos(end_row, end_col);
   }
}

int lua_redo(lua_State* L) {
   redo(LUED_SESSIONS);
   return 0;
}

static const char* get_last_cmd() {
   carr_t* cmd_hist = get_cmd_hist();
   uint32_t len = carr_len(cmd_hist);
   if isZERO(len) return NULL;
   carr_t* last_cmd = NULL;
   carr_get(cmd_hist, len-1, &last_cmd);
   return last_cmd->arr;
}

static void clear_screen() {
   printf("%s%s", ESC_CLR_ALL, ESC_GOHOME);
}

static int lua_clear_screen(lua_State* L) {
   clear_screen();
   return 0;
}

static int is_modified(carr_t* all_sessions, uint32_t session_id) {
   lued_t* session_p = NULL;
   carr_get(LUED_SESSIONS, session_id, &session_p);
   if isNULL(session_p) return 0;
   int save_needed = !session_p->save_it_valid ||
                     !isEQ(session_p->save_it, session_p->undo_str->it);
   return (save_needed ? 1 : 0);
}

static int lua_is_modified(lua_State* L) {
   int num_args = lua_gettop(L);
   uint32_t lua_id = max(lua_tonumber(L,1),1);
   lua_id--;
   uint32_t id = num_args ? lua_id : get_fileid();
   int is = is_modified(LUED_SESSIONS,id);
   if (is) {
     lua_pushnumber(L, 1);
     return 1;
   }
   return 0;
}



/*
static int file_modified(lued_t* session_p) {
   struct stat fstat;
   stat("files/bigfile.txt", &fstat);
   time_t modified_time = fstat.st_mtime;
   printf("Last mod : %d\n",(int)modified_time);
   printf("Timestamp: %d\n",(int)time(NULL));
exit(0);
   return 0;
}
*/

static int display_screen(int lua_mode, int highlight_trailing_spaces) {


   uint32_t row, col;
   get_cur_pos(&row, &col);
   uint32_t id = get_fileid()+1; // +1 converts to lua
   char filename[100];
   get_filename(id-1,filename, sizeof(filename));
   clear_screen();
   set_sel_end(0);
   lued_t* session_p = NULL;
   carr_geti(LUED_SESSIONS, &session_p);
   if isNULL(session_p) return 0;
   uint32_t sel_state, sel_sr, sel_sc, sel_er, sel_ec;
   get_sel(session_p, &sel_state, &sel_sr, &sel_sc, &sel_er, &sel_ec);
   if (sel_state) {
      int stay_selected =  (isEQ(row, sel_er) && isEQ(col, sel_ec)) ||
                           (isEQ(row, sel_sr) && isEQ(col, sel_sc));
      if (!stay_selected) {
         set_sel_off(LUED_SESSIONS);
      }
   }
   const char* mode_str = lua_mode ? "LUA MODE" : "ED MODE";
   const char* cmd = get_last_cmd();
   const uint32_t cmd_len = cmd ? strlen(cmd) : 0;
   const char* null_str = "";
   const char* cmd_str = (cmd && cmd_len<20) ? cmd : null_str;
   char status_line[1024];
   size_t trow, tcol;
   trow = tcol = 0;
   get_termsize(&trow, &tcol);
   int save_needed = !session_p->save_it_valid ||
                     !isEQ(session_p->save_it, session_p->undo_str->it);
   char save_ch = save_needed ? '*' : ' ';
   
   
   sprintf(status_line,"%s - LuEd File (%d) %s%c Line: %d, Col: %d, Sel: %d Cmd: %s",
          mode_str, id, filename, save_ch, row+1, col+1, sel_state, cmd_str);
   uint32_t status_len = strlen(status_line);
   for (int i = status_len; i <= tcol; i++) {
      status_line[i] = ' ';
   }
   status_line[tcol] = '\0';
   printf(ESC_REVERSE"%s"ESC_NORMAL, status_line);
   printf("\n");
   get_page_pos(&row, &col);
   char* text = get_page(row,highlight_trailing_spaces); // text must be freed
   printf("%s",text);
   free(text);
   fflush(stdout);
   return 0;
}

static int lua_display_screen(lua_State* L) {
   int lua_mode = lua_tonumber(L,1);
   int highlight_trailing_spaces = lua_tonumber(L,2);
   display_screen(lua_mode,highlight_trailing_spaces);
   return 0;
}

int file_exists(const char* filename)
{
   FILE* fileid = fopen(filename, "r");
   if (fileid) fclose(fileid);
   return (fileid != NULL);
}


static int lued_args(int argc, char** argv, carr_t* dofile, carr_t* cmd, carr_t* linenumber) {
   char c;
   while ((c = getopt (argc, argv, "d:e:l:")) != -1) {
      switch (c) {
         /*
         case 'a':
            aflag = 1;
            break;
         case 'c':
            cvalue = optarg;
            break;
         */
         case 'd': carr_import(dofile, optarg, 0); break;
         case 'e': carr_import(cmd, optarg, 0); break;
         case 'l': carr_import(linenumber, optarg, 0); break;
         case '?':
            if (optopt == 'c')
               fprintf (stderr, "Option -%c requires an argument.\n", optopt);
            else if (isprint (optopt))
               fprintf (stderr, "Unknown option `-%c'.\n", optopt);
            else
               fprintf (stderr, "Unknown option character `\\x%x'.\n", optopt);
               return 1;
          default:
               ;
      }
      // printf ("in while dofile = '%s', cmd = '%s', linenumber = '%s' \n", dofile->arr, cmd->arr, linenumber->arr);
   }
   /*
   for (int index = optind; index < argc; index++) {
      printf ("Non-option argument %s\n", argv[index]);
   }
   getchar();
   */
   return optind;
}


void lued_atexit() {
   printf("\e[?1000l");
   printf("%s",ESC_NORMSCREEN);
   printf("%s",ESC_PASTEOFF);
   raw_off();
}

int lued_main (int argc, char** argv)
{
   carr_t* arg_dofile = carrs_new();
   carr_t* arg_cmd    = carrs_new();
   carr_t* arg_linenumber = carrs_new();
   int optind = lued_args(argc, argv, arg_dofile, arg_cmd, arg_linenumber);
   // exit(0);

   // const carr_t* cargs = carr_arg(argc, argv, "-d 1 -e 1 -l 1");


   atexit(lued_atexit);
   printf("%s",ESC_ALTSCREEN);
   // printf("%s",ESC_MOUSEENABLE);
   // printf("%s",ESC_MOUSETRACK); // only needed for 1001, 1002
   printf("%s",ESC_PASTEON);

   lua_State *L = luaL_newstate();
   luaL_openlibs(L);

   // lua_pushcfunction(L, set_color);
   // lua_setglobal(L, "set_color");
   // lua_reg(L, lua_set_color, "set_color");
   lua_reg(L, lua_lued_open, "lued_open");
   lua_reg(L, lua_reopen, "reopen");
   lua_reg(L, lua_get_numchar, "get_numchar");
   lua_reg(L, lua_get_numlines, "get_numlines");
   lua_reg(L, lua_get_numsessions, "get_numsessions");
   lua_reg(L, lua_set_mark, "set_mark");
   lua_reg(L, lua_goto_mark, "goto_mark");
   lua_reg(L, lua_get_page, "get_page");
   lua_reg(L, lua_set_cur_pos, "set_cur_pos");
   lua_reg(L, lua_get_cur_pos, "get_cur_pos");
   lua_reg(L, lua_get_line, "get_line");
   lua_reg(L, lua_get_line_len, "get_line_len");
   lua_reg(L, lua_set_page_pos, "set_page_pos");
   lua_reg(L, lua_get_page_pos, "get_page_pos");
   lua_reg(L, lua_set_page_offset, "set_page_offset");
   lua_reg(L, lua_get_termsize, "get_termsize");
   lua_reg(L, lua_set_filename, "set_filename");
   lua_reg(L, lua_get_filename, "get_filename");
   lua_reg(L, lua_set_fileid, "set_fileid");
   lua_reg(L, lua_get_fileid, "get_fileid");
   lua_reg(L, lua_display_screen, "display_screen");
   lua_reg(L, lua_clear_screen, "clear_screen");
   lua_reg(L, lua_find_str, "find_str");
   lua_reg(L, lua_is_sel_end, "is_sel_end");
   lua_reg(L, lua_is_sel_off, "is_sel_off");
   lua_reg(L, lua_set_sel, "set_sel");
   lua_reg(L, lua_set_sel_start, "set_sel_start");
   lua_reg(L, lua_set_sel_end, "set_sel_end");
   lua_reg(L, lua_set_sel_off, "set_sel_off");
   lua_reg(L, lua_get_sel, "get_sel");
   lua_reg(L, lua_delete_selected, "delete_selected"); // undo-able
   lua_reg(L, lua_insert_str, "insert_str"); // undo-able
   lua_reg(L, lua_get_char, "get_char");
   lua_reg(L, lua_set_hotkeys, "set_hotkeys");
   lua_reg(L, lua_get_hotkeys, "get_hotkeys");
   lua_reg(L, lua_set_repeatables, "set_repeatables");
   lua_reg(L, lua_get_repeatables, "get_repeatables");
   lua_reg(L, lua_set_non_repeatables, "set_non_repeatables");
   lua_reg(L, lua_get_non_repeatables, "get_non_repeatabless");
   lua_reg(L, lua_save_session, "save_session");
   lua_reg(L, lua_is_modified, "is_modified");
   lua_reg(L, lua_get_str, "get_str");
   lua_reg(L, lua_set_paste, "set_paste");
   lua_reg(L, lua_get_paste, "get_paste");
   lua_reg(L, lua_close_session, "close_session");
   lua_reg(L, lua_undo, "undo");
   lua_reg(L, lua_redo, "redo");
   lua_reg(L, lua_find_read, "find_read");
   lua_reg(L, lua_replace_read, "replace_read");
   lua_reg(L, lua_is_file_modified, "is_file_modified");
   lua_reg(L, lua_set_show_line_numbers, "set_show_line_numbers");
   lua_reg(L, lua_io_read, "io_read");

   LUED_SESSIONS = carr_new(0, sizeof(lued_t*));

   if (optind >= argc) { // (argc <= 1) {
      lued_open(LUED_SESSIONS,"untitled_0.txt");
   }

//   for (int i = 1; i < argc; i++) {
   for (int i = optind; i < argc; i++) {
      // printf("argv[%d] = '%s'\n", i, argv[i]);
      lued_open(LUED_SESSIONS,argv[i]);
   }

   #define STRLEN 50
   char* home = getenv("HOME");
   char lued_paths[5][STRLEN];
   safe_strncpy(lued_paths[0], "./lua_scripts/lued.lua", STRLEN);
   safe_strncpy(lued_paths[1], "./lued.lua", STRLEN);
   sprintf(lued_paths[2], "%s/lued.lua", home);
   sprintf(lued_paths[3], "%s/.lua/lued.lua", home);

   lued_paths[4][0] = '\0';
   printf("Searching for lued.lua...\n");
   int i = 0;
   for (i = 0; lued_paths[i][0]; i++) {
      if (file_exists(lued_paths[i])) break;
   }
   int err = luaL_dofile (L, lued_paths[i]);
   if (err) fprintf(stderr,"Error1: luaL_dofile(L,%s);\n",lued_paths[i]);

   if (*(arg_dofile->arr)) {
      char lua_cmd[512];
      sprintf(lua_cmd, "%s",arg_dofile->arr);
      int err = luaL_dofile(L,lua_cmd);
      if (err) {fprintf(stderr,"Error2: luaL_dofile(L,%s);\n",lua_cmd); getchar();}
   }

   if (*(arg_cmd->arr)) {
      char lua_cmd[512];
      sprintf(lua_cmd, "%s\n",arg_cmd->arr);
      int err = luaL_dostring(L,lua_cmd);
      if (err) fprintf(stderr,"Error: luaL_dostring(L,%s);\n",lua_cmd);
   }

   if (*(arg_linenumber->arr)) {
      char lua_cmd[512];
      sprintf(lua_cmd, "goto_line(%s)\n",arg_linenumber->arr);
      int err = luaL_dostring(L,lua_cmd);
      if (err) fprintf(stderr,"Error: luaL_dostring(L,%s);\n",lua_cmd);
   }

   raw_on(); // FIXME
   lua_interactive(L, 0, NULL);
   raw_off();
   printf("%s",ESC_NORMSCREEN);

   lua_close(L);
   return 0;
}

