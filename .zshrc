export XDG_CONFIG_HOME="$HOME/.config"
ENSURE_PACKAGES=false

# Corrige fpath herdado/obsoleto: o brew faz 'export FPATH' e o tmux congelava
# um caminho de funcoes do zsh removido num upgrade (Cellar/zsh/5.9 -> 5.9.2).
fpath=(
  /home/linuxbrew/.linuxbrew/share/zsh/site-functions
  /home/linuxbrew/.linuxbrew/share/zsh/functions
  /usr/share/zsh/vendor-completions
  ${fpath:#*/Cellar/zsh/*}   # descarta entradas mortas de versoes antigas do brew
)
typeset -U fpath             # remove duplicados

# Load Package Manager (zinit)
[[ -f "$HOME/.zsh/zinit.zsh" ]] && source "$HOME/.zsh/zinit.zsh"

# Load Helpers
[[ -f "$HOME/.zsh/helpers.zsh" ]] && source "$HOME/.zsh/helpers.zsh"

# Load Functions, Aliases, and Config
[[ -f "$HOME/.zsh/functions.zsh" ]] && source "$HOME/.zsh/functions.zsh"
[[ -f "$HOME/.zsh/aliases.zsh" ]] && source "$HOME/.zsh/aliases.zsh"
[[ -f "$HOME/.zsh/config.zsh" ]] && source "$HOME/.zsh/config.zsh"
[[ -f "$HOME/.zsh/path.zsh" ]] && source "$HOME/.zsh/path.zsh"
[[ -f "$HOME/.zsh/completions.zsh" ]] && source "$HOME/.zsh/completions.zsh"

# Load Plugins and Themes
[[ -f "$HOME/.zsh/plugins.zsh" ]] && source "$HOME/.zsh/plugins.zsh"
[[ -f "$HOME/.zsh/starship.zsh" ]] && source "$HOME/.zsh/starship.zsh"

# Load Homebrew and fix WSL2 interop
[[ -f "$HOME/.zsh/homebrew.zsh" ]] && source "$HOME/.zsh/homebrew.zsh"
$IS_WSL && [[ -f "$HOME/.zsh/wsl2fix.zsh" ]] && source "$HOME/.zsh/wsl2fix.zsh"

# Load Environment Handlers and Libraries
# Node: gerenciado pelo nvm (carga lazy no fim do arquivo).
# Volta desativado para nao ter dois gerenciadores de Node no PATH.
# [[ -f "$HOME/.zsh/volta.zsh" ]] && source "$HOME/.zsh/volta.zsh"
[[ -f "$HOME/.zsh/pyenv.zsh" ]] && source "$HOME/.zsh/pyenv.zsh"
[[ -f "$HOME/.zsh/libs.zsh" ]] && source "$HOME/.zsh/libs.zsh"

# Load Artificial Intelligence
[[ -f "$HOME/.zsh/ollama.zsh" ]] && source "$HOME/.zsh/ollama.zsh"
[[ -f "$HOME/.zsh/ai.zsh" ]] && source "$HOME/.zsh/ai.zsh"

# Load All work private files  (via _safe_source: só carrega se for seu e nao gravavel por terceiros)
if [ -d "$HOME/.zsh/work" ]; then
  for file in "$HOME/.zsh/work/"*(N); do
    _safe_source "$file"
  done
fi

# Load All Programs from /programs
if [ -d "$HOME/.zsh/programs" ]; then
  for file in "$HOME/.zsh/programs/"*(N); do
    _safe_source "$file"
  done
fi

# Start tmux if not already running
if [ -z "$SSH_CONNECTION" ] && [ -f "$HOME/.zsh/tmux.zsh" ]; then
  source "$HOME/.zsh/tmux.zsh"
fi

# -- System Added...

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Golang PATH
export PATH="$HOME/.gobrew/current/bin:$HOME/.gobrew/bin:$PATH"

PATH=~/.console-ninja/.bin:$PATH

export NVM_DIR="$HOME/.nvm"
# nvm em modo lazy: so carrega no primeiro uso, deixando o shell abrir mais rapido.
_load_nvm() {
  unset -f nvm node npm npx pnpm yarn corepack 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                    # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # nvm bash_completion
}
for _cmd in nvm node npm npx pnpm yarn corepack; do
  eval "${_cmd}() { _load_nvm; ${_cmd} \"\$@\"; }"
done
unset _cmd

# Function to open files/dirs in Windows Explorer (WSL only)
open() {
    if [ $# -eq 0 ]; then
        explorer.exe .
    else
        if [ -d "$1" ]; then
            explorer.exe "$1"
        else
            local winpath=$(wslpath -w "$1")
            cmd.exe /c start "" "$winpath" 2>/dev/null
        fi
    fi
}

# Zoxide init (must be at the very end of .zshrc)
eval "$(zoxide init --cmd cd zsh)"
export PATH="$HOME/.local/bin:$PATH"

# Nao exporta o fpath: impede o tmux/subprocessos de "congelar" um valor
# obsoleto (era a causa dos erros 'function definition file not found' no reload).
typeset +x FPATH

# ssh-agent persistente entre shells/paineis do tmux. Com 'AddKeysToAgent yes'
# no ~/.ssh/config, a passphrase da chave e pedida uma vez por boot e fica em cache.
if command -v ssh-agent >/dev/null 2>&1; then
  SSH_ENV="$HOME/.ssh/agent-env"
  _agent_alive() { ssh-add -l >/dev/null 2>&1 || [ $? -eq 1 ]; }
  _agent_alive || { [ -f "$SSH_ENV" ] && . "$SSH_ENV" >/dev/null 2>&1; }
  _agent_alive || {
    (umask 077; ssh-agent -s >"$SSH_ENV" 2>/dev/null)
    . "$SSH_ENV" >/dev/null 2>&1
  }
  unset -f _agent_alive
fi
