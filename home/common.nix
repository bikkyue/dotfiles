{ pkgs, username, ... }:

{
  imports = [
    ../modules/fzf.nix
    ../modules/neovim.nix
    ../modules/starship.nix
    ../modules/tmux.nix
    ../modules/zsh.nix
  ];

  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  home.packages = [
    pkgs.fastfetch
    pkgs.vim
  ];

  # git
  programs.git = {
    enable = true;
    settings.user = {
      name = "bikkyue";
      email = "121682296+bikkyue@users.noreply.github.com";
    };
  };

  # Home Manager のバージョン
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
