# dotfiles

## セットアップ手順

```
git clone https://github.com/bikkyue/dotfiles.git \
&& cd dotfiles \
&& bash install.sh
```

## ディレクトリ構成

## パッケージ

- zsh

- git

- Neovim
    
    - lazy.vim

- starship

    zsh用のプロンプト
    テーマは[Pure Preset](https://starship.rs/presets/pure-preset)を使用 

- tmux

## Nix home-manager

### home-manager 更新

home-manager switch --flake . --impure

ユーザ名を可変としたいため --impure を指定。




## Docker

ホスト機を汚したくないので、用意したdockerコンテナを使用して作業をする想定

`docker/` ディレクトリで以下のコマンドを実行する。

### 起動

```bash
docker compose up -d
```

### コンテナに入る

```bash
# "dev"の部分はdocker-compose.ymlのサービス名に変更する
docker compose exec dev bash
```

### 停止・削除

```bash
docker compose down
```

### コンテナの確認

```bash
docker ps -a
```

### 停止済みコンテナ・不要ボリューム等の一括削除

```bash
docker system prune --volumes
```


