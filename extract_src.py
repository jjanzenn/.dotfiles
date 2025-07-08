#!/usr/bin/env python3

import os
from stat import ST_MODE
import sys
import re

def extract(lines, out, startp, endp, quoted, unquoted):
    in_src = False
    curr = []
    min_spaces = -1

    for line in lines:
        if not in_src and startp.match(line):
            in_src = True
        elif in_src and endp.match(line):
            in_src = False
            for l in curr:
                out.write(l[min_spaces:])
            curr = []
            min_spaces = -1
        elif in_src:
            spaces = len(line) - len(line.lstrip())
            if min_spaces == -1 or min_spaces > spaces:
                min_spaces = spaces
            if quoted != None and unquoted != None:
                curr.append(re.sub(quoted, unquoted, line))
            else:
                curr.append(line)

def main():
    startp = None
    endp = None
    quoted = None
    unquoted = None
    if sys.argv[1].endswith(".org"):
        startp = re.compile(r"^\s*#\+begin_src")
        endp = re.compile(r"^\s*#\+end_src")
        quoted = r"^(\s*),(\*|,\*|#\+|,#\+)"
        unquoted = r"\1\2"
    elif sys.argv[1].endswith(".md"):
        startp = re.compile(r"^```")
        endp = re.compile(r"^```")

    with open(sys.argv[1], "r") as inp:
        with open(sys.argv[2], "w") as out:
            lines = inp.readlines()

            extract(lines, out, startp, endp, quoted, unquoted)

            os.chmod(sys.argv[2], os.stat(sys.argv[1])[ST_MODE])

if __name__ == "__main__":
    main()
