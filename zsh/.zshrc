# Keep the shell usable even before optional tools have been installed.
[[ -o interactive ]] || return

# Homebrew uses a different prefix on Apple Silicon and Intel Macs.
if [[ $OSTYPE == darwin* ]] && ! command -v brew &>/dev/null; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi
typeset -U path
path=("$HOME/.local/bin" $path)

# Shared history; a leading space keeps a command out of the history file.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1200000
SAVEHIST=1000000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt HIST_FIND_NO_DUPS HIST_VERIFY SHARE_HISTORY EXTENDED_HISTORY
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS NO_BEEP
unsetopt CORRECT

# Completion and ordinary readline-style editing.
autoload -Uz compinit
compinit -d "$HOME/.zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:descriptions' format '%F{blue}%d%f'
zstyle ':completion:*:git-checkout:*' sort false
bindkey -e

# Git and terminal tools always have an editor, including on SSH sessions.
export EDITOR=nano
export VISUAL="$EDITOR"
if [[ -z ${SSH_CONNECTION:-}${SSH_TTY:-} ]] && command -v code &>/dev/null; then
  export VISUAL='code --wait'
fi

# Use the terminal palette so both the light and dark themes stay readable.
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border=rounded --color=16'
if command -v fzf &>/dev/null; then
  # Older Ubuntu packages ship the integration as a separate file.
  if _fzf_init=$(fzf --zsh 2>/dev/null); then
    eval "$_fzf_init"
  elif [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    [[ -r /usr/share/doc/fzf/examples/completion.zsh ]] &&
      source /usr/share/doc/fzf/examples/completion.zsh
  fi
  unset _fzf_init
fi

# Existing Java installations remain optional.
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Machine-specific paths and editor overrides belong outside the shared config.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

PROMPT='%~ %# '
command -v starship &>/dev/null && eval "$(starship init zsh)"

# Load highlighting last, after other widgets have been registered.
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=1000
if command -v sheldon &>/dev/null; then
  eval "$(sheldon source)"
  (($+widgets[autosuggest - accept])) && bindkey '^ ' autosuggest-accept
fi
