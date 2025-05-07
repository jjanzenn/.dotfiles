#!/bin/sh

open -n "$(find -L /Applications /System/Applications /System/Applications/Utilities ~/Applications /opt/homebrew/opt/emacs-plus@* -maxdepth 1 -name "*.app" | choose -f "SauceCodePro Nerd Font" -s 15)"
