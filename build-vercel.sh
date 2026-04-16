#!/bin/bash
set -e

# 1. Установка путей
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"
export PATH="$CARGO_HOME/bin:$PATH"

echo "--- Установка Rust и Toolchain ---"
# Устанавливаем Rust молча и быстро
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal

# Принудительно загружаем переменные
. "$CARGO_HOME/env"

# Устанавливаем дефолт и проверяем
rustup default stable
rustup target add wasm32-unknown-unknown

echo "--- Установка wasm-pack ---"
curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

# 2. Проверка путей перед билдом
echo "Path: $PATH"
echo "Rustc: $(which rustc || echo 'not found')"
echo "Wasm-pack: $(which wasm-pack || echo 'not found')"

# 3. Сборка
echo "--- Запуск компиляции ---"
# Используем полный путь к wasm-pack, чтобы исключить ошибки PATH
$CARGO_HOME/bin/wasm-pack build --target web --out-dir public/pkg