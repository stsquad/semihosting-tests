# Makefile for semihosting tests
#
# Copyright (c) 2015 Linaro Limited
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
# 3. Neither the name of Linaro Limited nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
#
# We have several orthogonal cases we'd like to test:
# A32 vs T32 vs A64
# usermode vs system
# gdb syscalls vs normal
#
# For the moment this is only testing usermode.

A32GCC := arm-linux-gnueabihf-gcc -marm
T32GCC := arm-linux-gnueabihf-gcc -mthumb
A64GCC := aarch64-linux-gnu-gcc

A32LD := arm-linux-gnueabihf-ld

all: usertest-a32 usertest-a64 usertest-t32

usertest-srcs = usertest.c semihosting.c semicall.S

systest-srcs = start.S string.c printf/printf.c $(usertest-srcs)

usertest-a32: $(usertest-srcs)
	$(A32GCC) --static -o $@ $^

usertest-t32: $(usertest-srcs)
	$(T32GCC) --static -o $@ $^

usertest-a64: $(usertest-srcs)
	$(A64GCC) --static -o $@ $^

systest-a32.axf: $(systest-srcs)
	$(A32GCC) -nostdlib -o $@ $^ -lgcc -Xlinker --script=baremetal.lds

systest-t32.axf: $(systest-srcs)
	$(T32GCC) -nostdlib -o $@ $^ -Xlinker --script=baremetal.lds

systest-a64.axf: $(systest-srcs)
	$(A64GCC) -nostdlib -o $@ $^ -lgcc -Xlinker --script=baremetal.lds

