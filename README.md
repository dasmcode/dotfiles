# Personal dotfiles

My Fedora workstation configuration, managed with [GNU Stow](https://www.gnu.org/software/stow/). The repository currently contains configuration for the shell, terminal, editor, multiplexer, file manager, session manager, Git, and Herdr (the terminal workspace used to launch Pi).

> **Platform note:** These instructions target Fedora. The configuration may work elsewhere, but package names and installation commands will need to be adapted.

## What is included

| Stow package | Installs | Notes |
| --- | --- | --- |
| `zshell` | `~/.zshrc` | Zinit plugins, Oh My Posh, fzf, zoxide, Yazi integration, aliases |
| `nvimconfig` | `~/.config/nvim` | Neovim configuration and Lazy.nvim lockfile |
| `tmux` | `~/.config/tmux` | Backtick prefix, TPM plugins, sesh picker, Catppuccin status line |
| `ghostty` | `~/.config/ghostty` | Ghostty and Catppuccin Mocha settings |
| `yazi` | `~/.config/yazi` | Hidden files, previews, editor integration, keybindings |
| `sesh` | `~/.config/sesh` | Named sessions for projects and common directories |
| `fzf-git` | `~/.config/fzf/fzf-git.sh` | Git-aware fzf integration |
| `gitconfig` | `~/.config/git/config` | Neovim editor, delta pager, diff3 merges, commit signing |
| `herdr` | `~/.config/herdr` | Herdr keybindings, projects, themes, and Pi launchers |

## Fresh-machine setup

### 1. Install system packages

```bash
sudo dnf install -y \
  git stow zsh tmux neovim fzf fd-find ripgrep zoxide \
  eza bat git-delta glow chafa mediainfo pre-commit \
  gcc gcc-c++ make cmake unzip
```

Install a Nerd Font (the Ghostty configuration expects **FiraCode Nerd Font**), then set Zsh as the login shell:

```bash
# Check the exact installed font name if needed
fc-list | grep -i "FiraCode Nerd Font"
chsh -s "$(command -v zsh)"
```

Install Ghostty separately if it is not available in the enabled Fedora repositories.

### 2. Clone the repository

```bash
git clone https://github.com/dasmcode/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
```

### 3. Install external tools used by the configuration

The shell configuration expects these commands to be available:

```bash
# Yazi and its Catppuccin flavor
sudo dnf copr enable -y lihaohong/yazi
sudo dnf install -y yazi
yazi --version
ya pkg add yazi-rs/flavors:catppuccin-mocha
```

Install [`sesh`](https://github.com/joshmedeski/sesh) using its current Linux installation instructions. It is required by the tmux picker and the `sesh` configuration; `seshagy` is a separate tool used by Herdr.

```bash
command -v sesh
```

```bash
# Oh My Posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Leaf
curl -fsSL https://leaf.rivolink.mg/install.sh | sh

# Herdr and its plugins
curl -fsSL https://herdr.dev/install.sh | sh
herdr plugin install cloudmanic/herdr-plus

# Rust (needed by some tools and for the configured Cargo environment)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Go tools used by this setup
# Install Go first if `go` is not already available.
go install github.com/lmilojevicc/seshagy/cmd/seshagy@latest
go install charm.land/glow/v3@latest

# Register the seshagy Herdr keybind
seshagy install keybind herdr
```

Restart the shell or source the Rust and local-bin environments before continuing:

```bash
source "$HOME/.cargo/env" 2>/dev/null || true
source "$HOME/.local/bin/env" 2>/dev/null || true
```

### 4. Link the configurations with Stow

Run this from the repository root. Stowing explicit packages avoids accidentally treating the repository root as one package.

```bash
cd "$HOME/dotfiles"
stow zshell nvimconfig tmux ghostty yazi sesh fzf-git gitconfig herdr
```

To link only one component, for example Neovim:

```bash
stow nvimconfig
```

If Stow reports a conflict, inspect the existing file first. Back it up or remove it deliberately; do not use `--adopt` unless you intend to import that file into this repository.

### 5. Install plugin dependencies

Start each tool once so it can finish its own bootstrap:

```bash
nvim                 # Lazy.nvim and Mason plugins will initialize
tmux                 # then press ` + I to install TPM plugins
herdr
```

The tmux prefix is **backtick** (`), not the default `Ctrl-b`. Useful first-run commands:

- `` ` `` then `I`: install TPM plugins
- `` ` `` then `r`: reload tmux configuration
- `` ` `` then `o`: open the sesh picker
- `` ` `` then `\`: split horizontally
- `` ` `` then `-`: split vertically
- `` ` `` then `h` / `l`: move to the previous/next window

The Herdr prefix is also **backtick**. Its configured shortcuts include:

- `` ` `` then `p`: open Herdr projects
- `` ` `` then `o`: open Herdr quick actions
- `` ` `` then `i`: open the seshagy picker
- `Ctrl-h/j/k/l`: navigate between Herdr and Neovim panes

## Pi setup

Pi is a separate dependency from these dotfiles. Herdr starts it inside whichever project or terminal tab contains the `pi` command; the setup is not tied to one project directory. The checked-in Herdr project files are only launchers and workspace definitions.

The current Pi setup on this machine consists of:

| Location | Purpose |
| --- | --- |
| `~/.local/bin/pi` | Pi executable (`0.85.1` on this machine) |
| `~/.pi/agent/settings.json` | Theme, default provider/model, UI mode, and installed Pi packages |
| `~/.pi/agent/zentui.json` | Zentui editor/footer/selector layout and Nerd Font icons |
| `~/.pi/agent/extensions/glow-preview.ts` | `glow-preview` command for rendering the latest response |
| `~/.config/glow/pi-browser.json` | Glow theme used by the preview extension |
| `~/.config/pi/web-search.json` | Web-search provider configuration and credentials |
| `~/.pi/agent/auth.json` | Provider authentication credentials |

The current agent settings use the Catppuccin Mocha theme, the OpenAI provider, regular TUI mode, and these packages:

```text
npm:pi-zentui
npm:@firstpick/pi-themes-bundle
npm:pi-markdown-preview
npm:@gotgenes/pi-permission-system
npm:pi-web-access
```

### Replicate this Pi setup on another PC

1. Complete the general dotfiles setup above, including Zsh, Ghostty, the Nerd Font, `glow`, and Herdr.
2. Install Pi using the current Pi installation instructions. Confirm the executable is available:

   ```bash
   command -v pi
   pi --version
   ```

3. Start Pi once and authenticate the provider you intend to use. Do not copy `auth.json` or any API-key-containing file into Git or share it insecurely.
4. Recreate or securely transfer the non-secret Pi configuration:

   ```text
   ~/.pi/agent/settings.json
   ~/.pi/agent/zentui.json
   ~/.pi/agent/extensions/glow-preview.ts
   ~/.config/glow/pi-browser.json
   ```

   These files are currently outside this repository, so they must be backed up separately if this exact Pi UI is important. Copy only the configuration files you trust; do not blindly copy caches, model stores, or session history.
5. Install the five packages listed above through Pi's package manager. The package list in `~/.pi/agent/settings.json` should then match this machine.
6. Copy the web-search configuration only after replacing its credentials with a new key or a secure credential on the destination machine. Keep it at `~/.config/pi/web-search.json` if you want the same search integration.
7. Install `glow` and set the preview extension's style path for the new home directory:

   ```bash
   export GLOW_STYLE="$HOME/.config/glow/pi-browser.json"
   ```

   The current extension contains this machine's absolute path as a fallback, so update that fallback or keep `GLOW_STYLE` set permanently in the shell configuration.
8. Verify the replicated setup:

   ```bash
   pi
   ```

   Check that the Catppuccin theme, Zentui layout, packages, and `glow-preview` command are available.

Project-specific launchers can still be replicated through Herdr. For example, the repository contains a `voice-bot` project, but on another machine its `working_dir` should be changed to a directory that exists there. To create another Pi workspace, copy one of the project files under:

```text
~/.config/herdr/plugins/config/cloudmanic.herdr-plus/projects/
```

Then change its `working_dir`, tabs, and commands as needed. A minimal Pi tab is simply:

```toml
[[tabs]]
name = "pi"

[[tabs.panes]]
command = "pi"
```

Pi credentials, web-search keys, provider configuration secrets, session history, and caches are intentionally not stored in this repository. Transfer those through a secure password manager or encrypted channel, and never commit them.

## Git signing setup

The checked-in Git configuration enables GPG signing. On a different machine, configure your own signing key before committing:

```bash
gpg --list-secret-keys --keyid-format=long
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global user.signingkey YOUR_KEY_ID
```

If signing is not configured yet, temporarily disable it with `git config --global commit.gpgSign false` or update `gitconfig/.config/git/config` before stowing it.

## Updating the dotfiles

```bash
cd "$HOME/dotfiles"
git pull --rebase
stow --restow zshell nvimconfig tmux ghostty yazi sesh fzf-git gitconfig herdr
```

Review changes before committing:

```bash
git status
git diff
```

The repository includes a pre-commit configuration for [Gitleaks](https://github.com/gitleaks/gitleaks). Enable it locally with `pre-commit install` after installing `pre-commit`. Never commit credentials, private keys, API tokens, or machine-specific secrets.

## Useful verification commands

```bash
command -v zsh nvim tmux yazi sesh fzf fd zoxide oh-my-posh herdr pi
stow -n -v zshell nvimconfig tmux ghostty yazi sesh fzf-git gitconfig herdr
nvim --headless '+checkhealth' '+qa'
```

## Notes

- The shell configuration bootstraps Zinit automatically on first Zsh startup.
- The Neovim configuration bootstraps Lazy.nvim automatically; language servers and formatters may still need to be installed through Mason or the relevant project toolchain.
- `gitconfig` uses `delta`, `nvim`, and GPG signing, so those dependencies should be configured before relying on Git aliases and commits.
- The Yazi preview configuration uses `chafa`; image previews depend on terminal support.
- `tmux` persistence uses TPM, tmux-resurrect, and tmux-continuum. The first restore may take a moment while the environment is initialized.
