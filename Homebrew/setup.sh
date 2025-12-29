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

# ---Homebrewでインストールしたzshをデフォルトシェルに切り替える

# Brewでzshがインストールされているか確認
if ! brew list zsh &>/dev/null; then
    echo "zshがインストールされていないため、インストールを開始します..."
    brew install zsh
else
    echo "zshはすでにインストールされています。"
fi

# インストールしたzshのパスを取得
ZSH_PATH=$(brew --prefix)/bin/zsh

# インストールされたzshがシェルとして許可されているか確認し、追加
if ! grep -Fxq "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi

# デフォルトシェルをインストールしたzshに変更
sudo chsh -s "$ZSH_PATH"

# 設定の反映を促すメッセージ
echo "brewでインストールしたzshをデフォルトシェルに設定しました。ターミナルを再起動してください。"

# zpreztoのインストール
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

source ~/.zpreztorc