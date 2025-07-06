#!/bin/bash

if [[ $# -eq 0 ]]; then
    fyne
elif [[ $# -eq 1 ]] && [[ "$1" == "snooze" ]]; then
    source /home/gocompiler/snooze.sh
else
    fyne $@
fi
