if $IS_MACOS; then
    # Bootstrap do Homebrew: só roda o instalador remoto quando ENSURE_PACKAGES=true
    if [[ "$ENSURE_PACKAGES" == "true" && ! -x /opt/homebrew/bin/brew ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
    BREW_PREFIX=/opt/homebrew
else
    if [[ "$ENSURE_PACKAGES" == "true" && ! -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install.sh)"
    fi
    [ -x /home/linuxbrew/.linuxbrew/bin/brew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    BREW_PREFIX=/home/linuxbrew/.linuxbrew
fi
