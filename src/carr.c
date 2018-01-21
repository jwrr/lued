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


/// \file
/// \brief This file provides dynamic sized array
///
/// \main
///

#include <stdio.h>
#include <stdlib.h>
#include "cis.h"
#include "carr.h"

carr_t* carr_new(uint32_t max_size, uint32_t elem_size)
{
   if isZERO(elem_size) return NULL;
   carr_t* carr = malloc(sizeof(carr_t));
   if isNULL(carr) return NULL;

   carr->len = 0;
   carr->size = 1;
   carr->it = 0;
   carr->elem_size = elem_size;
   carr->max_size = max_size;
   carr->arr = calloc(1, elem_size);
   carr->next = NULL;
   return carr;
}

/// \brief Create a new array
/// \param max_size The maximum size (in bytes) that the array can grow to. 0
/// means the array size is unbounded.
/// \param init_arr This is the initial value of the array.
/// \return Pointer to the new array.
///
/// \req 1.1 carr_init shall initialize max_size to the max_size argument.
/// \req 1.2 carr_init shall initialize size to the length+1 of the arr argument.
/// \req 1.3 carr_init shall initialize len the length of the arr argument.
/// \req 1.4 carr_init shall initialize the next pointer to NULL.
/// \req 1.5 carr_init shall intialize arr to the argument array.
/// \req 1.6 carr_free shall return NULL.
/// \req 1.7 carr_init shall initialize max_size to 0 when the max_size argument is 0.
/// \req 1.9 carr_init shall initialize len to len of arr argument when max_size is 0.
/// \req 1.10 carr_init shall initialize next to NULL when max_size is 0.
/// \req 1.11 carr_init shall initialize arr to arr arg when max_size is 0.
/// \req 1.12 carr_init shall initialize max_size=max_size if arr argument has len=0.
/// \req 1.13 carr_init shall initialize size=1 if arr argument has len=0.
/// \req 1.14 carr_init shall initialize len=0 if arr argument has len=0.
/// \req 1.15 carr_init shall initialize arr="" if arr argument has len=0.
/// \req 1.16 carr_init shall initialize max_size=max_size if arr argment is NULL.
/// \req 1.17 carr_init shall initialize size=1 if arr argment is NULL.
/// \req 1.18 carr_init shall initialize len=0 if arr argment is NULL.
/// \req 1.19 carr_init shall initialize arr to "" arr argment is NULL.
/// \req 1.20 carr_init shall not let arr grow beyond max_size.
/// \req 1.21 carr_init shall not let size be larger than max_size.
/// \req 1.22 carr_init shall not let len be as large as max_size.
/// \req 1.23 carr_init shall chomp arr to len=max_size-1 if it is too long.

carr_t* carr_init(uint32_t max_size, uint32_t elem_size, const void* init_arr, int32_t init_len)
{
   carr_t* carr = carr_new(max_size, elem_size);
   if isNULL(carr) return NULL;

   carr_import(carr, init_arr, init_len);
   return carr;
}

carr_t* carr_dup(carr_t* dest, carr_t* src)
{
   if isNULL(src) return NULL;
   carr_t* d = isNULL(dest) ? carr_new(src->max_size, src->elem_size) : dest;
   carr_set_len(d, 0);
   carr_import(d, src->arr, src->len);
   return d;
}

/// \brief Creates new char-based carr_t
carr_t* cstra_new(uint32_t const max_size, const char* const init_str)
{
   carr_t* ptr = carr_init(max_size, 1, (void *)init_str, 0);
   return ptr;
}

/// \brief copy array. Does not over-run and ensures NULL termination.
/// `arrcpy can over-run if src is longer than dest.
/// `arrncpy prevents over-runs but does not ensure NULL termination.
/// `carr_copy writes `'\0' to `dest[len] after the copy to ensure NULL
/// termination.
/// \param dest The destination array
/// \param src The source array
/// \param len The maximum number of characters to copy.
/// \return 0 = success, 1 = fail
///
/// \req 2.1 carr_copy shall copy src to dest when src length is less than or equal to len.
/// \req 2.2 carr_copy shall copy len-1 char from src to des when src length is greater than len.
/// \req 2.3 carr_copy shall write '\0' to position len.
/// \req 2.4 carr_copy shall return err (1) when dest = NULL.
/// \req 2.5 carr_copy shall return no-error (0) when dest != NULL.
/// \req 2.6 carr_copy shall not modify dest when len=0
/// \req 2.7 carr_copy shall write '\0' to dest[0] when src=NULL.

