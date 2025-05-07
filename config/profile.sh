export PATH="$HOME/node_modules/.bin:$HOME/bin:$HOME/gems/bin:$HOME/.local/bin:$HOME/go/bin:/usr/local/bin:/Library/TeX/texbin/:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

export MANPATH="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/share/man:/usr/share/man:$MANPATH"

if [ "$(uname)" = 'Darwin' ]; then
    export GPG_TTY=$(tty)
    export PIPX_HOME="$HOME/.local/pipx"
    export EDITOR="vim"
fi
