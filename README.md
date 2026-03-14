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

## Docker

ホスト機を汚したくないので、用意したdockerコンテナを使用して作業をする想定

`Docker/` ディレクトリで以下のコマンドを実行する。

### 起動

```bash
docker compose up -d
```

### コンテナに入る

```bash
# "dev"の部分はdocker-compose.ymlのサービス名に変更する
docker compose exec dev bash
```

### 停止

```bash
docker compose down
```

### コンテナの確認

```bash
docker ps -a
```

### コンテナの削除

```bash
docker compose rm
```

### 停止済みコンテナ・不要ボリュームの一括削除

```bash
docker system prune --volumes
```


