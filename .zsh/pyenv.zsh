# Instala o pyenv só em bootstrap (ENSURE_PACKAGES=true)
if [[ "$ENSURE_PACKAGES" == "true" && ! -x "$BREW_PREFIX/bin/pyenv" ]]; then
    echo "Installing pyenv..."
    "$BREW_PREFIX/bin/brew" install pyenv
fi

command -v pyenv >/dev/null || return 0
export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init -)"
eval "$(pyenv init --path)"
