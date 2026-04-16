#!/bin/bash
set -e

# 1. Environment Setup
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"

echo "--- Preparing Rust ---"
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
fi

# Load environment and force stable
. "$CARGO_HOME/env"
rustup default stable

# 2. Install wasm-pack
if ! command -v wasm-pack &> /dev/null; then
    curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
fi

echo "--- Versions ---"
rustc --version
wasm-pack --version

# 3. Build Command (Make sure this points to your Cargo.toml)
echo "--- Building WASM ---"
wasm-pack build --target web --out-dir public/pkg .