int carr_copy(void* dest, const void* const src, uint32_t const len, uint32_t const elem_size)
{
   if isNULL(dest) return 1;

   if (isNULL(src) || isZERO(len) || isZERO(elem_size)) {
      memset(dest, 0, max(1,elem_size));
      return 0;
   }

   uint32_t num_bytes = len * elem_size;
   memcpy(dest, src, num_bytes);

   char* last = dest + num_bytes;
   memset(last, 0, elem_size); // for null-terminate of last element

   return 0;
}


/// \brief malloc new space, copy content, free original space.
/// \param carr The carr that will grow it's array size
/// \param new_size The new_size of the char array
/// \return 0 = success, 1 = fail
///
/// \req 3.1 carr_resize shall return err (1) on malloc failure.
/// \req 3.2 carr_resize shall retain arr value if arr length is less than new_size.
/// \req 3.3 carr_resize shall allow size to get smaller.
/// \req 3.4 carr_resize shall truncate arr if array is longer than new_size.
/// \req 3.5 carr_resize shall keep arr unchanged if new_size = original size.
/// \req 3.6 carr_resize shall return err (1) if carr is NULL.


int carr_resize(carr_t* carr, const uint32_t new_size)
{
   if isNULL(carr) return 1;
   const uint32_t new_size2 = max(1, new_size);
   if isEQ(new_size2, carr->size) return 0; // no change so do nothing

   char* new_buf = malloc(new_size2 * carr->elem_size);
   if isNULL(new_buf) return 1; // return error on malloc error
   carr->size = new_size2;
   carr->len = min(carr->len, new_size2 - 1); // len may need to shrink
   carr_copy(new_buf, carr->arr, carr->len, carr->elem_size);

   free(carr->arr);

   carr->arr = new_buf;
   return 0;
}


/// \brief Resize arr buffer if index is larger than currently allocated
/// \param ca The carr being resized
/// \param new_size The new size
/// \return Return err (1) on error, else return 0.

int carr_resize_if_needed(carr_t* ca, uint32_t new_len)
{
   if isNULL(ca) return 1;
   const uint32_t new_size = new_len + 1;
   if (carr_too_big(ca, new_size)) return 1;
   if (new_size > ca->size) {
      const uint32_t orig_len = ca->len;
      const uint32_t new_len1 = orig_len + 1;
      const uint32_t double_size = 2 * new_size;
      const uint32_t new_size1 = max(double_size, new_len1+1);
      const uint32_t max_size  = ca->max_size;
      const uint32_t new_size2 = isZERO(max_size) ? new_size1 : min(new_size1, max_size);
      const int resize_err = carr_resize(ca, new_size2);
      if (resize_err) return 1;
   }
   return 0;
}


/// \brief Return true if all bytes of memory region are zero.
/// \param ptr pointer to memory region
/// \param size size of memory region
/// \return Return 1 if region is all zeroes, else return 0
int mem_is_zero(const void* const ptr, uint32_t size)
{
   if isNULL(ptr) return 0;
   if isZERO(size) return 1;
   char* chp = (char*)ptr;
   if (!isZERO(*chp)) return 0;
   if isEQ(size, 1) return 1;

   const char* const ptr2 = (char*)ptr + 1;

   int const z = isZERO( memcmp(ptr, ptr2, size-1) ) ? 1 : 0;
   return z;
}

/// \brief Return length of Null-Terminated Array.
/// \param arr pointer to start of array
/// \param elem_size Size of each element in array
/// \param size Max number of elements in array
/// \return number of elements in array.

