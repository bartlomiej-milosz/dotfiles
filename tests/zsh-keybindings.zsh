# Run by scripts/check.sh in an interactive Zsh with an empty temporary HOME.
# PATH contains only mv for compinit; these stubs never download or source real plugins.
brew() { return 0; }
case $2 in
  widget)
    sheldon() {
      print -r -- 'autosuggest-accept() { :; }; zle -N autosuggest-accept'
    }
    expected='"^@" autosuggest-accept'
    ;;
  no-widget)
    sheldon() { return 0; }
    expected='"^@" set-mark-command'
    ;;
  no-sheldon)
    expected='"^@" set-mark-command'
    ;;
  *) print -u2 -- 'Unknown test case'; exit 1 ;;
esac

bindkey -e
bindkey '^ ' set-mark-command
source "$1" || { print -u2 -- "Failed to source .zshrc ($2)"; exit 1; }

[[ $(bindkey -M emacs '^ ') == "$expected" ]] || {
  print -u2 -- "Unexpected Ctrl+Space binding: $(bindkey -M emacs '^ ')"
  exit 1
}
[[ $(bindkey -M emacs '^F') == '"^F" forward-char' ]] || exit 1
[[ $PROMPT == '%~ %# ' && $EDITOR == nano && $VISUAL == nano ]] || exit 1
print -r -- "PASS: Zsh Ctrl+Space ($2) and basic shell fallback"
