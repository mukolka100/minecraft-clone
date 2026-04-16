#!/bin/bash
set -e

echo "--- ТЕКУЩАЯ ПАПКА: $(pwd) ---"
ls -F

# Установка путей
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"

# Установка Rust
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
fi

. "$CARGO_HOME/env"
rustup default stable

# Установка wasm-pack
if ! command -v wasm-pack &> /dev/null; then
    curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
fi

echo "--- СБОРКА WASM ---"
# Проверка наличия Cargo.toml перед билдом
if [ ! -f "Cargo.toml" ]; then
    echo "ОШИБКА: Cargo.toml не найден в корне!"
    exit 1
fi

wasm-pack build --target web --out-dir public/pkg