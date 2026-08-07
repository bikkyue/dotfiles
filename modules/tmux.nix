{ lib, pkgs, ... }:

{
  home.packages = lib.optionals pkgs.stdenv.isLinux [ pkgs.wl-clipboard ];

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    escapeTime = 0;
    mouse = true;
    extraConfig = lib.optionalString pkgs.stdenv.isLinux ''
      bind-key -T copy-mode Enter send-keys -X copy-pipe-and-cancel '${pkgs.wl-clipboard}/bin/wl-copy'
      bind-key -T copy-mode M-w send-keys -X copy-pipe-and-cancel '${pkgs.wl-clipboard}/bin/wl-copy'
      bind-key -T copy-mode MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel '${pkgs.wl-clipboard}/bin/wl-copy'
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel '${pkgs.wl-clipboard}/bin/wl-copy'
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel '${pkgs.wl-clipboard}/bin/wl-copy'
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel '${pkgs.wl-clipboard}/bin/wl-copy'
    '';
  };
}
