#!/bin/env python3
# -*- coding: utf-8 -*-
#
# Pipe Helper Tool for testing
#
# Copyright 2019 Linaro Ltd
#
# Author: Alex Bennée <alex.bennee@linaro.org>
#

from argparse import ArgumentParser
from time import sleep
from os import mkfifo

import tempfile
import logging

logger = logging.getLogger("pipetool")

#
# Command line options
#
def parse_arguments():
    """
    Read the arguments and return them to main.
    """
    parser = ArgumentParser(description="Pipe Test Helper.")
    parser.add_argument("--delay", type=float, default=1.0,
                        help="delay of echo")
    parser.add_argument("--verbose", action="store_true", default=False)

    return parser.parse_args()

if __name__ == "__main__":
    args = parse_arguments()

    if args.verbose:
        logger.setLevel(logging.DEBUG)

    with tempfile.TemporaryDirectory(prefix="pipetool.") as dirname:
        print(dirname)

        pipe_in = "%s/pipe.in" % (dirname)
        pipe_out = "%s/pipe.out" % (dirname)

        mkfifo(pipe_in)
        mkfifo(pipe_out)

        pin = open(pipe_in, mode="w")
        pout = open(pipe_out, mode="r")

        logger.debug("Waiting for first character")

        while True:
            c = pout.read(1)
            if not c:
                break

            print(c, end ="")
            logger.debug("sending %c" % (c))
            pin.write(c)

        logger.debug("Finishing")
