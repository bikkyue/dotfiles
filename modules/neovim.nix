{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      gcc
      ripgrep
      tree-sitter
    ];
    initLua = builtins.readFile ../neovim/init.lua;
    withRuby = false;
    withPython3 = false;
  };

  xdg.configFile."nvim/lua" = {
    source = ../neovim/lua;
    recursive = true;
  };
}
