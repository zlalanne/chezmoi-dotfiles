#!/usr/bin/env bash

declare -r DEBIAN_PKGS="stow fzf exa kitty clang"

sudo apt update
sudo apt install -y ${DEBIAN_PKGS}
