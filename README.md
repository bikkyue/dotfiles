# dotfiles

Home Managerで管理する個人のユーザー環境。
NixOS、macOS、NixOS以外のLinuxのすべてで同じ設定を使用する。

NixOSのシステム設定は別リポジトリの`nixos-config`で管理する。

## 構成
```text
.
├── flake.nix
├── home.nix
├── hosts/
│   ├── Atarayo/home.nix
│   └── Shironere/home.nix
├── install.sh
└── neovim/
    ├── init.lua
    └── lua/
```

- `flake.nix`: Home Managerの出力と依存バージョン
- `home.nix`: 全環境共通のHome Manager設定（パッケージ、Git、zsh、tmux、Neovimなど）
- `hosts/<ホスト名>/home.nix`: `home.nix`を読み込み、ホスト固有の設定を追加する
- `install.sh`: Nixの導入（NixOS以外）とHome Manager設定の適用
- `neovim/`: NeovimのLua設定

## セットアップ

```bash
git clone https://github.com/bikkyue/dotfiles.git
cd dotfiles
bash install.sh
```

以後はHome Managerを直接更新する。適用する設定は`#`のあとに指定する。

```bash
# NixOS（Atarayo、Shironere）
home-manager switch --flake ".#Atarayo"

# macOS、NixOS以外のLinux
home-manager switch --flake ".#bikkyue" --impure
```

`bikkyue`は実行中のシステムの種類を判定するため、`--impure`が必要。

NixOSでは、`nixos-config`でシステムを更新した後に、こちらでユーザー環境を更新する。

## 主なパッケージ

- zsh
- Git
- Vim
- Neovimとlazy.nvim
- Starship
- fzf
- tmux
- Fastfetch
- ripgrep（Neovim）
- Node.js
- tree-sitterとGCC
- OpenCode
- Claude Code
- Cloudflared

## Flake更新

```bash
nix flake update
```

更新後は`home-manager switch`を再実行する。
`nixos-config`とnixpkgsの版を揃える場合は、両方のリポジトリで同時に更新する。
