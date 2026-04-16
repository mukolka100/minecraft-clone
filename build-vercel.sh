#!/bin/bash
set -e # Stop on first error

# 1. FORCE HOME PATHS
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export PATH="$CARGO_HOME/bin:$PATH"

echo "--- Checking Environment ---"
if ! command -v rustc &> /dev/null; then
    echo "Rust not found. Installing..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
    # Explicitly source the env file
    . "$CARGO_HOME/env"
fi

if ! command -v wasm-pack &> /dev/null; then
    echo "wasm-pack not found. Installing..."
    curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
fi

# 2. VERIFY INSTALLS
echo "Using Rust: $(rustc --version)"
echo "Using wasm-pack: $(wasm-pack --version)"

# 3. RUN BUILD
echo "--- Compiling Rust to WASM ---"
wasm-pack build --target web --out-dir public/pkg