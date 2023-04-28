#!/usr/bin/env bash

declare -r DEBIAN_PKGS="stow fzf exa kitty clang libluajit-5.1-dev make"

sudo apt update
sudo apt install -y ${DEBIAN_PKGS}
