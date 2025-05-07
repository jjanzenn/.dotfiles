#!/bin/sh

dir="$(pwd)"
cd /Users/jjanzen/org/ || exit
git add -A
git commit -m 'backup'
git push
cd "$dir" || exit
