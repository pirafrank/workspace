#!/bin/zsh

# headless install of the latest available version of rust and cargo

curl --proto '=https' --tlsv1.2 -sSL https://sh.rustup.rs > rust-install
sh rust-install -v -y --no-modify-path
# support dotfiles-less setup
if [ -f $HOME/.zshrc ]; then
  source $HOME/.zshrc
else
  # assuming you got bash
  source $HOME/.bashrc
fi
rm rust-install
