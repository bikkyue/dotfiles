{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  home.packages = [
    
  ];

  # LazyVim
  programs.lazyvim = {
    enable = true;
  };

  # bashで入った際にzshへ切り替える。
  programs.bash = {
    enable = true;
    initExtra = "exec ${pkgs.zsh}/bin/zsh";
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
    initExtra = ''
      export PATH="$HOME/.local/state/home-manager/gcroots/current-home/home-path/bin:$PATH"
    '';
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
        detect_extensions = [];
        detect_files = [];
      };
    };
  };

  # fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # tmux
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    escapeTime = 0;
    mouse = true;
  };

  # Home Manager のバージョン
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}