uint32_t arrlen(const void* arr, uint32_t elem_size, uint32_t size)
{
   if isNULL(arr) return 0;
   if isZERO(elem_size) return 0;
   bool const unknown_size = isZERO(size);
   const void* ptr = arr;
   uint32_t i = 0;
   for (; i < size || unknown_size; i++) {
      if (mem_is_zero(ptr, elem_size)) break;
      ptr = (char*)ptr + elem_size;
   }
   return i;
}

/// \brief Append C-Style NULL terminated array to carr
/// \param orig array to be modified
/// \param arr  NULL-terminated array that is being appended to `orig
/// \return 0 on success, 1 on fail
///
/// \req carr_import shall return err (1) if orig is NULL, else return no-err (0).
/// \req carr_import shall malloc a 1-char vector if orig->arr is NULL.
/// \req carr_import shall not modify orig if arr is NULL.
/// \req carr_import shall not modify orig if arr is "".
/// \req carr_import shall return err (1) if orig->arr malloc fails.
/// \req carr_import shall return err (1) if resize malloc error.
/// \req carr_import shall append arr to the orig array.
/// \req carr_import shall keeps size the same if new length is not lt size.
/// \req carr_import shall grow size if new length is ge size.
/// \todo carr_import - add len argument

int carr_import(carr_t* orig, const void* arr, uint32_t arr_len)
{
   if isNULL(orig) return 1;

   if isNULL(orig->arr) {
      const int err = carr_resize(orig, 1);
      if (err) return 1;
   }

   if isNULL(arr) return 0;
   const uint32_t arr_len2 =  isZERO(arr_len) ? arrlen(arr, orig->elem_size, 0) :
                                                arr_len;
   if isZERO(arr_len2) return 0;

   const uint32_t orig_len = orig->len;
   const uint32_t new_len1 = orig_len + arr_len2;
   const uint32_t double_size = isZERO(orig->size) ? 1 : 2 * orig->size;
   const uint32_t new_size1 = max(double_size, new_len1+1);
   const uint32_t max_size  = orig->max_size;
   const uint32_t new_size2 = isZERO(max_size) ? new_size1 : min(new_size1, max_size);
   if (new_len1 >= orig->size) {
      const int err1 = carr_resize(orig, new_size2);
      if (err1) {
         return 1;
      }
   }

   const uint32_t new_len2 = min(new_size2-1, new_len1);
   const uint32_t delta_len = new_len2 - orig->len;
   char* dest = &(orig->arr[orig->len]);
   carr_copy(dest, arr, delta_len, orig->elem_size);
   orig->len = new_len2;
   orig->it = new_len2;
   const int err2 = new_len2 < new_len1;
   return err2;
}


/// \brief carr_append
/// \param dest destination carr that will increase in size
/// \param src carr that will be appended to dest
/// \return number of elements appended.

uint32_t carr_append(carr_t* dest, carr_t* src)
{
   if isNULL(dest) return 0;
   if isNULL(src) return 0;

   char* elem[src->elem_size];
   uint32_t count = 0;
   for_carr (src) {
      carr_geti(src, elem);
      int const err = carr_set(dest, dest->len, elem);
      if (err) break;
      count++;
   }
   return count;
}

/// \brief Delete the array and free its memory
/// \param s Pointer to the array to be freed
/// \return Always returns NULL

carr_t* carr_free(carr_t* ca)
{
   if isNULL(ca) return NULL;
   if (!isNULL(ca->arr)) {
      free(ca->arr);
   }
   free(ca);
   return NULL;
}

carr_t* carr_free2d(carr_t* ca)
{
   if isNULL(ca) return NULL;
   if isNULL(ca->arr) return NULL;

   carr_t* elem;
   foreach_carr (&elem, ca) {
      carr_free(elem);
   }
   return NULL;
}


/// \brief Iterator initialization
///
/// Iterator Example
///    for (carr_firsti(s); carr_validi(s); carr_nexti(s) {
///        char const ch = carr_geti(s);
///    }
///
/// \param ca The carr to be iterated over
/// \return Return nothing (void)

void carr_firsti(carr_t* const ca)
{
   if isNULL(ca) return;
   ca->it = 0;
}

int carr_isfirsti(const carr_t* ca) {
   if isNULL(ca) return 1;
   return isZERO(ca->it);
}


