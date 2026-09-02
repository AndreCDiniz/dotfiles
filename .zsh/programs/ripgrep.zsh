# Instala só em bootstrap (ENSURE_PACKAGES=true); ensure_package já respeita essa flag
if [[ "$ENSURE_PACKAGES" == "true" && ! -x "$BREW_PREFIX/bin/rg" ]]; then
    echo "Installing ripgrep..."
    "$BREW_PREFIX/bin/brew" install ripgrep
fi

ensure_package ripgrep -b rg -s
