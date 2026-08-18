{ inputs, pkgs, username, ... }:

{
  imports = [
    inputs.omp.homeManagerModules.default
    ./modules/fzf.nix
    ./modules/neovim.nix
    ./modules/starship.nix
    ./modules/tmux.nix
    ./modules/zsh.nix
  ];

  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  home.packages = [
    inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
    pkgs.fastfetch
    pkgs.vim
    pkgs.nodejs # JavaScript / TypeScript
    #pkgs.cargo # Rust
    #pkgs.rustc # Rust
    # pkgs.jdk21        # Java
    # pkgs.dotnet-sdk   # C#
    pkgs.opencode
    (pkgs.wrangler.override { nodejs = pkgs.nodejs_22; }) # cloudflare
    pkgs.cloudflared
  ];

  # git
  programs.git = {
    enable = true;
    settings.user = {
      name = "bikkyue";
      email = "121682296+bikkyue@users.noreply.github.com";
    };
  };

  programs.omp = {
    enable = true;
    # OMP's smoke test can delete the Nix builder's working directory.
    package = inputs.omp.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (_: {
      doInstallCheck = false;
    });
  };

  # Home Manager のバージョン
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
