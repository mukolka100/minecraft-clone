#!/bin/bash
set -e

# 1. Environment Setup
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export PATH="$CARGO_HOME/bin:$PATH"

echo "--- Preparing Rust ---"
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal
fi

# shellcheck disable=SC1091
# This file only exists on the Vercel build server, so we tell shellcheck to ignore it.
[ -f "$CARGO_HOME/env" ] && . "$CARGO_HOME/env"

rustup default stable
rustup target add wasm32-unknown-unknown

echo "--- Installing wasm-pack ---"
if ! command -v wasm-pack &> /dev/null; then
    curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
fi

# 2. Find the project folder
echo "--- Searching for Cargo.toml ---"
CARGO_PATH=$(find . -name "Cargo.toml" -print -quit)

if [ -z "$CARGO_PATH" ]; then
    echo "FATAL: Cargo.toml not found!"
    ls -R
    exit 1
fi

PROJECT_DIR=$(dirname "$CARGO_PATH")

# 3. Build (Fully quoted for SC2086)
echo "--- Starting Compilation ---"
"$CARGO_HOME/bin/wasm-pack" build "$PROJECT_DIR" --target web --out-dir public/pkg