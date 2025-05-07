export PATH="$HOME/node_modules/.bin:$HOME/bin:$HOME/gems/bin:$HOME/.local/bin:$HOME/go/bin:/usr/local/bin:/Library/TeX/texbin/:$PATH"

if [ "$(uname)" = 'Darwin' ]; then
    export GPG_TTY=$(tty)
fi

if [ "$(uname)" = 'Darwin' ]; then
    PIPX_HOME="$HOME/.local/pipx"
fi
