#!/usr/bin/env python3

import sys
import re

with open(sys.argv[1], "r") as inp:
    with open(sys.argv[2], "w") as out:
        in_src = False
        startp = re.compile(r"^\s*#\+begin_src .* :tangle")
        endp = re.compile(r"^\s*#\+end_src")
        quoted = re.compile(r"^\s*,(\*|,\*|#\+)")

        lines = inp.readlines()
        curr = []
        min_spaces = -1
        for line in lines:
            if startp.match(line):
                in_src = True
            elif endp.match(line):
                in_src = False
                for l in curr:
                    out.write(l[min_spaces:])
                curr = []
                min_spaces = -1
            elif in_src:
                spaces = len(line) - len(line.lstrip())
                if min_spaces == -1 or min_spaces > spaces:
                    min_spaces = spaces
                curr.append(re.sub(r"^(\s*),(\*|,\*|#\+|,#\+)", r"\1\2", line))
