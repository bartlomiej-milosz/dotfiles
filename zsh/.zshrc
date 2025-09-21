# ~/.zshrc

# Load Antidote
source ~/.zsh/antidote/antidote.zsh
antidote load ~/.zsh/plugins.txt

# FZF shell integration
eval "$(fzf --zsh)"

# Colors for ls
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    export CLICOLOR=1
    export LSCOLORS=Gxfxcxdxbxegedabagacad
else
    # Linux
    export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
    alias ls='ls --color=auto'
fi

# Basic history settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# Keybindings
bindkey '^e' fzf-history-widget    # [E]xplore history
bindkey '^f' fzf-file-widget       # [F]ind file
bindkey '^g' fzf-cd-widget         # [G]o to directory

# Completions `tab`
autoload -Uz compinit && compinit
