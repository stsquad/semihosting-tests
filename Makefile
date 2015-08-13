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

QEMU_BUILDDIR := ~/linaro/qemu-from-laptop/qemu/build/x86

QEMU_ARM = $(QEMU_BUILDDIR)/arm-linux-user/qemu-arm
QEMU_AARCH64 = $(QEMU_BUILDDIR)/aarch64-linux-user/qemu-aarch64
QEMU_SYSTEM_ARM = $(QEMU_BUILDDIR)/arm-softmmu/qemu-system-arm
QEMU_SYSTEM_AARCH64 = $(QEMU_BUILDDIR)/aarch64-softmmu/qemu-system-aarch64


all: usertest-a32 usertest-a64 usertest-t32 \
	systest-a32.axf systest-t32.axf systest-a64.axf

usertest-srcs = usertest.c semihosting.c semicall.S printf/printf.c

systest-srcs = start.S string.c $(usertest-srcs)

usertest-a32: $(usertest-srcs)
	$(A32GCC) --static -o $@ $^

usertest-t32: $(usertest-srcs)
	$(T32GCC) --static -o $@ $^

usertest-a64: $(usertest-srcs)
	$(A64GCC) --static -o $@ $^

systest-a32.axf: $(systest-srcs)
	$(A32GCC) -nostdlib -o $@ $^ -lgcc -Xlinker --script=baremetal.lds

systest-t32.axf: $(systest-srcs)
	$(T32GCC) -nostdlib -o $@ $^ -lgcc -Xlinker --script=baremetal.lds

systest-a64.axf: $(systest-srcs)
	$(A64GCC) -nostdlib -o $@ $^ -lgcc -Xlinker --script=baremetal-a64.lds

run-usertest-a32: usertest-a32
	$(QEMU_ARM) usertest-a32

run-usertest-t32: usertest-t32
	$(QEMU_ARM) usertest-t32

run-usertest-a64: usertest-a64
	$(QEMU_AARCH64) usertest-a64

run-systest-a32: systest-a32.axf
	$(QEMU_SYSTEM_ARM) -M virt --display none --semihosting -kernel $^

run-systest-t32: systest-t32.axf
	$(QEMU_SYSTEM_ARM) -M virt --display none --semihosting -kernel $^

run-systest-a64: systest-a64.axf
	$(QEMU_SYSTEM_AARCH64) -M virt --display none --semihosting \
		-cpu cortex-a57 -kernel $^

run: run-usertest-a32 run-usertest-t32 run-usertest-a64 \
	run-systest-a32 run-systest-t32 run-systest-a64
