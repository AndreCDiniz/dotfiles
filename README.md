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

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installing, add Homebrew to your shell (follow the instructions printed at the end of the install script).

---

### 2. Install Core Tools

```bash
brew install \
  zsh neovim tmux stow \
  starship fzf zoxide \
  bat eza delta ripgrep \
  lazygit sesh \
  yazi btop glow neofetch \
  lazydocker k9s \
  pyenv \
  go gopls dlv
```

---

### 3. Install Nerd Font

Icons in Neovim, tmux, and the starship prompt require a [Nerd Font](https://www.nerdfonts.com/). This setup uses **JetBrainsMono Nerd Font**.

**On Linux/WSL:**

```bash
# Create fonts directory
mkdir -p ~/.local/share/fonts

# Download JetBrainsMono Nerd Font
curl -fLo /tmp/JetBrainsMono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

# Extract and install
unzip /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
fc-cache -fv
```

**On macOS:**

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

> After installing, set **JetBrainsMono Nerd Font** as the font in your terminal emulator.

---

### 4. Install Runtime Managers

These are loaded by the shell config and must be installed separately.

**Volta** (Node.js version manager):

```bash
curl https://get.volta.sh | bash
```

**NVM** (alternative Node.js manager — optional, see `.zshrc`):

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
```

**gobrew** (Go version manager):

```bash
curl -sLk https://git.io/gobrew | sh -
```

**pyenv** is installed via brew in step 2.

---

### 5. Clone and Apply Dotfiles

```bash
git clone git@github.com:AndreCDiniz/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .
```

---

### 6. Switch to zsh (if not default)

```bash
chsh -s $(which zsh)
```

Log out and back in to apply.

---

### 7. First Run

**Neovim** — open it once to auto-install all plugins:

```bash
nvim
```

Wait for LazyVim to finish installing, then restart nvim.

**zinit plugins** — they are installed automatically on the first shell session start.

---

## Structure

```
dotfiles/
├── .zshrc              # zsh entry point
├── .zshenv             # environment variables (loaded before .zshrc)
├── .gitconfig          # git global config
├── .zsh/
│   ├── aliases.zsh
│   ├── functions.zsh
│   ├── plugins.zsh     # zinit plugins
│   ├── starship.zsh
│   ├── programs/       # per-tool config (fzf, bat, eza, zoxide...)
│   ├── volta.zsh
│   ├── pyenv.zsh
│   ├── tmux.zsh
│   └── wsl2fix.zsh     # WSL2-specific fixes
└── .config/
    ├── nvim/           # Neovim (LazyVim)
    ├── tmux/           # tmux + sesh
    ├── starship.toml   # prompt theme (Catppuccin Mocha)
    ├── alacritty/      # terminal emulator
    ├── lazygit/
    ├── lazydocker/
    ├── yazi/
    ├── bat/
    ├── btop/
    ├── k9s/
    └── ...
```

---

## License

MIT