int carr_isleni(const carr_t* ca) {
   if isNULL(ca) return 1;
   return isEQ(ca->it, ca->len);
}


/// \brief Iterator valid (not done). More elements on the list.
/// \param ca The carr to be iterated over
/// \return True if more elements on the list.

int carr_validi(const carr_t* const ca)
{
   if isNULL(ca) return false;
   return (ca->it < carr_len(ca));
}

int carr_validei(const carr_t* const ca, void* elem)
{
   if isNULL(ca) return false;
   if isFALSE( carr_validi(ca) ) return false;
   carr_geti(ca, elem);
   return true;
}

/// \brief Interator advance to the next element
/// \param ca The carr to be iterated over
/// \return Return nothing (void)

void carr_nexti(carr_t* const ca)
{
   if isNULL(ca) return;
   ca->it += 1;
   if (!carr_validi(ca)) {
      ca->it = carr_len(ca);
   }
}

/// \brief Interator advance to the previous element
/// \param ca The carr to be iterated over
/// \return Return nothing (void)

void carr_previ(carr_t* const ca)
{
   if isNULL(ca) return;
   if (ca->it) ca->it -= 1;
}

/// \brief Return the value of index
/// \return The element being pointed to.

void* carr_get(const carr_t* const ca, uint32_t const i, void* element)
{
   if isNULL(element) return NULL;
   if isNULL(ca) return NULL;
   if isNULL(ca->arr) return NULL;
   if (i >= ca->len) {
      memset(element, 0, ca->elem_size);
   } else {
      const void* const src = (char*)ca->arr + (i * ca->elem_size);
      memcpy(element, src, ca->elem_size);
   }
   return element;
}

/// \brief Return the current iterated value
/// \return The element being pointed to.

void* carr_geti(const carr_t* const ca, void* element)
{
   if isNULL(ca) return NULL;
   if (ca->it >= ca->len) return NULL;
   return carr_get(ca, ca->it, element);
}

/// \brief Return the first value
/// \return The element being pointed to.

void* carr_get_first(const carr_t* const ca, void* element)
{
   if isNULL(ca) return NULL;
   if isZERO(ca->len) return NULL;
   return carr_get(ca, 0, element);
}

/// \brief Return the last value
/// \return The element being pointed to.

void* carr_get_last(const carr_t* const ca, void* element)
{
   if isNULL(ca) return NULL;
   if isZERO(ca->len) return NULL;
   return carr_get(ca, (ca->len)-1, element);
}

void* carr_get_previ(carr_t* ca, void* element)
{
   if isNULL(ca) return NULL;
   if isZERO(ca->len) return NULL;
   carr_previ(ca);
   return carr_geti(ca, element);
}

void* carr_getarri(const carr_t* const ca, void** element)
{
   carr_t* p;
   carr_geti(ca, &p);
   *element = (void*)((carr_t*)p->arr);
   return *element;
}

/// \brief Return location 0 of string in carray
/// \param ca The outter carray

void* carr_getsi(const carr_t* const ca)
{
   if isNULL(ca) return NULL;
   if isZERO(ca->len) return NULL;
   char* element[ca->elem_size];
   carr_t* ca2 = *(carr_t**)carr_geti(ca, element);
   if isNULL(ca2) return NULL;
   char* ca2_arr = ca2->arr;
   return ca2_arr;
}

/// \brief check if elem is in carr
/// The carr->it is used and points to the index
/// \param haystack Pointer to the carr being searched
/// \param elem Pointer to the elem be searched for
/// \return Returns 1 if found. Returns 0 if not found

int carr_is_ini(carr_t* haystack, void* elem)
{
   if isNULL(haystack) return 0;
   if isNULL(elem) return 0;

   for_carr (haystack) {
      int const match = carr_is_eqi(haystack, elem);
      if (match) return 1;
   }
   return 0;
}

/// \brief compare value at carr->it with value at elem
/// \param ca The carr being iterated over
/// \param elem The elem being compared to

int carr_is_eqi(const carr_t* const ca, const void* const elem)
{
   if isNULL(ca) return 0;
   if isNULL(elem) return 0;
   if isFALSE(carr_validi(ca)) return 0;

   int const eq = isZERO(memcmp(carr_ptri(ca), elem, ca->elem_size));
   return eq;
}

