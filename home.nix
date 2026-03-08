{ config, pkgs, ... }:

{
  home.username = "ubuntu";
  home.homeDirectory = "/home/ubuntu";

  home.packages = [
    pkgs.neovim
  ];

  # Home Manager のバージョン。変更不要。
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}

