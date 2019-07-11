/*
 * usertest.c -- top level test file for usermode tests.
 *
 * System tests also call this main after start[-microbit].S
 *
 * Copyright (c) 2015 Linaro Limited
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

#include <stdio.h>
#include "semihosting.h"
#include "printf/printf.h"

char filebuf[2048];

/* This is needed by libgcc */
int raise(int sig)
{
    semi_fatal("raise called (division by zero?)\n");
}

void semi_putc(void *p, char c)
{
    semi_writec(c);
}

int main(void)
{
    void *bufp;
    unsigned int sz;

    init_printf(NULL, semi_putc);

    semi_write0("hello world via semi_write0\n");

    semi_write0("open file test\n");

    /* caution -- this will not do a length check on the buffer! */
    bufp = filebuf;
    if (semi_load_file(&bufp, &sz, "testdata.txt") < 0) {
        semi_write0("semi_load_file failed!\n");
        return 1;
    }
    if (sz >= sizeof(filebuf)) {
        semi_write0("test file too big for buffer\n");
        return 1;
    }

    filebuf[sizeof(filebuf) - 1] = 0;

    printf("read %d bytes from file\n", sz);
    semi_write0("buffer contents:\n");
    semi_write0(filebuf);
    semi_write0("tests complete, exiting via semihosting\n");

    semi_exit(0);
    /* not reached */
}
