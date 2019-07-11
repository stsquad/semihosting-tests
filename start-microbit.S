/*
 * start-microbit.S - assembly code for startup on baremetal M-profile tests
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

        .syntax unified
        .cpu cortex-m0
        .thumb

        .text

vector_table:
        .word STACKTOP          /* 0. SP_main */
        .word reset_thumb       /* 1. Reset */
        .word 0                 /* 2. NMI */
        .word 0                 /* 3. HardFault */
        .rept 7
        .word 0                 /* 4-10. Reserved */
        .endr
        .word 0                 /* 11. SVCall */
        .word 0                 /* 12. Reserved */
        .word 0                 /* 13. Reserved */
        .word 0                 /* 14. PendSV */
        .word 0                 /* 15. SysTick */
        .rept 32
        .word 0                 /* 16-47. External Interrupts */
        .endr

        /* declare as a function so pointers are appropriatley "thumbed" */
        .type reset_thumb, function
        .global reset_thumb
reset_thumb:

        bl main
        bl semi_exit
        # not reached
1:      b 1b
