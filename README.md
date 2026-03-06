# My Dotfiles — @AndreCDiniz

Personal terminal setup built for a **zsh** shell environment, with configurations for **tmux** and **Neovim** focused on developer productivity.

---

## Stack

| Layer | Tool | Description |
|-------|------|-------------|
| Shell | zsh | Default shell |
| Plugin Manager | [zinit](https://github.com/zdharma-continuum/zinit) | Fast zsh plugin manager — auto-installs on first shell start |
| Prompt | [starship](https://starship.rs/) | Cross-shell prompt — auto-installs on first shell start |
| Editor | [Neovim](https://neovim.io/) (LazyVim) | |
| Multiplexer | [tmux](https://github.com/tmux/tmux) + [sesh](https://github.com/joshmedeski/sesh) | Session management |
| AI | [Claude Code](https://github.com/anthropics/claude-code) | AI-powered terminal assistant |

**zsh plugins (managed by zinit):**

| Plugin | Purpose |
|--------|---------|
| zsh-completions | Extended tab-completion definitions |
| fzf-tab | Replace zsh completion with fzf |
| zsh-autosuggestions | Fish-style command suggestions |
| zsh-history-substring-search | Search history by typing any substring |
| zsh-syntax-highlighting | Syntax highlighting as you type |
| docker completions | Docker CLI completions |
| docker-compose completions | Docker Compose CLI completions |

**CLI tools:**

| Tool | Purpose |
|------|---------|
| fzf | Fuzzy finder |
| zoxide | Smart `cd` replacement |
| bat | `cat` with syntax highlighting |
| eza | Modern `ls` replacement |
| delta | Better `git diff` pager |
| ripgrep | Fast search (used by nvim) |
| lazygit | Terminal UI for git |
| lazydocker | Terminal UI for Docker |
| sesh | tmux session manager |
| yazi | Terminal file manager |
| btop | Resource monitor |
| glow | Markdown renderer |
| k9s | Kubernetes terminal UI |

---

## Getting Started

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installing, follow the instructions printed at the end to add Homebrew to your shell PATH.

---

### 2. Install Core Tools

```bash
brew install \
  zsh neovim tmux stow \
  fzf zoxide \
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

**On macOS:**

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

**On Linux/WSL:**

```bash
mkdir -p ~/.local/share/fonts

curl -fLo /tmp/JetBrainsMono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

unzip /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
fc-cache -fv
```

> After installing, set **JetBrainsMono Nerd Font** as the font in your terminal emulator (iTerm2, Alacritty, Kitty, etc).

---

### 4. Install Runtime Managers

**Volta** (Node.js version manager):

```bash
curl https://get.volta.sh | bash
```

Then install Node.js:

```bash
volta install node
```

**gobrew** (Go version manager):

```bash
curl -sLk https://git.io/gobrew | sh -
```

**pyenv** was installed via brew in step 2.

---

### 5. Clone and Apply Dotfiles

```bash
git clone git@github.com:AndreCDiniz/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .
```

> `stow .` creates symlinks from `~/dotfiles` into `~`, so every config file is tracked by git automatically.

If `stow` fails due to existing files (e.g., `~/.zshrc`), back them up first:

```bash
mv ~/.zshrc ~/.zshrc.bak
cd ~/dotfiles && stow .
```

---

### 6. Switch to zsh (if not default)

```bash
chsh -s $(which zsh)
```

Log out and back in to apply.

---

### 7. First Shell Session

Open a new terminal. On first run, the shell will automatically:

1. **Install zinit** — cloned to `~/.local/share/zinit/zinit.git`
2. **Install starship** — downloaded to `/usr/local/bin/starship`
3. **Install all zsh plugins** — fetched via zinit in the background

The prompt theme is **Catppuccin Mocha** with custom icons for distro, device type, git status, and Kubernetes context. No manual configuration needed.

> If starship shows a plain prompt on the first open, close and reopen the terminal — plugins finish loading asynchronously.

---

### 8. First Run — Neovim

Open Neovim once to auto-install all plugins:

```bash
nvim
```

LazyVim will bootstrap `lazy.nvim` and install all plugins automatically. This takes a few minutes on first run. Restart nvim after it finishes.

---

### 9. Install Claude Code

Claude Code is an AI-powered CLI that integrates directly into your terminal workflow.

```bash
npm install -g @anthropic-ai/claude-code
```

Authenticate on first run:

```bash
claude
```

> Requires Node.js. If installed via Volta (step 4): `volta install node`

---

## How It Works

### zinit — Plugin Manager

`zinit` is declared in `.zsh/zinit.zsh`. It auto-clones itself on first shell start if not present:

```zsh
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "$ZINIT_HOME/zinit.zsh"
```

Plugins are declared in `.zsh/plugins.zsh` with lazy loading (`wait lucid`) so they don't slow down shell startup.

### starship — Prompt

`starship` is declared in `.zsh/starship.zsh`. It auto-installs itself if not present:

```zsh
if [ ! -f /usr/local/bin/starship ]; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi
```

The prompt config lives at `.config/starship.toml` with the **Catppuccin Mocha** color palette. It shows: username, device type icon, distro icon, current directory, git branch/status, and Kubernetes context.

### .zshrc — Load Order

The shell config is split across modular files and loaded in order:

```
zinit.zsh        → plugin manager
helpers.zsh      → utility functions used by other files
functions.zsh    → custom shell functions
aliases.zsh      → command aliases
config.zsh       → shell options (history, etc.)
path.zsh         → PATH entries
completions.zsh  → completion setup
plugins.zsh      → zinit plugins
starship.zsh     → prompt
homebrew.zsh     → Homebrew PATH
wsl2fix.zsh      → WSL2-specific fixes (WSL only)
volta.zsh        → Volta (Node.js)
pyenv.zsh        → pyenv (Python)
libs.zsh         → misc libraries
programs/        → per-tool config (fzf, bat, eza, zoxide, etc.)
tmux.zsh         → auto-start tmux
```

---

## Structure

```
dotfiles/
├── .zshrc              # zsh entry point
├── .zshenv             # environment variables (loaded before .zshrc)
├── .gitconfig          # git global config
├── .zsh/
│   ├── zinit.zsh       # zinit bootstrap
│   ├── starship.zsh    # starship bootstrap + distro/device detection
│   ├── aliases.zsh
│   ├── functions.zsh
│   ├── plugins.zsh     # all zinit plugins
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

## Troubleshooting

### Neovim: `module 'lazy' not found`

This means `lazy.nvim` failed to bootstrap automatically (usually a network or git issue on first run). Fix it manually:

```bash
git clone --filter=blob:none \
  https://github.com/folke/lazy.nvim.git \
  --branch=stable \
  ~/.local/share/nvim/lazy/lazy.nvim
```

Then open nvim again — it will detect `lazy.nvim` and install all plugins.

### Prompt icons not rendering correctly

Make sure **JetBrainsMono Nerd Font** is set as the font in your terminal emulator, not just installed on the system. In iTerm2: Preferences → Profiles → Text → Font.

### stow: existing file conflicts

```bash
# Back up existing files and re-run stow
mv ~/.zshrc ~/.zshrc.bak && mv ~/.zshenv ~/.zshenv.bak
cd ~/dotfiles && stow .
```

### starship not installing on macOS (permission denied on `/usr/local/bin`)

```bash
# Install starship manually via brew instead
brew install starship
```

Then in `.zsh/starship.zsh`, the `if [ ! -f /usr/local/bin/starship ]` check will be skipped and starship will be found via PATH automatically.

---

## License

MIT
