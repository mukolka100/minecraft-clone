#!/bin/bash
set -e # Exit immediately if a command fails

echo "--- Installing Rust ---"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

echo "--- Installing wasm-pack ---"
curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

echo "--- Building WASM ---"
# Use the full path to wasm-pack just in case
$HOME/.cargo/bin/wasm-pack build --target web --out-dir public/pkg