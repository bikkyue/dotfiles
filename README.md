# dotfiles

NixOSとHome Managerで管理する個人環境。
NixOSではシステムとユーザー環境を一括管理し、
macOSと非NixOS LinuxではHome Managerだけを使用する。

## 構成

```text
.
├── flake.nix
├── home.nix
├── install.sh
├── modules/
│   ├── fzf.nix
│   ├── neovim.nix
│   ├── starship.nix
│   ├── tmux.nix
│   └── zsh.nix
├── neovim/
│   ├── init.lua
│   └── lua/
└── nixos/
    ├── common-configuration.nix
    ├── Atarayo/
    │   ├── configuration.nix
    │   └── hardware-configuration.nix
    └── Shironere/
        ├── configuration.nix
        └── hardware-configuration.nix
```

- `flake.nix`: NixOSとHome Managerの出力、依存バージョン
- `home.nix`: 全OSで共有するHome Manager設定
- `install.sh`: OSを判定して適切なHome ManagerまたはNixOS設定を適用
- `modules/`: アプリケーションごとのHome Manager module
- `neovim/`: NeovimのLua設定
- `nixos/common-configuration.nix`: ユーザー、SSH、NetworkManager、Avahi、Notoフォントなどの共通設定
- `nixos/Atarayo`: Apple Siliconマシン固有の設定
- `nixos/Shironere`: x86_64マシン固有の設定

## セットアップ

```bash
git clone https://github.com/bikkyue/dotfiles.git
cd dotfiles
```

### NixOS

`HOST`には`Atarayo`または`Shironere`を指定する。

```bash
sudo nixos-rebuild switch --flake ".#<hostname>" --impure
```

### Shironereの遠隔運用

ShironereではTailscaleを常時起動し、NixOSが管理するSSH、Samba、XRDPなどの
受信接続を`tailscale0`からの通信に限定する。移設先のLANにはこれらのポートを
公開しない。

初回だけ、現地へ移設する前にTailnetへ登録する。設定適用時にLAN経由のSSHが
閉じるため、以下はShironereのローカルコンソールで実行する。

```bash
sudo nixos-rebuild switch --flake ".#Shironere" --impure
sudo tailscale up
tailscale status
tailscale ip -4
```

別のTailnet参加端末からSSHと必要なサービスへ接続できること、および再起動後も
`tailscale status`が接続済みになることを確認してから移設する。アクセス可能な
ユーザーや端末はTailscaleのAccess controlsでも制限する。

Docker Composeの`ports`で`0.0.0.0`に公開したポートは、Dockerの転送規則によって
NixOSの入力ファイアウォールを迂回する場合がある。現在のImmichのTCP 2283が該当
するため、移設前にCompose側のバインド先またはDockerの`DOCKER-USER`チェインを
別途Tailnet限定にする。

### NixOS以外

初回セットアップはmacOSとLinuxで共通

```bash
bash install.sh
```

以後はHome Managerを直接更新する。

```bash
home-manager switch --flake . --impure
```

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
- Wrangler
- Cloudflared
- Noto CJKとNoto Color Emoji（NixOS）

## Flake更新

```bash
nix flake update
```

更新後は、使用しているOSの適用コマンドを再実行する。
