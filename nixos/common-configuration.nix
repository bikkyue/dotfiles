{ pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.networkmanager.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  users.users.bikkyue = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINSlm7kxHVoyzo2d1Sq33GoUIT98Wjf7WP9Viqd6Aru5"
    ];
  };

  programs.zsh.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "Noto Sans CJK JP" ];
      serif = [ "Noto Serif CJK JP" ];
      monospace = [ "Noto Sans Mono CJK JP" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
