# ── Performance: skip compinit check on insecure dirs ────────
ZSH_DISABLE_COMPFIX=true

# ── History ──────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt HIST_IGNORE_ALL_DUPS   # no duplicate entries
setopt HIST_IGNORE_SPACE      # ignore commands starting with space
setopt HIST_VERIFY            # show expanded history before executing
setopt SHARE_HISTORY          # share history across sessions
setopt EXTENDED_HISTORY       # save timestamp and duration

# ── Completion ───────────────────────────────────────────────
autoload -Uz compinit
compinit -d "$HOME/.zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:git-checkout:*' sort false

# ── Options ──────────────────────────────────────────────────
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt CORRECT
setopt NO_BEEP

# ── GNU coreutils (macOS only) ───────────────────────────────
if [[ "$(uname)" == "Darwin" ]]; then
  export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
  export PATH="$(brew --prefix)/opt/bash/bin:$PATH"
fi

# ── PATH ─────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# ── Editor ───────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"

# ── Language ─────────────────────────────────────────────────
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ── Sheldon ──────────────────────────────────────────────────
eval "$(sheldon source)"

# ── Plugin config (after sheldon) ────────────────────────────

# zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
bindkey '^ ' autosuggest-accept           # ctrl+space accepts suggestion

# zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=cyan,fg=black,bold'

# ── Modern CLI tools (loaded only if installed) ───────────────

# eza: modern ls
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias ll='eza -lh --icons --git'
  alias la='eza -lha --icons --git'
  alias lt='eza --tree --icons --level=2'
fi

# bat: modern cat
if command -v bat &>/dev/null; then
  alias cat='bat --style=plain'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# zoxide: smarter cd
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

# fzf: fuzzy finder
if command -v fzf &>/dev/null; then
  eval "$(fzf --zsh)"
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi

# ── Aliases ──────────────────────────────────────────────────
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias grep='grep --color=auto'
alias mkdir='mkdir -p'

alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

alias py='python3'
alias pip='pip3'

# ── Starship prompt ──────────────────────────────────────────
eval "$(starship init zsh)"
