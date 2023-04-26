#!/usr/bin/env bash

declare -r DEBIAN_PKGS="stow fzf exa kitty"

sudo apt update
sudo apt install -y ${DEBIAN_PKGS}
