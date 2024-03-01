#!/bin/bash
#
curl https://sh.rustup.rs -sSf | sh
echo 'source "$HOME/.cargo/env"' >>~/.bashrc
. ~/.bashrc
cargo install pg-trunk
