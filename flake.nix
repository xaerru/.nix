{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors = {
      url = "github:Misterio77/nix-colors";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, kmonad, rust-overlay, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      mkComputer = { username, hostname, features ? [ ], extraModules ? [ ]
        , extraOverlays ? [ ] }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                # Authy
                "electron-9.4.4"
                "wolfram-engine"
              ];
            };
            overlays = import (./users + "/${username}/overlays")
              ++ extraOverlays;
          };
          lib = pkgs.lib;
        in nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          modules = ([
            (./hosts + "/${hostname}/configuration.nix")
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit pkgs features inputs system hostname;
                };
                users."${username}" = import (./users + "/${username}");
              };
            }
          ] ++ extraModules);
        };

    in {
      nixosConfigurations = {
        nienna = mkComputer {
          username = "xaerru";
          hostname = "nienna";
          features = [ "xserver" "shell" ];
          extraModules = [ kmonad.nixosModules.default ];
          extraOverlays = [ kmonad.overlays.default rust-overlay.overlays.default ];
        };
        vana = mkComputer {
          username = "rajveer";
          hostname = "vana";
        };
      };
      devShell.${system} = pkgs.mkShell {
        buildInputs = with pkgs; [ nixUnstable nixfmt rnix-lsp ];
      };
    };
}
