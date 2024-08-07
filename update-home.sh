#!/bin/sh

# install the dotfiles source if it is not present
if ! test -d ~/.dotfiles; then
    echo Installing dotfiles...
    git clone git@git.sr.ht:~jjanzen/.dotfiles ~/.dotfiles
fi

if ! diff ~/.dotfiles/update-home ~/.local/bin/update-home; then
   cp ~/.dotfiles/update-home ~/.local/bin/update-home || exit 1
   echo Changes have been made to the update-home script.
   echo Running the new update-home script.
   ~/.local/bin/update-home
   exit
fi

# save the current working directory and move to the dotfiles repository
CWD=$(pwd)
cd ~/.dotfiles || exit
git stash
git checkout main
git pull --rebase

find -- * -type f -name "*.org" | while read -r file; do
    echo Installing "${file}" configuration...
    # emacs --batch "${file}" -f package-initialize --eval '(org-babel-tangle)'
done

cd "${CWD}" || exit
