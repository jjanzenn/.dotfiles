#!/bin/sh

usage ()
{
    echo "Usage: $0 [-u/-i]"
}

dir="$pwd"
cd ~/.dotfiles || exit 1

while getopts ":hui" arg; do
    case "$arg" in
        h)
            usage
            cd "$dir" || exit 1
            exit 0
            ;;
        u)
            make update
            cd "$dir" || exit 1
            exit 0
            ;;
        i)
            make install
            cd "$dir" || exit 1
            exit 0
            ;;
        *)
            cd "$dir" || exit 1
            exit 1
            ;;
    esac
done