/// \brief find next occurrence of needles
/// \param haystack ca being searched
/// \param needles needles being searched for
/// \return Return 1 if found, else 0

int carr_findi(carr_t* const haystack, carr_t* const needles)
{
   if isFALSE(carr_validi(haystack)) return 0;
   if isZERO(carr_len(needles)) return 0;

   char elem[haystack->elem_size];
   for_carr_cont (haystack) {
      carr_geti(haystack, elem);
      int const match = carr_is_ini(needles, elem);
      if (match) return 1;
   }
   return 0;
}


/// \brief Set one or more elements to zero.
/// \param ca The array being modified
/// \param offset The offset being cleared
/// \param len The number of elements to clear
/// \param Return nothing (void)

void carr_clear(carr_t* const ca, uint32_t const offset, uint32_t const len)
{
   if isNULL(ca) return;
   uint32_t const last = offset - (len -1);
   if (last >= ca->size) return;
   uint32_t const num_bytes = len * ca->elem_size;
   char* dest = (char *)(ca->arr) + offset * ca->elem_size;
   memset(dest, 0, num_bytes);
   return;
}


/// \brief return true if new_size will be larger than max_size.
/// \param ca Pointer to carr_t.
/// \param new_size The new size being compared to max_size.
/// \return Returns err (1) if new_size is larger than max_size

int carr_too_big(const carr_t* const ca, uint32_t const new_size)
{
   if isZERO(new_size) return 0;
   if isNULL(ca) return 1;
   if isZERO(ca->max_size) return 0;

   return (new_size > ca->max_size);
}

/// \brief Set the carr element to value.
/// \param ca The array being modified
/// \param i The index being modified
/// \param value Pointer to the value being modified
/// \return 1 if error. 0 if successful


int carr_set(carr_t* ca, uint32_t i, const void* const value)
{
   if isNULL(ca) return 1;
   if isNULL(value) return 1;
   uint32_t ip1 = i + 1; // ensure space available for NULL terminate
   if (carr_resize_if_needed(ca, ip1)) return 1;

   // carr_t** cstr_arr;
   // cstr_arr = (carr_t**)ca->arr;
   // cstr_arr[i] = *(carr_t**)value;
   char* dest = (char*)ca->arr +  i * ca->elem_size;
   memcpy(dest, value, ca->elem_size);
   if (i >= ca->len) {
      ca->len = i + 1;
      carr_clear(ca, ca->len, 1); // ensure null-termination
   }

   return 0;
}

void carr_seti(carr_t* ca, void* value)
{
   if isNULL(ca) return;
   carr_set(ca, ca->it, value);
}

void carr_set_it(carr_t* ca, uint32_t new_it)
{
   if isNULL(ca) return;
   ca->it = min(ca->len, new_it);
}

void carr_set_len(carr_t* ca, uint32_t new_len)
{
   if isNULL(ca) return;
   if (new_len > ca->len) return;

   ca->len = new_len;
   carr_clear(ca, new_len, 1);
   if (ca->it > new_len) ca->it = new_len;

}

void carr_push(carr_t* ca, const void* value)
{
   if isNULL(ca) return;
   if isNULL(value) return;
   carr_set(ca, ca->len, value);
   ca->it = ca->len;
}

void carr_pop(carr_t* ca, void* value)
{
   if isNULL(ca) return;
   if isZERO(ca->len) return;
   if (value) carr_get(ca, ca->len-1, value);
   ca->len -= 1;
   carr_clear(ca, ca->len, 1);
   ca->it = ca->len;
}


/// \brief Return current index value of the iterator
/// return The index value of the iterator

uint32_t carr_i(carr_t* ca)
{
   if isNULL(ca) return 0;
   if (ca->it > ca->len) return ca->len;
   return ca->it;
}


/// \brief Return pointer to current value of iterator
/// \param ca The ca being processed
/// \return void* pointer. Return NULL if not valid.

