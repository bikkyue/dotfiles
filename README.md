# dotfiles

NixOSとHome Managerで管理する個人環境です。NixOSではシステムとユーザー環境を一括管理し、macOSと非NixOS LinuxではHome Managerだけを使用します。

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

`HOST`には`Atarayo`または`Shironere`を指定します。

```bash
HOST=Atarayo
sudo nixos-rebuild switch --flake ".#${HOST}" --impure
```

AtarayoではFlake外のAsahi Linuxファームウェアを参照するため`--impure`が必要です。コマンドを統一するため、Shironereでも同じオプションを使用します。

### NixOS以外

初回セットアップはmacOSとLinuxで共通です。

```bash
bash install.sh
```

以後はHome Managerを直接更新できます。

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
- ripgrep
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

更新後は、使用しているOSの適用コマンドを再実行します。
