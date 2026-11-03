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

`install.sh`は、NixOSではホスト名（`#$(hostname)`）、それ以外では`#bikkyue`の設定を適用する。
初回は`home-manager`コマンドがまだないため、`nix run home-manager/master`経由で実行する。

## 適用

適用する設定は`#`のあとに指定する。`#`を省略すると正しい設定が選ばれない。

```bash
# NixOS（Atarayo、Shironere）
home-manager switch --flake ".#Atarayo"

# macOS、NixOS以外のLinux
home-manager switch --flake ".#bikkyue" --impure
```

`bikkyue`は実行中のシステムの種類を判定するため、`--impure`が必要。

NixOSでは、`nixos-config`でシステムを更新した後に、こちらでユーザー環境を更新する。

### NixOS統合版からの移行（初回のみ）

以前のようにHome ManagerをNixOSのモジュールとして使っていたホストでは、次の順に続けて実行する。

```bash
cd ~/nixos-config && sudo nixos-rebuild switch --flake ".#<ホスト名>" --impure
cd ~/dotfiles && nix run home-manager/master -- switch --flake ".#<ホスト名>" -b backup
```

1行目の直後は`/etc/profiles/per-user/bikkyue`が消えるため、zshで
`no such file or directory: .../starship`が表示され、プロンプトが出なくなる。
入力は受け付けているので、そのまま2行目を実行する。
入力できない場合は、別の端末やSSHから2行目を実行する。
終わったら`exec zsh`でシェルを読み込み直す。

## 主なパッケージ

- zsh
- Git
- GitHub CLI（gh）
- Vim
- Neovimとlazy.nvim
- Starship
- fzf
- tmux
- Fastfetch
- ripgrep（Neovim）
- Node.js
- tree-sitterとGCC
- Claude Code（nixpkgsの`claude-code`）
- OpenCode（npx経由で`opencode-ai`を実行）
- Cloudflare CLI（npx経由で`cf@latest`を実行）
- Cloudflared

npmのCLIは、`home.nix`の`npxBin "<コマンド名>" "<npmパッケージ>"`で追加する。
unfreeのパッケージも`home.packages`にそのまま追加できる（`flake.nix`で`allowUnfree`を有効化している）。

## Flake更新

```bash
nix flake update
```

更新後は`home-manager switch`を再実行する。
`nixos-config`とnixpkgsの版を揃えるため、両方のリポジトリで同時に更新する。
