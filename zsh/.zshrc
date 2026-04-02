# ~/.zshrc

# 1. Autocomplete (Always at the beginning)
autoload -Uz compinit && compinit

# 2. PATH - Intelligent management
# Adds directories only if they physically exist on the disk
typeset -U path # Prevents duplicates in PATH
path=(
  $HOME/.local/bin
  /opt/nvim-linux-x86_64/bin(N) # (N) Null Glob: ignores path if it doesn't exist
  $path
)
export PATH

# 3. Colors and Aliases (OS Specific)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    export CLICOLOR=1
    export LSCOLORS=Gxfxcxdxbxegedabagacad
    alias ls='ls -G'
else
    # Linux
    export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
    alias ls='ls --color=auto'
fi
alias ll='ls -lh'
alias la='ls -A'

# 4. FZF Shell Integration
for fzf_path (
    "/usr/share/fzf/shell"
    "/opt/homebrew/opt/fzf/shell"
    "/usr/local/opt/fzf/shell"
); do
    if [[ -d "$fzf_path" ]]; then
        source "$fzf_path/key-bindings.zsh"
        [[ -f "$fzf_path/completion.zsh" ]] && source "$fzf_path/completion.zsh"
        break
    fi
done

# 5. History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# 6. Keybindings
bindkey '^e' fzf-history-widget  # [E]xplore history
bindkey '^f' fzf-file-widget     # [F]ind file
bindkey '^g' fzf-cd-widget       # [G]o to directory

# History substring search (Arrow key bindings)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# 7. Antidote (Plugins)
source ~/.zsh/antidote/antidote.zsh
antidote load ~/.zsh/plugins.txt

# 8. SDKMAN (Should be at the end as it modifies PATH)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

