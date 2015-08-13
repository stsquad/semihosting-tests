/*
 * start.S - assembly code for startup on baremetal tests
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

#ifndef __aarch64__
        .syntax unified
#endif

        .text

        .globl start
start:
        # We assume uniprocessor.

#ifndef __aarch64__
        # Set up a stack
        ldr sp, =stacktop

        # Turn on the FPU
        mov r0, 0xf00000
        mcr p15, 0, r0, c1, c0, 2

        bl main
        bl semi_exit
        # not reached
1:      b 1b

#else

        # Set up a stack
        ldr x0, =stacktop
        mov sp, x0

        # Turn on the FPU
        mov x0, 0x300000
        msr CPACR_EL1, x0

        bl main
        bl semi_exit
        # not reached
1:      b 1b

#endif
