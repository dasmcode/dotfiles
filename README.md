# Personal dotfiles config 

## How to Use: 

### 1. Have stow installed via: 
```bash 
sudo dnf install stow
```

### 2. Clone the repo at $HOME/dotfiles
```bash
git clone https://github.com/dasmcode/dotfiles.git $HOME/dotfiles
sudo dnf copr enable lihaohong/yazi
sudo dnf install yazi eza bat
ya pkg add yazi-rs/flavors:catppuccin-mocha
# Install ohmyposh
curl -s https://ohmyposh.dev/install.sh | bash -s
```

### 3. Install herdr and other plugin dependencies
```bash
# Install herdr
curl -fsSL https://herdr.dev/install.sh | sh
# Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
herdr plugin install cloudmanic/herdr-plus
go install github.com/lmilojevicc/seshagy/cmd/seshagy@latest
seshagy install keybind herdr
```

3. Install other dependencies such as zshrc, tmux, nvim, etc as per needed.

4. Run `stow .`

