#!/bin/bash

if [ -z "$TPWD" ]; then
    TPWD=`pwd`
fi

main::_version() {
    echo "0.0.2"
}

main::_build() {
    local env="$TPWD/lib/env"
    if [ ! -f "$env" ]; then
        echo "Internal error: the file \"$env\" does not exist!"
        exit 1
    fi
    . "$env"

    local lib="$TPWD/lib/lib$SHELL_EXT"
    if [ ! -f "$lib" ]; then
        echo "Internal error: the file \"$lib\" does not exist!"
        exit 1
    fi
    . "$lib"
}

main::_validate() {
    check_num_args 2 $# $FUNCNAME

    local command="$1"
    local modules=( "${!2}" )

    if [ -z $command ]; then
        throw "You have not specified a command!"
    fi

    if [ -z $modules ]; then
        throw "You have not specified modules for $command!"
    fi

    for module in "${modules[@]}"; do
        if [ ! -d "$MODULES_PATH/$module" ]; then
            throw "The \"$module\" module is unknown to the Tambourine!"
        fi

        if [ ! -f "$MODULES_PATH/$module/$command$SHELL_EXT" ]; then
            throw "The \"$command\" command is unknown to the \"$module\" module!"
        fi
    done
}

main() {
    main::_build

    # init options
    local args=`getopt -o 'v' --long 'version' -- "$@"`
    eval set -- "$args"
    while true ; do
        case "$1" in
            -v|--version )
                main::_version
                exit 0
                shift;;
            -- ) shift; break;;
        esac
    done

    # init command
    local command="$1"

    # init modules
    local modules=( "${@:2}" )

    # execute the module's script
    main::_validate "$command" "modules[@]"
    for module in "${modules[@]}"; do
        require "$MODULES_PATH/$module/$command$SHELL_EXT"
    done
}; main $@