void* carr_ptri(const carr_t* const ca)
{
   if isNULL(ca) return NULL;
   if (!carr_validi(ca)) return NULL;

   uint32_t const offset = ca->it * ca->elem_size;
   char* ptr = (char*)(ca->arr) + offset;
   return (void*)ptr;
}

int in_array(void* needle, void* haystack, uint32_t needle_size, uint32_t num_needles)
{
   if isNULL(needle) return 0;
   if isNULL(haystack) return 0;
   if isZERO(needle_size) return 0;

   bool const check_for_zeroes = isZERO(num_needles);
   for (int i=0; i < num_needles || check_for_zeroes; i++) {

      char* element = (char*)haystack + i*needle_size;
      bool const match = isZERO( memcmp(needle, element, needle_size) );
      if (match) return 1;
      if (!check_for_zeroes) continue;
      if (mem_is_zero(element, needle_size)) break;
   }
   return 0;
}


uint32_t carr_count(carr_t* haystack, void* needles)
{
   if isNULL(haystack) return 0;
   if isNULL(haystack->arr) return 0;
   if isZERO(haystack->len) return 0;

   char elem[haystack->elem_size];
   elem[0] = 'x';

   uint32_t count = 0;
   for_carr (haystack) {
      carr_geti(haystack, elem);
      if (in_array(elem, needles, haystack->elem_size, 0)) {
         count++;
      }
   }
   return count;
}

/// \brief return length (number of elements) of carr
/// \param carr Pointer to c arr structure
/// \return Length of carr.  Return 0 if carr==NULL.

uint32_t carr_len(const carr_t* const carr)
{
   if isNULL(carr) return 0;
   return carr->len;
}


/// \brief split input string into array of strings based on list delimitors
void carr_split(carr_t* const outs, carr_t* const in_arr, carr_t* const delims)
{
   if isNULL(outs) return;
   if isZERO(carr_len(delims)) return;
   if isZERO(carr_len(in_arr)) {
     carr_t* elem = carr_init(0, in_arr->elem_size, NULL, 0);
     carr_set(outs, 0, &elem);
     return;
   }

   carr_firsti(in_arr);
   void* elem_start_p = carr_ptri(in_arr);
   uint32_t elem_start_i = carr_i(in_arr);
   char* zero[in_arr->elem_size];
   memset(zero, 0, in_arr->elem_size);
   while (carr_findi(in_arr, delims)) {
      uint32_t len = carr_i(in_arr) - elem_start_i;
      carr_t* elem = isZERO(len) ?
                     carr_init(0, in_arr->elem_size, zero, 0) :
                     carr_init(0, in_arr->elem_size, elem_start_p, len);
      uint32_t outs_len = carr_len(outs);

      carr_set(outs, outs_len, &elem);
      carr_nexti(in_arr);
      elem_start_p = carr_ptri(in_arr);
      elem_start_i = carr_i(in_arr);
   }
   // if (elem_start_i < carr_len(in_arr)) {
      uint32_t len = carr_i(in_arr) - elem_start_i;
      carr_t* elem = carr_init(0, in_arr->elem_size, elem_start_p, len);
      uint32_t outs_len = carr_len(outs);
      carr_set(outs, outs_len, &elem);
   // }
   return;
}

uint32_t carr_to_end(carr_t* ca)
{
   uint32_t len = carr_len(ca) - carr_i(ca);
   return len;
}

carr_t* carr_slicei(carr_t* ca, uint32_t len)
{
   if isNULL(ca) return NULL;
   carr_set_it(ca, min(carr_len(ca), carr_i(ca)));
   // if isZERO(len) len = carr_len(ca) - carr_i(ca);
   if isZERO(len) return NULL;
   carr_t* slice_p = carr_new(0, ca->elem_size);
   char* elem[ca->elem_size];
   uint32_t fromi = carr_i(ca);
   for (int toi = 0; toi < len; toi++) {
      carr_get(ca, fromi++, elem);
      carr_set(slice_p, toi, elem);
   }
   carr_clear(slice_p, carr_len(slice_p), 1);
   return slice_p;
}

