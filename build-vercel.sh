#!/bin/bash
# Exit on any error
set -e

echo "--- Current Directory: $(pwd) ---"

# 1. Install Rustup/Cargo if not present
if ! command -v cargo &> /dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Rust already installed."
fi

# 2. Install wasm-pack if not present
if ! command -v wasm-pack &> /dev/null; then
    echo "Installing wasm-pack..."
    curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
    source "$HOME/.cargo/env"
fi

# 3. Explicitly add Cargo bin to PATH for this session
export PATH="$HOME/.cargo/bin:$PATH"

echo "--- Versions ---"
rustc --version
wasm-pack --version

# 4. Build with full path to ensure no 'command not found'
echo "--- Starting Build ---"
wasm-pack build --target web --out-dir public/pkg