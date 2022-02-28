bindkey -e

PATH="$HOME/homebrew/bin:$PATH"
eval "$(anyenv init -)"

export EDITOR="vim"


# Prompt
source ~/.zsh/git-prompt.sh
setopt PROMPT_SUBST
GIT_PS1_SHOWDIRTYSTATE=true
PROMPT='%F{cyan}%C%f%F{red}|%f%F{green}$(__git_ps1 "%s")%f %F{cyan}⇒%f '

# Git Completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit

# fzf
# --------------------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# - CTRL-O to open with `open` command,
# - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-nvim} "$file"
  fi
}

function fcd-ghq () {
  local selected_dir=$(ghq list -p| fzf)
  if [ -n "$selected_dir"  ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fcd-ghq
bindkey '^]' fcd-ghq


# Colorize ls command
alias ls='gls --color=auto'


# Alias
alias vizsh='vim ~/.zshrc && source ~/.zshrc'
alias cl='clear'

## Git
alias g='git'
alias co='git checkout'
alias br='git branch'
alias cobr='git checkout -b'
alias c='git checkout $(git branch | sort -r | fzf | sed -e "s/* //" | sed -e "s/ *//")'
alias cm='git commit'
alias st='git status'
alias recm='git commit --amend'

## GitHub
alias pr='gh pr create --web'

## Bundler
alias be='bundle exec'


## Tmux
alias tls='tmux ls'
alias att='tmux attach-session -d -t'
alias tkill='tmux kill-session -t'
alias tnew='tmux new -s'
alias vitmux='vi ~/.tmux.conf && tmux source-file ~/.tmux.conf && tmux display-message "reloading config..."'
alias ts='tmuxinator start'
