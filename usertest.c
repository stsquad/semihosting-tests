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

#define TESTDATA_FILE "testdata.txt"
const char file[] = "Small file of text data for test.\n";

static int test_istty(void)
{
    int fd;
    int fail = 0;

    fd = semi_open(TESTDATA_FILE, OPEN_RDONLY);
    if (fd == -1) {
        semi_write0("FAIL could not open test data file\n");
        return 1;
    }

    switch (semi_istty(fd)) {
    case 0:
        semi_write0("PASS istty(file) returned 0\n");
        break;
    case 1:
        semi_write0("FAIL istty(file) returned 1\n");
        fail++;
        break;
    default:
        semi_write0("FAIL istty(file) failed\n");
        fail++;
        break;
    }
    semi_close(fd);
    if (fail) {
        return 1;
    }

    fd = semi_open(":tt", OPEN_RDONLY);
    if (fd == -1) {
        semi_write0("FAIL could not open stdin\n");
        return 1;
    }

    switch (semi_istty(fd)) {
    case 0:
        semi_write0("FAIL istty(stdin) returned 0\n");
        fail++;
        break;
    case 1:
        semi_write0("PASS istty(stdin) returned 1\n");
        break;
    default:
        semi_write0("FAIL istty(stdin) failed\n");
        fail++;
        break;
    }
    semi_close(fd);
    if (fail) {
        return 1;
    }
    return 0;
}

/*
 * Caution: don't pass a 'pos' that would seek off the end of the file or
 * so close to the end that the read fails. We check for this, but it's
 * a test-coding bug.
 */
#define CHUNK_SZ 12
static int test_one_seek(int fd, int pos)
{
    int i;

    if ((pos + CHUNK_SZ) >= sizeof(file)) {
        semi_write0("FAIL test bug: test_one_seek called with pos too large\n");
        return 1;
    }

    if (semi_seek(fd, pos) != 0) {
        semi_write0("FAIL could not seek to byte position\n");
        return 1;
    }

    if (semi_read(fd, filebuf, CHUNK_SZ)) {
        semi_write0("FAIL could not read from seeked-to position\n");
        return 1;
    }

    for (i = 0; i < CHUNK_SZ; i++) {
        if (filebuf[i] != file[i + pos]) {
            semi_write0("FAIL mismatch in data read from seeked-to position\n");
            return 1;
        }
    }

    return 0;
}

static int test_seek(void)
{
    int fd;
    int fail = 0;

    fd = semi_open(TESTDATA_FILE, OPEN_RDONLY);
    if (fd == -1) {
        semi_write0("FAIL could not open test data file\n");
        return 1;
    }

    /* Seek forwards */
    if (test_one_seek(fd, 6)) {
        return 1;
    }
    semi_write0("PASS seek to position 6 and read data\n");

    /* and then backwards */
    if (test_one_seek(fd, 2)) {
        return 1;
    }
    semi_write0("PASS seek to position 2 and read data\n");

    semi_close(fd);
    return 0;
}

int main(void)
{
    void *bufp;
    unsigned int sz, i;

    init_printf(NULL, semi_putc);

    /* If writing output succeeds it is in itself a test */
    semi_write0("PASS sending output via semi_write0\n");

    /* Open file test: this checks open/flen/read/close */

    bufp = filebuf;
    sz = sizeof(filebuf);
    if (semi_load_file(&bufp, &sz, TESTDATA_FILE) < 0) {
        semi_write0("FAIL semi_load_file failed!\n");
        return 1;
    }

    /* note that file[] has a trailing \0 which isn't in the filebuf */
    if (sz == sizeof(file) - 1) {
        semi_write0("PASS test file size matches expected\n");
    } else {
        semi_write0("FAIL test file not expected size\n");
        return 1;
    }

    for (i = 0; i < sz; i++) {
        if (filebuf[i] != file[i]) {
            semi_write0("FAIL test file contents don't match expected data\n");
            return 1;
        }
    }
    semi_write0("PASS test file contents match\n");

    if (test_istty()) {
        return 1;
    }

    if (test_seek()) {
        return 1;
    }

    semi_write0("ALL TESTS PASSED\n");
    semi_exit(0);
    /* not reached */
}
