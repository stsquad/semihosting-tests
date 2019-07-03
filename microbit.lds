/*
 * microbit.lds : simple linker script for baremetal ARM-M test cases
 *
 * Copyright (C) 2019 Linaro Limited. All rights reserved.
 *
 * Memory layout is for the BBC Microbit board which puts RAM at 0x20000000
 */

RAMSTART = 0x20000000;
STACKTOP = 0x20004000;

ENTRY(exc_reset_thumb)

SECTIONS
{
    . = 0x0;
    .text : {
        *(.text)
    }
    .rodata : {
        *(.rodata)
    }
    . = RAMSTART;
    .data : {
        *(.data)
    }
    .bss : {
        *(.bss)
    }
    /DISCARD/ : {
        *(.ARM.attributes)
    }
}
