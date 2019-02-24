# Setup fzf
# ---------
if [[ ! "$PATH" == */private/home/ailzhang/.vim/bundle/.fzf/bin* ]]; then
  export PATH="$PATH:/private/home/ailzhang/.vim/bundle/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/private/home/ailzhang/.vim/bundle/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/private/home/ailzhang/.vim/bundle/.fzf/shell/key-bindings.zsh"

