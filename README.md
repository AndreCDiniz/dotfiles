# Dotfiles — @AndreCDiniz

Personal terminal environment for development on **Linux / WSL2**. A modular **zsh**
setup with **tmux**, **Neovim (LazyVim)**, and a curated set of modern CLI tools —
all themed **Catppuccin Mocha**.

---

## Stack

| Layer | Tool | Notes |
|-------|------|-------|
| Shell | zsh | Default shell |
| Plugin manager | [zinit](https://github.com/zdharma-continuum/zinit) | Lazy-loaded plugins |
| Prompt | [starship](https://starship.rs/) | Config in `.config/starship.toml` |
| Editor | [Neovim](https://neovim.io/) + [LazyVim](https://www.lazyvim.org/) | Config in `.config/nvim/` |
| Multiplexer | [tmux](https://github.com/tmux/tmux) + [sesh](https://github.com/joshmedeski/sesh) | `tpm` for plugins |
| Node | [nvm](https://github.com/nvm-sh/nvm) | Lazy-loaded; Volta config is present but disabled |
| Python | [pyenv](https://github.com/pyenv/pyenv) | |
| Go | [gobrew](https://github.com/kevincobain2000/gobrew) | |
| AI (CLI) | [Claude Code](https://github.com/anthropics/claude-code), [`llm`](https://llm.datasette.io/) | |
| AI (editor) | [avante.nvim](https://github.com/yetone/avante.nvim) + GitHub Copilot | |
| Dotfile manager | [GNU Stow](https://www.gnu.org/software/stow/) | Symlinks `~/dotfiles` → `~` |

### zsh plugins (via zinit)

| Plugin | Purpose |
|--------|---------|
| `zsh-completions` | Extra completion definitions |
| `fzf-tab` | Replaces the completion menu with an fzf picker (with previews) |
| `zsh-autosuggestions` | Fish-style suggestion from history |
| `zsh-history-substring-search` | `↑`/`↓` search history by any substring typed |
| `zsh-syntax-highlighting` | Highlights the command line as you type |
| docker / docker-compose | CLI completions |

### CLI tools

| Tool | Purpose |
|------|---------|
| `fzf` | Fuzzy finder (drives `fzf-tab`, `Ctrl-R`, `sesh`) |
| `zoxide` | Smarter `cd` — aliased to `cd` |
| `eza` | Modern `ls` — many aliases (`l`, `ll`, `la`, `lt`, …) |
| `bat` | `cat` with syntax highlighting — alias `b` |
| `ripgrep` | Fast recursive search (`rg`); used by Neovim and `sg` |
| `git-delta` | `git diff` / pager with side-by-side, syntax highlighting |
| `lazygit` | Git TUI — alias `gg` |
| `lazydocker` | Docker TUI — alias `ld` |
| `k9s` | Kubernetes TUI |
| `sesh` | tmux session manager (project-aware, zoxide-backed) |
| `yazi` | File manager TUI |
| `btop` | Resource monitor |
| `glow` | Markdown renderer (used by `ai explain`) |
| `stow` | Applies this repo as symlinks |
| `llm` | LLM CLI (wrapped by the `ai` function) |

---

## Install

### 1. Core packages (Homebrew)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install \
  zsh neovim tmux stow \
  fzf zoxide bat eza git-delta ripgrep \
  lazygit lazydocker sesh yazi btop glow k9s \
  pyenv llm \
  go gopls delve
```

### 2. Nerd Font

Icons in Neovim, tmux and starship require a [Nerd Font](https://www.nerdfonts.com/)
(this setup expects **JetBrainsMono Nerd Font**):

```bash
# Linux / WSL
mkdir -p ~/.local/share/fonts
curl -fLo /tmp/JetBrainsMono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
fc-cache -fv

# macOS
brew install --cask font-jetbrains-mono-nerd-font
```

Then set it as the font in your terminal emulator.

### 3. Runtime version managers

```bash
# nvm (Node) — active manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# reopen the shell, then:
nvm install --lts

# gobrew (Go)
curl -sLk https://raw.githubusercontent.com/kevincobain2000/gobrew/master/git.io.sh | sh

# pyenv was installed via brew in step 1
```

> Volta is also wired up (`.zsh/volta.zsh`) but its `source` line in `.zshrc` is
> commented out so Node is managed by a single tool. Swap the comment if you
> prefer Volta.

### 4. Clone and apply

```bash
git clone git@github.com:AndreCDiniz/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .            # symlinks every tracked file into ~
```

If `stow` reports conflicts with existing files:

```bash
mv ~/.zshrc ~/.zshrc.bak ; mv ~/.zshenv ~/.zshenv.bak
cd ~/dotfiles && stow .
```

### 5. First run

```bash
chsh -s "$(which zsh)"   # make zsh the login shell, then log out/in
```

Open a new terminal:

- **zinit** clones itself to `~/.local/share/zinit/` and fetches all zsh plugins
  in the background.
- **starship** must already be on `PATH` (installed via brew or `/usr/local/bin`).
- Run `nvim` once — LazyVim bootstraps `lazy.nvim` and installs every plugin
  (a few minutes). Restart Neovim when it finishes.

### 6. Claude Code (optional)

```bash
npm install -g @anthropic-ai/claude-code
claude   # authenticate on first run
```

---

## Bootstrapping a fresh machine — `ENSURE_PACKAGES`

By design, opening a shell **never** installs software or runs a remote script.
Every auto-installer (`curl | sh` for Homebrew/starship, `brew install` for
`pyenv`, `tmux`, `ripgrep`, `zoxide`, and the `ensure_package` calls under
`.zsh/programs/`) is gated behind one flag, which defaults to `false`:

```zsh
# .zshrc
ENSURE_PACKAGES=false
```

To let the config self-provision a new machine, set it to `true` for the first
run, then set it back:

```zsh
ENSURE_PACKAGES=true zsh -i -c exit   # one-shot bootstrap
```

---

## How it works

### `.zshrc` load order

`~/.zshenv` runs first (env vars: `NVM_DIR`, `EDITOR=nvim`, WSL/Vagrant bits).
Then `~/.zshrc` fixes `fpath`, loads zinit, and sources these modules from
`~/.zsh/` in order:

| File | Role |
|------|------|
| `zinit.zsh` | Bootstrap the plugin manager |
| `helpers.zsh` | `IS_WSL` / `IS_LINUX` / `IS_MACOS`, `_safe_source` |
| `functions.zsh` | Shell functions (`sg`, `ai`, `fix`, `install`, …) |
| `aliases.zsh` | Command aliases |
| `config.zsh` | History + keybindings (Emacs mode) |
| `path.zsh` | Go `PATH` / `GOPATH` |
| `completions.zsh` | Completion styling + `fzf-tab` previews |
| `plugins.zsh` | zinit plugin declarations + `compinit` |
| `starship.zsh` | Prompt init + distro/device icon detection |
| `homebrew.zsh` | `brew shellenv`, sets `BREW_PREFIX` |
| `wsl2fix.zsh` | WSL2 interop fix + Windows app `PATH` entries (WSL only) |
| `pyenv.zsh` | pyenv init |
| `libs.zsh` | misc (`h2` Shopify Hydrogen alias) |
| `ollama.zsh` | `ol` helper (does **not** auto-start unless ollama is installed) |
| `ai.zsh` | `ai` function over the `llm` CLI |
| `programs/*` | per-tool config, each loaded via `_safe_source` |
| `work/*` | machine-local private files (git-ignored), via `_safe_source` |
| `tmux.zsh` | Auto-attach/create a tmux session on login |

The tail of `.zshrc` also adds gobrew/console-ninja to `PATH`, loads **nvm
lazily** (a stub for `nvm`/`node`/`npm`/`npx`/`pnpm`/`yarn`/`corepack` loads it on
first use), initialises **zoxide as `cd`**, and starts a **persistent
ssh-agent** shared across shells/tmux panes.

### `_safe_source`

The `~/.zsh/programs/` and `~/.zsh/work/` folders are read in bulk on every
login. `_safe_source` (in `helpers.zsh`) only executes a file if **you own both
the file and its directory** and the directory is not world-writable — otherwise
it skips it and prints a warning. Treat those folders as code.

### SSH

`~/.ssh/config` sets `AddKeysToAgent yes` + `IdentitiesOnly yes`; the agent is
started once per boot and reused. Key passphrases are cached in the agent after
the first use.

---

## Key bindings

### Shell aliases

| Alias | Command |
|-------|---------|
| `dev` / `dot` | `cd ~/software-development` / `cd ~/dotfiles` |
| `reload` | `source ~/.zshrc` |
| `c` / `ci` / `cu` | VS Code / Insiders / Cursor |
| `b` | `bat` |
| `gg` / `ld` | `lazygit` / `lazydocker` |
| `l` `ll` `la` `lt` `lt2` … | `eza` variants (suffix `ni` = no icons) |
| `copy` | pipe stdin to the Windows clipboard (`clip.exe`) |
| `delete` | `rm -rfI` (prompts once for recursive / many files) |
| `h2` | project-local Shopify Hydrogen CLI |

### Shell functions

| Function | Purpose |
|----------|---------|
| `sg <term>` | ripgrep → fzf → `bat` preview; `Enter` opens the file in Neovim at the line |
| `search <term> <dir>` | plain recursive grep piped into fzf |
| `ai chat` / `ai explain <file>` | LLM chat (model picker) / explain a file |
| `ol start\|restart\|view` | manage a local ollama server |
| `fix history` | back up and repair a corrupt `~/.zsh_history` |
| `install` / `uninstall <pkg>` | install/remove detecting brew/apt/pacman/dnf |
| `open [path]` | open in the Windows Explorer / default app (WSL) |

### tmux — prefix is `Ctrl-a`

Notation: `prefix` = press `Ctrl-a`, release, then the key. Mouse is on.
`prefix Space` opens a which-key menu of every binding; `prefix ?` lists them raw.

| Keys | Action |
|------|--------|
| `prefix c` | new window (tab) |
| `Alt-Shift-L` / `Alt-Shift-H` | next / previous window (no prefix) |
| `prefix 1`…`9` | jump to window N |
| `prefix ,` / `prefix .` | rename window / rename session to `$PWD` basename |
| `prefix \` / `prefix -` | split right / split down (keeps cwd) |
| `prefix h/j/k/l` | move between panes (vim-style) |
| `prefix z` | zoom pane · `prefix x` close pane |
| `prefix s` | session manager (sessionx, fzf + zoxide) |
| `prefix f` | pick a directory → open as session (`tmux-sessionizer`) |
| `prefix p` | floating scratch terminal (floax) — same key hides it |
| `prefix d` | detach · `tmux a` to re-attach |
| `prefix [` | scroll/copy mode (`v` select, `y` copy to Windows clipboard, `q` exit) |
| `prefix u` | pick a URL visible on screen and open it |
| `prefix r` | reload `tmux.conf` · `prefix I` / `prefix U` install / update plugins |

`Ctrl-h/j/k/l` also move seamlessly between Neovim splits **and** tmux panes
(`vim-tmux-navigator` + `tmux.nvim`).

### Neovim — leader is `Space`

Custom keymaps (`lua/config/keymaps.lua`):

| Keys | Action |
|------|--------|
| `<leader>za` | select entire buffer |
| `gh` | LSP hover (`K`) |
| `n` / `N` | next / previous search result, re-centered |
| `<F2>` | find & replace the word under the cursor |
| `<M-d>` | duplicate the current line |
| `<leader>ou` | open the URL under the cursor in the browser |

Grapple (file marks, `git` scope):

| Keys | Action |
|------|--------|
| `<leader>ma` | toggle a mark for the current file |
| `<leader>mm` | open the marks window |
| `<leader>mr` | reset marks |
| `<leader>[` / `<leader>]` | cycle to next / previous mark |
| `<leader>1`…`5` | jump to mark N (shown top-right by `incline`) |

LazyVim essentials (see `:help LazyVim` and `<leader>` in which-key):

| Keys | Action |
|------|--------|
| `<leader><space>` / `<leader>ff` | find files (fzf-lua) |
| `<leader>/` / `<leader>sg` | grep the project |
| `<leader>,` | switch buffer |
| `<leader>e` | file tree (neo-tree) · `<leader>fm` mini.files |
| `<leader>gg` | lazygit · `<leader>gG` lazygit (cwd) |
| `gd` `gr` `gI` `gy` | LSP definition / references / implementation / type |
| `<leader>ca` `<leader>cr` `<leader>cf` | code action / rename / format |
| `<leader>cd` · `]d` `[d` | line diagnostics · next/prev diagnostic |
| `<leader>xd` / `<leader>xD` | better-ts-errors: toggle / go to definition |
| `]]` `[[` | next / previous reference (illuminate) |
| `gcc` / `gc` | comment line / motion (mini.comment) |
| `gsa` `gsd` `gsr` | add / delete / replace surround (mini.surround) |
| `H` `J` `K` `L` (visual) | move the selection (mini.move) |
| `<C-n>` · `\\A` | multi-cursor: select word / all matches (vim-visual-multi) |
| `<leader>aa` `<leader>at` | avante: ask / toggle · `<Tab>` accepts a suggestion |
| `<leader>l` / `<leader>cm` | Lazy / Mason |

---

## Structure

```
dotfiles/
├── .zshrc / .zshenv        # entry points
├── .gitconfig
├── .zsh/
│   ├── zinit.zsh  helpers.zsh  functions.zsh  aliases.zsh  config.zsh
│   ├── path.zsh   completions.zsh  plugins.zsh  starship.zsh
│   ├── homebrew.zsh  wsl2fix.zsh  pyenv.zsh  volta.zsh  nvm.zsh (disabled)
│   ├── ollama.zsh  ai.zsh  libs.zsh  tmux.zsh
│   └── programs/           # per-tool config (bat, eza, fzf, lazygit, …)
├── .scripts/
│   └── tmux-sessionizer    # bound to `prefix f`
└── .config/
    ├── nvim/               # LazyVim: lua/config/* and lua/plugins/*
    ├── tmux/               # tmux.conf, tmux_sesh.conf, catppuccin bar
    ├── starship.toml
    ├── alacritty/  lazygit/  lazydocker/  yazi/  bat/  btop/  k9s/
    └── ...
```

`.config/nvim/lazy-lock.json` is git-ignored — plugin versions float to the
latest commit; run `:Lazy sync` to update.

---

## Troubleshooting

**Neovim: `module 'lazy' not found`** — bootstrap failed (network/git). Fix:

```bash
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git \
  --branch=stable ~/.local/share/nvim/lazy/lazy.nvim
```

**Prompt/icons render as boxes** — the terminal emulator's font must be set to
**JetBrainsMono Nerd Font**, not just installed.

**`compinit` warns about `_docker`** — a symlink Docker Desktop creates under
`/mnt/wsl/...`; harmless, resolves when Docker Desktop is running.

**`stow` conflicts** — back up the offending file (`mv ~/.zshrc ~/.zshrc.bak`)
and re-run `stow .`.

---

## License

MIT
