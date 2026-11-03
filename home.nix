{
  isNixOS ? false,
  lib,
  pkgs,
  username,
  ...
}:

let
  # npm パッケージを毎回最新版で実行するコマンドを作る
  npxBin =
    name: package:
    pkgs.writeShellScriptBin name ''
      exec ${pkgs.nodejs}/bin/npx -y ${package} "$@"
    '';
in
{
  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";

  home.packages =
    with pkgs;
    [
      fastfetch
      gh
      vim

      # 開発用
      nodejs # JavaScript / TypeScript
      # cargo # Rust
      # rustc # Rust
      (npxBin "opencode" "opencode-ai")

      # Cloudflare
      (npxBin "cf" "cf@latest") # 新CLI（beta）
      cloudflared
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ wl-clipboard ];

  # git
  programs.git = {
    enable = true;
    settings.user = {
      name = "bikkyue";
      email = "121682296+bikkyue@users.noreply.github.com";
    };
  };

  # bash（NixOS 以外の Linux ではログインシェルが bash のため zsh に切り替える）
  programs.bash = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && !isNixOS) {
    enable = true;
    initExtra = ''
      if [[ $- == *i* ]]; then
        exec ${pkgs.zsh}/bin/zsh
      fi
    '';
  };

  # zsh
  programs.zsh = {
    enable = true;
    # .zshenv に書いておくと全セッションで読み込まれる
    envExtra = ''
      # macOS と Linux でパスが違う
      if [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
        . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
      elif [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
    '';
    initContent = ''
      fastfetch
    '';
  };

  # fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # 使用フォーマット：　https://starship.rs/presets/pure-preset
      format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$python$character";
      directory.style = "blue";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };
      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        stashed = "≡";
      };
      git_state = {
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "bright-black";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
      python = {
        format = "[$virtualenv]($style) ";
        style = "bright-black";
        detect_extensions = [ ];
        detect_files = [ ];
      };
    };
  };

  # tmux
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    escapeTime = 0;
    mouse = true;
    extraConfig = lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
      bind-key -T copy-mode Enter send-keys -X copy-pipe-and-cancel '${pkgs.wl-clipboard}/bin/wl-copy'
      bind-key -T copy-mode M-w send-keys -X copy-pipe-and-cancel '${pkgs.wl-clipboard}/bin/wl-copy'
      bind-key -T copy-mode MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel '${pkgs.wl-clipboard}/bin/wl-copy'
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel '${pkgs.wl-clipboard}/bin/wl-copy'
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel '${pkgs.wl-clipboard}/bin/wl-copy'
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel '${pkgs.wl-clipboard}/bin/wl-copy'
    '';
  };

  # neovim
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      gcc
      ripgrep
      tree-sitter
    ];
    initLua = builtins.readFile ./neovim/init.lua;
    withRuby = false;
    withPython3 = false;
  };

  xdg.configFile."nvim/lua" = {
    source = ./neovim/lua;
    recursive = true;
  };

  # claude-code
  programs.claude-code = {
    enable = true;
    # ~/.claude/settings.json を書き込み可能なまま、ここに書いた値だけを反映する
    mutableSettings = true;
    settings = {
      model = "opus";
      modelSettings.claude-sonnet-5.effortLevel = "medium";
      theme = "dark";
      language = "japanese";
    };
  };

  # 最初に導入した Home Manager のリリース（HM を更新しても変えない）
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
