{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion = {
      enable = true;
    };
    defaultKeymap = "viins";
    history = {
      append = true;
      ignoreAllDups = true;
    };
    shellAliases = {
      "ll" = "ls -alF";
      "la" = "ls -a";
      "l" = "ls -F";
      "sl" = "ls";
    };
    syntaxHighlighting.enable = true;
    initExtra = ''
    which lesspipe.sh &> /dev/null && export LESSOPEN="|lesspipe.sh %s"
    which eza &> /dev/null && alias ls=eza
    which nvim &> /dev/null && alias vi=nvim && alias vim=nvim
    parse_git_dirty() {
      git_status="$(git status 2> /dev/null)"
      [[ "$git_status" =~ "use \"git push\" to publish your local commits" ]] && echo -n " %F{green}%f"
      [[ "$git_status" =~ "Changes to be committed:" ]] && echo -n " %F{magenta}%f"
      [[ "$git_status" =~ "Changes not staged for commit:" ]] && echo -n " %F{yellow}%f"
      [[ "$git_status" =~ "Untracked files:" ]] && echo -n " %F{red}%f"
    }
    setopt prompt_subst
    autoload -Uz vcs_info
    precmd () { vcs_info }
    zstyle ':vcs_info:*' formats ' %F{blue}%b%f' # git(main)
    PS1='%(?..%B%F{red}[%?%\]%f%b )%F{green}%20<...<%~%<<%f$vcs_info_msg_0_$(parse_git_dirty) $ '
    '';
    profileExtra = ''
    if [ ! -S ~/.ssh/ssh_auth_sock ]; then
        eval `ssh-agent` > /dev/null
        ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
    fi
    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
    '';
  };
}
