#!/usr/bin/env bash
set -e

if ! type brew &> /dev/null ; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Since Homebrew is already installed, skip this phase and proceed."
fi

# インストール成功後（または既にインストール済みの場合）に環境を読み込む
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew bundle install --file=Brewfile