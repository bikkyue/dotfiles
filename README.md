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

- fzf

    コマンドライン用のファジー検索ツール

- tmux

## Nix

- flake.lockに記載のinputを最新化
    ```bash
    nix flake update
    ```

- flake.lockの変更を反映

  ユーザ名を可変としたいため --impure を指定。

    ```bash
    home-manager switch --flake . --impure
    ```
        