/// \brief Get the filesize
/// This typically includes '\0', so a file contain 'the' would have a size of
/// 4.
/// \param filename The filename to be checked
///
/// \req carr_filesize shall return 0 if fopen fails
/// \req carr_filesize shall return 0 if ftell fails
/// \req carr_filesize shall return filesize of the specified file
uint32_t carr_filesize(const char* const filename)
{
   FILE *infile = fopen(filename, "r");
   if isNULL(infile) return 0;

   int const fseek_err = fseek(infile, 0L, SEEK_END);
   if (fseek_err) {
      fclose(infile);
      return 0;
   }

   long int const filesize = ftell(infile);
   fclose(infile);

   if (filesize < 0) return 0;

   return (uint32_t)filesize;
}


/// \brief read the file into a carr string
/// \param filename the file to be read
///
/// \req carr_read shall return NULL if the filesize is 0.
/// \req carr_read shall return NULL if fopen/fread fails.
/// \req carr_read shall return NULL if malloc fails.
/// \req carr_read shall malloc 4KBytes more than filesize, (carr->size).
/// \req carr_read shall set carr->len to filesize - 1.
/// \req carr_read shall set carr->max_size=0 (for unlimited size growth)
/// \req carr_read shall set carr->str to the contents of the file.

carr_t* carr_read(const char* const filename)
{
   if isNULL(filename) return NULL;
   int is_valid = !isEQS(filename,"");
   uint32_t const margin = 4 * 1024; // leave room for editing before resize
   uint32_t bufsize = margin;
   char* buf = NULL;
   uint32_t size = 2;
   if (is_valid) {
      uint32_t const filesize = carr_filesize(filename);
      bufsize = filesize + margin;
      buf = malloc(bufsize * sizeof(char));
      if isNULL(buf) return NULL;
      *buf = '\0';

      FILE *infile = fopen(filename, "r");
      if (infile) {
         size = fread(buf, sizeof(char), bufsize, infile);
         buf[size] = '\0';
         // int const ferror_code = ferror(infile);
         // bool const fread_error = !isZERO(ferror_code);
         fclose(infile);
      }
   } else { // !is_valid
      bufsize = margin;
      buf = calloc(bufsize, sizeof(char));
      size = 2;
   }

   carr_t* carr = carr_new(0, 1); // malloc(sizeof(carr_t));
   if isNULL(carr) {
      free(buf);
      return NULL;
   }

   carr->size = bufsize;
   carr->len = !is_valid ? 0 :
               isZERO(buf[size-1]) ? size - 2 : size - 1;
   carr->max_size = 0;
   carr->arr = buf;

   return carr;
}


/// \brief read entire file into array of cstrings

carr_t* carr_read_lines(const char* const filename)
{
   if isNULL(filename) return NULL;
   carr_t* const s1 = carr_read(filename);
   if isNULL(s1) return NULL;

   carr_t* delims = carrs_init("\n");
   if isNULL(delims) return NULL;

   carr_t* lines = carrp_new();
   if isNULL(delims) return NULL;

   carr_split(lines, s1, delims);

   carr_free(s1);
   carr_free(delims);
   return lines;
}

/// \brief Print the ca to stdout
/// \param ca The cstr to be printed
/// \return return nothing (void)
/// \TODO carr_print on works for character strings

void carr_print(carr_t* ca)
{
   if isNULL(ca) return;
   if isNULL(ca->arr) return;

   printf("%s", ca->arr);
}

int carr_write2d(carr_t* ca, char* filename)
{
   if isNULL(ca) return 0;
   FILE* outfile = fopen(filename, "w");
   if isNULL(outfile) return 1;

   carr_t* line = NULL;
   uint32_t char_printed_total = 0;
   int err = 0;
   foreach_carr(&line, ca) {
      int char_printed = 0;
      if (isNULL(line) || isZERO(carr_len(line))) {
         char_printed = fprintf(outfile, "\n");
      } else {
         char_printed = fprintf(outfile, "%s\n", line->arr);
      }
      // fflush(outfile);
      err = (char_printed < 0);
      if (err) break;
      char_printed_total += char_printed;
   }
   fclose(outfile);
   return err;
}


