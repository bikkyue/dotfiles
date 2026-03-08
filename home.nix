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

  programs.zsh = {
    enable = true;
    initExtra = ''
      # Home Manager が管理するパッケージへのパス
      export PATH="$HOME/.local/state/home-manager/gcroots/current-home/home-path/bin:$PATH"
    '';
  };

  # Home Manager のバージョン。変更不要。
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}

