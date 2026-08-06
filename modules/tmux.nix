{ ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    escapeTime = 0;
    mouse = true;
  };
}
