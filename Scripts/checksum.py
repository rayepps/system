#!/usr/bin/python

import hashlib
import sys

filepath = sys.argv[1]

file = open(filepath, 'r')
data = file.read()
hasher = hashlib.sha256()
hasher.update(data)
checksum = hasher.hexdigest()

print(checksum)
