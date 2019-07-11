/*
 * microbit.lds : simple linker script for baremetal ARM-M test cases
 *
 * Copyright (C) 2019 Linaro Limited. All rights reserved.
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
 *
 * Memory layout is for the BBC Microbit board which puts RAM at 0x20000000
 */

RAMSTART = 0x20000000;
/* 2kb stack, from the top of RAM */
STACKBOT = 0x20003800;
STACKTOP = 0x20004000;

/* QEMU ignores this in favour of vector_table anyway */
ENTRY(reset_thumb)

SECTIONS
{
    . = 0x0;
    .text : {
        *(.text)
    }
    . = RAMSTART;
    .data : {
        *(.data)
    }
    .bss : {
        *(.bss)
    }
    /* linker should complain if data+bss run into this */
    . = STACKBOT;
    /DISCARD/ : {
        *(.ARM.attributes)
    }
}
