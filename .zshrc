# if on devserver
[[ -f /usr/facebook/ops/rc/master.zshrc ]] && source /usr/facebook/ops/rc/master.zshrc

# Source system zprofile if it exists
[[ -f /etc/zprofile ]] && source /etc/zprofile

# Allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

# Enforce a safer 'sudo rm' for interactive sessions
if [[ -o interactive ]]; then
    sudo() {
        if [ "$1" = "rm" ]; then
            shift
            command sudo rm --preserve-root=all --one-file-system "$@"
        else
            command sudo "$@"
        fi
    }
fi

autoload -U compinit promptinit colors
compinit
promptinit
colors

# ==============================================================================
# Main settings
# ==============================================================================

#setopt MENU_COMPLETE
setopt LIST_AMBIGUOUS

# This makes cd=pushd
setopt AUTO_PUSHD

# revert pushd signs
setopt PUSHD_MINUS

# No more annoying pushd messages...
setopt PUSHD_SILENT

# this will ignore multiple directories for the stack
setopt PUSHD_IGNORE_DUPS

# use magic (this is default, but it can't hurt!)
setopt ZLE

# EOF doesn't quit the shell
#setopt IGNORE_EOF

# If I could disable Ctrl-s completely I would!
setopt NO_FLOW_CONTROL

# beeps are annoying
setopt NO_BEEP

# no overwriting files
#setopt NO_CLOBBER

# sort files numerically if possible
setopt NUMERIC_GLOB_SORT

# vim mode!!
bindkey -v
export KEYTIMEOUT=1

# fix alt+left and alt+right
bindkey "^[b" backward-word
bindkey "^[f" forward-word
bindkey '^[[Z' reverse-menu-complete
bindkey '^R' history-incremental-search-backward  # Ctrl+R in vim mode

# Consume tmux focus events so they don't get misinterpreted in vi mode
# (focus-events on + KEYTIMEOUT=1 causes \e[O to become Esc + O = "open line above")
function _tmux_focus_noop { }
zle -N _tmux_focus_noop
bindkey '\e[I' _tmux_focus_noop   # focus-in
bindkey '\e[O' _tmux_focus_noop   # focus-out

# ==============================================================================
# History
# ==============================================================================

HISTFILE=~/.zshhistory
HISTSIZE=1000000
SAVEHIST=1000000

# Share history between multiple shells
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE        # Commands starting with space won't be saved
setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# ==============================================================================
# Autocompletion
# ==============================================================================

# case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# highlight selected
zstyle ':completion:*' menu select

zstyle ':completion:*' group-name ''

# ==============================================================================
# Prompt
# ==============================================================================
COLOUR="%{$fg[cyan]%}"

function precmd {
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ $branch ]; then
    branch=$branch" "
  fi
  PROMPT=" ${COLOUR}λ%{$reset_color%} %{$fg[yellow]%}%~%{$reset_color%} %{$fg[cyan]%}$branch%{$reset_color%}"
}
precmd

function zle-line-init zle-keymap-select {
  case ${KEYMAP} in
    (vicmd)      COLOUR="%{$fg[white]%}" ;;
    (*)          COLOUR="%{$fg[cyan]%}" ;;
  esac
  precmd
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# ==============================================================================
# Source plugins
# ==============================================================================
[[ -f ~/.zsh/zsh-colored-man/zsh-colored-man.zsh ]] && source ~/.zsh/zsh-colored-man/zsh-colored-man.zsh
[[ -f ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh ]] && source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
[[ -f ~/.zsh/zsh-dircycle/zsh-dircycle.zsh ]] && source ~/.zsh/zsh-dircycle/zsh-dircycle.zsh
[[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# ==============================================================================
# History substring search plugin
# ==============================================================================
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=bg=none
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=bg=none

export EDITOR='nvim'

# Use neovim as the default editor
alias vi='nvim'
alias vim='nvim'

alias rmf='rm -rf'
alias pp='python3'
alias hn='hostname'

# Platform-specific ls aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias la='ls -AlhFG'
    alias ls='ls -hG'
else
    alias la='ls -AlhFG --color=tty'
    alias ls='ls -hG --color=tty'
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[ -f ~/.vim/bundle/.fzf.zsh ] && source ~/.vim/bundle/.fzf.zsh

# >>> conda initialize >>>
# Cross-platform conda initialization
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: typical Homebrew or Miniconda paths
    CONDA_PATHS=(
        "$HOME/miniconda3/bin/conda"
    )
else
    # Linux
    CONDA_PATHS=(
        "/usr/bin/conda"
        "$HOME/miniconda3/bin/conda"
    )
fi

for conda_bin in "${CONDA_PATHS[@]}"; do
    if [[ -x "$conda_bin" ]]; then
        __conda_setup="$("$conda_bin" 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            conda_dir="$(dirname "$(dirname "$conda_bin")")"
            if [ -f "$conda_dir/etc/profile.d/conda.sh" ]; then
                . "$conda_dir/etc/profile.d/conda.sh"
            else
                export PATH="$conda_dir/bin:$PATH"
            fi
        fi
        unset __conda_setup
        break
    fi
done
unset CONDA_PATHS conda_bin conda_dir
# <<< conda initialize <<<

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source local machine-specific config if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
export AIRSTORE_LOG_LEVEL=WARNING
export AIRSTORE_LOGLEVEL_PY=WARNING
export AIRSTORE_LOGLEVEL_CPP=WARNING
export NCCL_DEBUG=ERROR
alias with-proxy='HTTPS_PROXY=http://fwdproxy:8080 HTTP_PROXY=http://fwdproxy:8080 FTP_PROXY=http://fwdproxy:8080 https_proxy=http://fwdproxy:8080 http_proxy=http://fwdproxy:8080 ftp_proxy=http://fwdproxy:8080 http_no_proxy="*.facebook.com|*.tfbnw.net|*.fb.com"'
