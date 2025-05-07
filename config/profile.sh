export PATH="$HOME/node_modules/.bin:$HOME/bin:$HOME/gems/bin:$HOME/.local/bin:$HOME/go/bin:/usr/local/bin:/Library/TeX/texbin/:/opt/homebrew/bin:$PATH"

if [ "$(uname)" = 'Darwin' ]; then
    export GPG_TTY=$(tty)
    export PIPX_HOME="$HOME/.local/pipx"
    export EDITOR="vim"
fi
