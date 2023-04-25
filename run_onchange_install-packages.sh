#!/usr/bin/env bash

declare -r DEBIAN_PKGS="stow fzf exa"

sudo apt update
sudo apt install -y ${DEBIAN_PKGS}
