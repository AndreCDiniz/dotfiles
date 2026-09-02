# ZSH Plugins Configuration - Performance Optimized
# =================================================
# Arquivo: ~/.zsh/plugins.zsh

# Lazy loading helper function
lazy_load() {
    local plugin_name="$1"
    local load_trigger="$2"
    local plugin_cmd="$3"
    
    eval "
    $load_trigger() {
        unset -f $load_trigger
        $plugin_cmd
        $load_trigger \$@
    }
    "
}

# Essential completions first (lightweight)
zinit ice wait lucid atload"zicompinit; zicdreplay"
zinit light zsh-users/zsh-completions

# FZF Tab (lazy loaded)
zinit ice wait"1" lucid
zinit light Aloxaf/fzf-tab

# Auto suggestions (lazy loaded)
zinit ice wait"1" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# History substring search (lightweight)
zinit ice wait"1" lucid
zinit light zsh-users/zsh-history-substring-search

# Development completions (lazy loaded only when needed)
zinit ice wait"2" lucid as"completion"
zinit snippet https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker

zinit ice wait"2" lucid as"completion"
zinit snippet https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose

# Syntax highlighting (always last, lazy loaded)
zinit ice wait"2" lucid atinit"zpcompinit; zpcdreplay"
zinit light zsh-users/zsh-syntax-highlighting

# Optimized completion initialization
if [[ -z "$ZSH_CACHE_DIR" ]]; then
    ZSH_CACHE_DIR="$HOME/.zsh/cache"
fi

# Fast compinit with cache check
autoload -Uz compinit
if [[ $ZSH_CACHE_DIR/zcompdump-$ZSH_VERSION(#qNmh+24) ]]; then
    compinit -C -d $ZSH_CACHE_DIR/zcompdump-$ZSH_VERSION
else
    compinit -d $ZSH_CACHE_DIR/zcompdump-$ZSH_VERSION
fi

# Minimal auto suggestion configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#555555"
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_MANUAL_REBIND=true

# Optimized history substring search
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=green,fg=white,bold"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="bg=red,fg=white,bold"
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS="i"

# Key bindings for history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Minimal syntax highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green
ZSH_HIGHLIGHT_STYLES[path]=underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
