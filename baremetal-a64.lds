/*
 * baremetal.lds : simple linker script for baremetal test cases
 *
 * Copyright (C) 2015 Linaro Limited. All rights reserved.
 * 
 * Memory layout is for the virt board which puts RAM at 0x40000000
 *
 * Use:
 *  $(LD) -o image.axf input.o --script=baremetal.lds
 */

OUTPUT_FORMAT("elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
TARGET(binary)
RAMSTART = 0x40000000;
STACKTOP = 0x40200000;
SECTIONS
{
 . = RAMSTART;
 .text : { *(.text) }
 .data : { *(.data) }
 .bss : { *(.bss) }
 . = STACKTOP;
 stacktop = .;
}
