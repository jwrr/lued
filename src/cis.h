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


/**
 * @file
 * @brief This file contains macros so that '==' is not required.
 *
 * @main
 **/

#ifndef CIS_H
#define CIS_H

#include <string.h>

#define isEQ(A, B) ((A) == (B))

#define isZERO(A) isEQ(A, 0)
#define isFALSE(A) isEQ(A, 0)
#define isNULL(A) isEQ(A, NULL)

#define isEQS(A, B) ( (isNULL(A) || isNULL(B)) ? 0 : (strcmp(A,B) == 0) )

#define min(A, B) ( ( (A) < (B) ) ? (A) : (B) )

#define max(A, B) ( ( (A) > (B) ) ? (A) : (B) )

#define safe_strncpy(D,S,N) D[0]='\0'; if (S) strncpy(D,S,N-1); D[N-1]='\0';

#endif
