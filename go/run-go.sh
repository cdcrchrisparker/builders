#!/bin/bash

if [[ $# -eq 0 ]]; then
    go
elif [[ $# -eq 1 ]] && [[ "$1" == "snooze" ]]; then
    source /home/gocompiler/snooze.sh
else
    go $@
fi
