#!/usr/bin/env bash
set -euo pipefail

# safer glob behavior: nonマッチの場合は空になる
shopt -s nullglob

DOTFILES_DIR="$HOME/dotfiles"

echo "シンボリックリンクを作成します (source: $DOTFILES_DIR)"

# dotfiles ディレクトリ直下のサブディレクトリ内の隠しファイル（.bashrc など）をターゲットにする
# パターン: "$DOTFILES_DIR"/*/.[!.]*  （.[!.]* は . と .. を除外）
for file in "$DOTFILES_DIR"/*/.[!.]*; do
  # 念のため存在確認
  [ -e "$file" ] || continue

  name="$(basename "$file")"         # 例: .bashrc
  link_name="$HOME/$name"           # ホーム直下に作成

  # 既に正しいシンボリックリンクならスキップ
  if [ -L "$link_name" ] && [ "$(readlink -f "$link_name")" = "$(readlink -f "$file")" ]; then
    echo "既に正しいリンク: $link_name -> $(readlink -f "$link_name")"
    continue
  fi

  # 既存のファイル/ディレクトリ/リンクがあればバックアップ
  if [ -e "$link_name" ] || [ -L "$link_name" ]; then
    bak="${link_name}.bak.$(date +%Y%m%d%H%M%S)"
    echo "バックアップ: $link_name -> $bak"
    mv "$link_name" "$bak"
  fi

  # シンボリックリンク作成
  ln -s "$file" "$link_name"
  echo "リンクを作成: $file -> $link_name"
done

# Neovim 用の setup を実行（絶対パスで呼ぶ、安全のため実行ビットを付与してから実行）
nvim_setup="$DOTFILES_DIR/nvim/setup.sh"
if [ -e "$nvim_setup" ]; then
  chmod +x "$nvim_setup" || true
  echo "Neovim 用セットアップを実行: $nvim_setup"
  # もし nvim/setup.sh が引数を受け取るなら渡す（src と target）
  "$nvim_setup" "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
else
  echo "警告: $nvim_setup が見つかりません。Neovim のセットアップをスキップします。"
fi

echo "完了: シンボリックリンクがホームディレクトリ直下に作成されました"