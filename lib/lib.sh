#!/bin/bash

throw() {
    echo "${1-Oops... An internal error has occurred, spank us!}"
    exit 1
}

check_num_args() {
    if [ $# -lt 3 ]; then
        throw "Internal error: the function $FUNCNAME() expecting 3 required parameters!"
    fi

    if [ $1 -gt $2 ]; then
        throw "Internal error: the function $3() expecting at least $1 required parameters!"
    fi
}

require() {
    check_num_args 1 $# $FUNCNAME

    if [ ! -f "$1" ]; then
        throw "${2-Internal error: the file \"$1\" does not exist!}"
    fi
    . "$1"
}