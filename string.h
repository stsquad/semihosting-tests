/*
 * Copyright (c) 2012 Linaro Limited
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 * 3. Neither the name of Linaro Limited nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 */

#ifndef STRING_H
#define STRING_H

#include <stddef.h>

extern void *(memcpy)(void *__dest, __const void *__src, size_t __n);
extern void *(memmove)(void *__dest, __const void *__src, size_t __n);
extern void *(memchr)(void const *s, int c, size_t n);
extern size_t (strlen)(const char *s);
extern void *(memset)(void *s, int c, size_t count);
extern int (memcmp)(void const *p1, void const *p2, size_t n);
extern int (strcmp)(char const *s1, char const *s2);
extern int (strncmp)(char const *s1, char const *s2, size_t n);
extern char *(strchr)(char const *s, int c);

#endif
