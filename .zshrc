# --------- Exports ---------
export LANG=en_US.UTF-8
export TERM=xterm-256color
export "MICRO_TRUECOLOR=1"
export EDITOR='nvim'
export VISUAL='code'
export NVIM_TUI_ENABLE_TRUE_COLOR=1
export PNPM_HOME="$HOME/Library/pnpm"
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/go/bin:$HOME/.local/bin:$HOME/.config/yabai/:$HOME/Library/pnpm:$HOME/bin:/usr/local/bin:$PATH"
export DOTFILES="$HOME/Dotfiles"
export TMUX_PLUGIN_MANAGER_PATH="~/.tmux/plugins/"
export FZF_CTRL_R_OPTS="--reverse"
export FZF_TMUX_OPTS="-p"

# --------- ZSH Options ---------
ZSH_THEME="robbyrussell"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git node brew)
prompt_context(){}
source $ZSH/oh-my-zsh.sh
unsetopt correct_all
unalias l
unalias ll
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# --------- Functions ---------
# tm [SESSION_NAME | FUZZY PATTERN] - create new tmux session, or switch to existing one.
# Running `tm` will let you fuzzy-find a session mame
# Passing an argument to `ftm` will switch to that session if it exists or create it otherwise
ftm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}
# tmk [SESSION_NAME | FUZZY PATTERN] - delete tmux session
# Running `tmk` will let you fuzzy-find a session mame to delete
# Passing an argument to `ftmk` will delete that session if it exists
ftmk() {
  if [ $1 ]; then
    tmux kill-session -t "$1"; return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux kill-session -t "$session" || echo "No session found to delete."
}
brew() {
  command brew "$@" 

  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    sketchybar --trigger brew_upgrade
  fi
}
fdir() {
  local dir
  cd $HOME
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# --------- Aliases ---------
alias yr="yabai --restart-service && killall sketchybar"
alias l="eza -l -g --icons"
alias ll="eza -l -g --icons -a"
alias lg="eza -G --icons"
alias llg="eza -G --icons -a"
alias cat="bat"
alias m="micro"
alias gp="git pull"
alias gpo="git pull origin"
alias gf="git fetch"
alias gc="git checkout"
alias ga="git add"
alias gs="git status"
alias gst="git stash"
alias gstp="git stash pop"
alias gcm="git commit -m"
alias g="lazygit"
alias slsl="sls logs -f"
alias tm="ftm"
alias tmk="ftmk"
alias vim="nvim"
alias nv="neovide --multigrid --frame buttonless"
# alias vimm="NVIM_APPNAME=nvim-lazyvim nvim"
# alias sshadd="ssh-manager add --name test --private-key test --public-key test.pub --provider bw"
# alias sshget="ssh-manager get --name test --provider bw"
alias update_wez="brew upgrade --cask wezterm-nightly --no-quarantine --greedy-latest"
alias path='echo ${PATH//:/"\n"} | sort | uniq -u | fzf'


# --------- Misc ---------
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
