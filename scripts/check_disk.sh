#!/bin/bash
set -x

sudo du -cha --max-depth=1 . | grep -E "M|G"
df -kh | grep vda2
