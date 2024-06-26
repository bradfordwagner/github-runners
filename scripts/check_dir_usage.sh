#!/bin/bash
set -x

dir=$1
sudo du -cha --max-depth=1 ${dir} | grep -E "M|G"
