#!/bin.sh
find ${XDG_RUNTIME_DIR:-/tmp} -maxdepth 1 -type f -name 'vline.*' -mtime +1 -delete

