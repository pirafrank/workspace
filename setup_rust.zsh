#!/bin/zsh

# headless install of the latest available version of rust and cargo

curl --proto '=https' --tlsv1.2 -sSL https://sh.rustup.rs > rust-install
sh rust-install -v -y --no-modify-path
source $HOME/.zshrc
rm rust-install