/// \brief make gap in array
void carr_make_space(carr_t* const ca, uint32_t const amount, uint32_t const at)
{
   if isNULL(ca) return;
   if isZERO(amount) return;
   if (at >= ca->len) return;

   char value[ca->elem_size];
   for (int i = ca->len-1; i >= at; i--) {
      carr_set(ca, i + amount, carr_get(ca, i, value));
      if isZERO(i) break;
   }
}

/// \brief delete entries from array
void carr_del(carr_t* ca, uint32_t amount, uint32_t at)
{
   if isNULL(ca) return;
   if (at >= ca->len) return;
   // if isZERO(amount) amount = ca->len - at;

   uint32_t from = at + amount;
   if (from > ca->len) {
      from = ca->len;
      amount = ca->len - at;
   }
   if isZERO(amount) return;

   char value[ca->elem_size];
   for (uint32_t i = from; i <= ca->len; i++) {
      carr_set(ca, at++, carr_get(ca, i, value));
   }
   ca->len -= amount;
   ca->it = min(ca->it, ca->len);
}

void carr_deli(carr_t* ca, uint32_t n)
{
   carr_set_it(ca, carr_i(ca));
   carr_del(ca, n, carr_i(ca));
   carr_set_it(ca, carr_i(ca));
}

void carr_del2d(carr_t* carr_2d, uint32_t sr, uint32_t sc, uint32_t er, uint32_t ec) {
   carr_t* start_line = NULL;
   carr_get(carr_2d, sr, &start_line);
   int32_t del_lines = er - sr;
   bool single_line = isZERO(del_lines);
   uint32_t line_len = carr_len(start_line);
   uint32_t del_chars = single_line ? ec - sc : line_len - sc;
   carr_del(start_line, del_chars, sc);
   if isFALSE(single_line) {
      carr_t* stop_line = NULL;
      carr_get(carr_2d, er, &stop_line);
      carr_del(stop_line, ec, 0);
      carr_append(start_line, stop_line);
      carr_t* carr_tmp;
      for (int i = sr+1; i <= er; i++) {
         carr_get(carr_2d, i, &carr_tmp);
         carr_free(carr_tmp);
      }
      carr_del(carr_2d, del_lines, sr+1);
   }
}

/// \brief overwrite the contents of the array
void carr_overwrite(carr_t* const ca, const void* arr, uint32_t len, uint32_t at)
{
   if isNULL(ca) return;
   if isNULL(arr) return;

   bool const null_term = isZERO(len);
   uint32_t const esize = ca->elem_size;
   const void* src_p = arr;
   for (int i = 0; i < len || null_term; i++) {
      if (null_term && mem_is_zero(src_p, esize)) break;
      uint32_t const ati = at + i;
      carr_set(ca, ati, src_p);
      src_p += esize;
   }
}


/// \brief insert the argument into the carr
void carr_insert(carr_t* const ca, const void* arr, uint32_t const len, uint32_t const at)
{
   if isNULL(ca) return;
   if isNULL(arr) return;

   uint32_t const len2 = isZERO(len) ? arrlen(arr, ca->elem_size, 0) : len;
   carr_make_space(ca, len2, at);
   carr_overwrite(ca, arr, len2, at);
}

/// \brief insert the argument into the carr at the iterator position
void carr_inserti(carr_t* const ca, const void* arr, uint32_t const len)
{
   if isNULL(ca) return;
   if isNULL(arr) return;

   ca->it = min(ca->it, ca->len);

   carr_insert(ca, arr, len, ca->it);
   ca->it += len;
}

/// \brief insert the argument into the carr
void carr_insert2(carr_t* const ca, void** const arr, uint32_t const len, uint32_t const at)
{
   if isNULL(ca) return;
   if isNULL(arr) return;

   uint32_t esize = ca->elem_size;

   uint32_t const len2 = isZERO(len) ? arrlen(arr, esize, 0) : len;

   carr_make_space(ca, len2, at);

   uint32_t it = at;
   for (int i = 0; 1; i++) {
      bool done = isZERO(len) ? mem_is_zero(arr,esize) : !(i < len);
      if (done) break;
      carr_t* n = carr_init(0, esize, arr[i], len); // FIXME make generic
      carr_set(ca, it++, &n);
   }
}


