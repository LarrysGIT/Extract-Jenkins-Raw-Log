
path = "Samplelog"

import re
import gzip
import codecs
import base64

PREAMBLE_STR = "\x1B\[8mha:" # regular expression
POSTAMBLE_STR = "\x1B\[0m" # regular expression

f = codecs.open(path, "r")
content = f.readlines()

for line in content:
    line_split = re.split("{}|{}".format(PREAMBLE_STR, POSTAMBLE_STR), line)
    if len(line_split) < 2:
        continue
    line_base64data = base64.b64decode(line_split[1])
    line_base64data = line_base64data[40:]
    extract = gzip.decompress(line_base64data)
    print("Original line: ")
    print("  {}".format(line))
    print("    Extracted line: ")
    print("      Part1: {} ".format(line_split[0]))
    print("      Part2: {} ".format(extract))
    print("      Part3: {} ".format(line_split[2].strip()))
