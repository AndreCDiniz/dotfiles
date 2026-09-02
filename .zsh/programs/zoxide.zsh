if [[ "$ENSURE_PACKAGES" == "true" && ! -x "$BREW_PREFIX/bin/zoxide" ]]; then
    echo "Installing zoxide..."
    "$BREW_PREFIX/bin/brew" install zoxide
fi
# zoxide init moved to end of ~/.zshrc (required by zoxide)
