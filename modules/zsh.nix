{ ... }:

{
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
}
