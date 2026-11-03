{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      username = "bikkyue";
      mkHome =
        {
          system,
          modules,
          isNixOS ? false,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit username isNixOS; };
          inherit modules;
        };
      mkHost =
        name: system:
        mkHome {
          inherit system;
          modules = [ ./hosts/${name}/home.nix ];
          isNixOS = true;
        };
    in
    {
      # 適用: home-manager switch --flake ".#<ホスト名>"
      homeConfigurations.Atarayo = mkHost "Atarayo" "aarch64-linux";
      homeConfigurations.Shironere = mkHost "Shironere" "x86_64-linux";

      # macOS と NixOS 以外の Linux 用（--impure が必要）
      homeConfigurations.${username} = mkHome {
        system = builtins.currentSystem;
        modules = [ ./home.nix ];
      };
    };
}
