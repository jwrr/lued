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


/// @file
/// @brief Header file for carr.h
///
/// @main

#ifndef CARR_H
#define CARR_H

#include <stdint.h>
#include <stdbool.h>

typedef struct carr_struct {
   uint32_t    len;
   uint32_t    size;
   uint32_t    elem_size;
   uint32_t    max_size;
   uint32_t    it;
   char*       arr;
   struct carr_struct* next;
} carr_t;

carr_t* carr_new(uint32_t max_size, uint32_t elem_size);
carr_t* carr_init(uint32_t max_size, uint32_t elem_size, const void* init_arr, int32_t init_len);
carr_t* cstra_new(uint32_t const max_size, const char* const init_str);
int carr_copy(void* dest, const void* const src, uint32_t const len, uint32_t const elem_size);
int carr_resize(carr_t* carr, const uint32_t new_size);
int carr_resize_if_needed(carr_t* ca, uint32_t new_len);
int mem_is_zero(const void* const ptr, uint32_t size);
uint32_t arrlen(const void* arr, uint32_t elem_size, uint32_t size);
int carr_import(carr_t* orig, const void* arr, uint32_t arr_len);
uint32_t carr_append(carr_t* dest, carr_t* src);
carr_t* carr_dup(carr_t* dest, carr_t* src);
carr_t* carr_free(carr_t* ca);
carr_t* carr_free2d(carr_t* ca);
int carr_isfirsti(const carr_t* ca);
int carr_isleni(const carr_t* ca);
void carr_firsti(carr_t* const ca) ;
int carr_validi(const carr_t* const ca);
int carr_validei(const carr_t* const ca, void* elem);
void carr_nexti(carr_t* const ca);
void carr_previ(carr_t* const ca);
void* carr_get(const carr_t* const ca, uint32_t const i, void* element);
void* carr_geti(const carr_t* const ca, void* element);
void* carr_get_first(const carr_t* const ca, void* element);
void* carr_get_last(const carr_t* const ca, void* element);
void* carr_get_previ(carr_t* ca, void* element);
void* carr_getarri(const carr_t* const ca, void** element);
void* carr_getsi(const carr_t* const ca);
int carr_is_ini(carr_t* haystack, void* elem);
int carr_is_eqi(const carr_t* const ca, const void* const elem);
int carr_findi(carr_t* const haystack, carr_t* const needles);
void carr_clear(carr_t* const ca, uint32_t const offset, uint32_t const len);
int carr_too_big(const carr_t* const ca, uint32_t const new_size);
int carr_set(carr_t* ca, uint32_t i, const void* const value);
void carr_seti(carr_t* ca, void* value);
void carr_set_it(carr_t* ca, uint32_t new_it);
void carr_set_len(carr_t* ca, uint32_t new_len);
void carr_push(carr_t* ca, const void* value);
void carr_pop(carr_t* ca, void* value);
uint32_t carr_i(carr_t* ca);
void* carr_ptri(const carr_t* const ca);
int in_array(void* needle, void* haystack, uint32_t needle_size, uint32_t num_needles);
uint32_t carr_count(carr_t* haystack, void* needles);
uint32_t carr_len(const carr_t* const carr);
uint32_t carr_to_end(carr_t* ca);
carr_t* carr_slicei(carr_t* ca, uint32_t len);
void carr_split(carr_t* const outs, carr_t* const in_arr, carr_t* const delims);
uint32_t carr_filesize(const char* const filename);
carr_t* carr_read(const char* const filename);
carr_t* carr_read_lines(const char* const filename);
void carr_print(carr_t* ca);
int carr_write2d(carr_t* ca, char* filename);
void carr_make_space(carr_t* const ca, uint32_t const amount, uint32_t const at);
void carr_del(carr_t* ca, uint32_t amount, uint32_t at);
void carr_deli(carr_t* ca, uint32_t n);
void carr_del2d(carr_t* carr_2d, uint32_t sr, uint32_t sc, uint32_t er, uint32_t ec);

void carr_overwrite(carr_t* const ca, const void* arr, uint32_t len, uint32_t at);
void carr_insert(carr_t* const ca, const void* arr, uint32_t const len, uint32_t const at);
void carr_insert2(carr_t* const ca, void** const arr, uint32_t const len, uint32_t const at);
void carr_inserti(carr_t* const ca, const void* arr, uint32_t const len);

#define for_carr(C) for (carr_firsti(C); carr_validi(C); carr_nexti(C))
#define for_carr_cont(C) for ( ; carr_validi(C); carr_nexti(C))

#define foreach_carr(E,C) for (carr_firsti(C); carr_validei(C,E); carr_nexti(C))

#define carrp_new() carr_new(0, sizeof(carr_t*))

#define carrs_new() carr_new(0, 1)
#define carrs_init(I) carr_init(0, 1, I, 0)

#endif
