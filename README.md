# dotfiles

NixOSとHome Managerで管理する個人環境です。

## 構成

```text
.
├── flake.nix
├── home.nix
├── hosts/
│   └── Shironere/
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── install.sh
└── nvim/
```

- `hosts/Shironere`: Shironere固有のNixOS設定
- `home.nix`: macOS、NixOS、非NixOS Linuxで共有するユーザー設定
- `flake.nix`: NixOSとHome Managerの出力および依存バージョン

## セットアップ

```bash
git clone https://github.com/bikkyue/dotfiles.git
cd dotfiles
bash install.sh
```

ShironereではNixOSとHome Managerを一括適用します。macOSと非NixOS LinuxではHome Managerだけを適用します。

## Shironere

Cloudflare TunnelトークンはGitで管理しません。NixOSを適用する前に、次のファイルをroot所有、モード`600`で用意します。

```text
/var/lib/cloudflared/token
```

現在動作中のサービス資格情報から復旧する場合は、サービスを停止・再起動する前に実行します。

```bash
sudo install -D -m 600 -o root -g root \
  /run/credentials/cloudflared.service/tunnel-token \
  /var/lib/cloudflared/token
```

最初にビルドだけを確認します。

```bash
sudo nixos-rebuild build \
  --flake .#Shironere \
  --option experimental-features "nix-command flakes"
```

一時適用後、別の端末からSSHで再接続できることを確認します。

```bash
sudo nixos-rebuild test \
  --flake .#Shironere \
  --option experimental-features "nix-command flakes"
```

問題がなければ永続化します。

```bash
sudo nixos-rebuild switch --flake .#Shironere
```

以後はこのコマンドでNixOSとHome Managerの両方が更新されます。

## macOS

```bash
nix run home-manager/master -- switch \
  --flake '.#bikkyue@macos' \
  -b backup
```

## 非NixOS Linux

```bash
nix run home-manager/master -- switch \
  --flake '.#bikkyue@linux' \
  -b backup
```

## パッケージ

- zsh
- Git
- Neovimとlazy.nvim
- Starship
- fzf
- tmux
- ripgrep
- Node.js
- Rust
- OpenCode
- Claude Code
- Wrangler
- Cloudflared

## 更新

flake inputを更新します。

```bash
nix flake update
```

Shironereでは更新後にビルドと一時適用を確認してから永続化します。
