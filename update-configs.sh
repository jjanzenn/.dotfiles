#!/bin/sh

if ! test -d ~/.dotfiles; then
    echo "installing dotfiles..."
fi

find -- * -type f -name "*.org" | while read -r file; do
    echo "installing ${file} configuration..."
    # emacs --batch "${file}" -f package-initialize --eval '(org-babel-tangle)'
done
