# Personal dotfiles config 

## How to Use: 

1. Have stow installed via `sudo dnf install stow`

2. Clone the repo at $HOME/dotfiles

```
bash
git clone https://github.com/dasmcode/dotfiles.git $HOME/dotfiles
sudo dnf copr enable lihaohong/yazi
sudo dnf install yazi eza bat
ya pkg add yazi-rs/flavors:catppuccin-mocha
```

3. Install other dependencies such as zshrc, tmux, nvim, etc as per needed.

4. Run `stow .`

