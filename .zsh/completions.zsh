# ZSH Completions Configuration - Performance Optimized

# Fast cache setup
ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-$HOME/.zsh/cache}"
[[ ! -d "$ZSH_CACHE_DIR" ]] && mkdir -p "$ZSH_CACHE_DIR"

# Essential completion options only
setopt AUTO_LIST
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt HASH_LIST_ALL
setopt COMPLETE_ALIASES
setopt NO_BEEP

# Fast completion caching
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"

# Essential matching only
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+l:|=* r:|=*'

# Minimal styling for speed
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''

# Fast directory completion
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*' squeeze-slashes true

# Optimized process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm --no-headers"

# Minimal SSH completion
zstyle ':completion:*:(ssh|scp):*' tag-order 'hosts:-host hosts:-domain'
zstyle ':completion:*:(ssh|scp):*:hosts-host' ignored-patterns '*(.|:)*' loopback localhost

# Fast git completion
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git-*:*' group-order 'main commands'

# Essential fuzzy matching
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 1

# Optimized FZF Tab settings (lightweight previews)
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:*' fzf-min-height 10

# Fast directory preview
zstyle ':fzf-tab:complete:cd:*' fzf-preview '[[ -d $realpath ]] && ls -1 --color=always $realpath || echo "Not a directory"'

# Lightweight file preview
zstyle ':fzf-tab:complete:*:*' fzf-preview '[[ -f $realpath ]] && head -50 $realpath 2>/dev/null || [[ -d $realpath ]] && ls -1 --color=always $realpath || echo $realpath'

# Disable heavy previews
zstyle ':fzf-tab:complete:kill:*' fzf-preview
zstyle ':fzf-tab:complete:git-*:*' fzf-preview
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview

# Fast navigation
zstyle ':fzf-tab:*' switch-group ',' '.'

# Ignore common unneeded completions
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS' '(|*/).git'

# Prevent slow network lookups
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' accept-exact-dirs true

# Optimize history completion
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false

# Fast rehash for new commands
zstyle ':completion:*' rehash true
