bindkey -e

autoload -U compinit && compinit
source "$(/opt/homebrew/bin/brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history)

HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="$HOME/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
unsetopt HIST_SAVE_NO_DUPS
unsetopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY
setopt autocd

which lesspipe.sh &> /dev/null && export LESSOPEN="|lesspipe.sh %s"
which eza &> /dev/null && alias ls=eza
parse_git_dirty() {
  git_status="$(git status 2> /dev/null)"
  [[ "$git_status" =~ "use \"git push\" to publish your local commits" ]] && echo -n " %F{green}%f"
  [[ "$git_status" =~ "Changes to be committed:" ]] && echo -n " %F{magenta}%f"
  [[ "$git_status" =~ "Changes not staged for commit:" ]] && echo -n " %F{yellow}%f"
  [[ "$git_status" =~ "Untracked files:" ]] && echo -n " %F{red}%f"
}
setopt prompt_subst
autoload -Uz vcs_info
precmd () {
    vcs_info
}
zstyle ':vcs_info:*' formats ' %F{blue}%b%f' # git(main)
PS1='%(?..%B%F{red}[%?%\]%f%b )%F{green}%20<...<%~%<<%f$vcs_info_msg_0_$(parse_git_dirty) $ '

alias -- l='ls -F'
alias -- la='ls -a'
alias -- ll='ls -alF'
alias -- sl=ls

source "$(/opt/homebrew/bin/brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
ZSH_HIGHLIGHT_HIGHLIGHTERS+=()
