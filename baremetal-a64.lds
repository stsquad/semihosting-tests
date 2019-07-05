/*
 * baremetal-a64.lds : simple linker script for baremetal test cases
 *
 * Copyright (C) 2015 Linaro Limited. All rights reserved.
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
 * Memory layout is for the virt board which puts RAM at 0x40000000
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
