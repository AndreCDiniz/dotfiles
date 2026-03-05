# My Dotfiles — @AndreCDiniz

Personal terminal setup built for a **zsh** shell environment, with configurations for **tmux** and **Neovim** focused on developer productivity.

---

## Stack

- **Shell:** zsh + zinit + starship
- **Editor:** Neovim (LazyVim)
- **Multiplexer:** tmux + sesh
- **Tools:** fzf, zoxide, bat, eza, delta, ripgrep, lazygit

---

## Getting Started

### Prerequisites

```bash
# Install Homebrew (Linux/macOS)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install core dependencies
brew install zsh neovim tmux stow starship fzf zoxide bat eza delta ripgrep lazygit sesh
```

### Install

```bash
git clone git@github.com:AndreCDiniz/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .
```

### Switch to zsh (if not default)

```bash
chsh -s $(which zsh)
```

Log out and back in to apply.

---

## Structure

```
dotfiles/
├── .zshrc              # zsh entry point
├── .zsh/               # aliases, functions, plugins, programs
├── .config/
│   ├── nvim/           # Neovim (LazyVim)
│   ├── tmux/           # tmux config
│   ├── starship.toml   # prompt theme
│   ├── lazygit/        # lazygit config
│   └── ...
└── .gitignore
```

---

## License

MIT
