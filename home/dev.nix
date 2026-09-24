{ inputs, pkgs, ... }:

{
  imports = [
    inputs.omp.homeManagerModules.default
  ];

  home.packages = [
    inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
    pkgs.nodejs # JavaScript / TypeScript
    #pkgs.cargo # Rust
    #pkgs.rustc # Rust
    (pkgs.writeShellScriptBin "opencode" ''
      exec ${pkgs.nodejs}/bin/npx -y opencode-ai@beta "$@"
    '')
    (pkgs.wrangler.override { nodejs = pkgs.nodejs_22; }) # cloudflare
    pkgs.cloudflared
  ];
}
