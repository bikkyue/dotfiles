{ config, pkgs, ... }:

{
  home.username = "ubuntu";
  home.homeDirectory = "/home/ubuntu";

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
    initExtra = ''
      # Home Manager が管理するパッケージへのパス
      export PATH="$HOME/.local/state/home-manager/gcroots/current-home/home-path/bin:$PATH"
    '';
  };

  # starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Home Manager のバージョン。変更不要。
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}

