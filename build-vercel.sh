#!/bin/bash
set -e

# 1. Environment Setup
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"

echo "--- Installing/Updating Rust ---"
# Install rustup if not found
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
fi

# Load environment
. "$CARGO_HOME/env"
rustup default stable || true

# 2. Install wasm-pack
echo "--- Checking wasm-pack ---"
if ! command -v wasm-pack &> /dev/null; then
    curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
fi

# 3. Final Build
echo "--- Building WASM ---"
# Double-check that Cargo.toml exists in the current folder
if [ ! -f "Cargo.toml" ]; then
    echo "ERROR: Cargo.toml not found in $(pwd)"
    ls -F
    exit 1
fi

wasm-pack build --target web --out-dir public/pkg