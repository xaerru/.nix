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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, kmonad, ... }:
    let
      system = "x86_64-linux";
      xaerru_overlays = import ./users/xaerru/overlays;

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = xaerru_overlays ++ [kmonad.overlay];
      };

      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        nienna = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/nienna/configuration.nix 
            kmonad.nixosModule
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.xaerru = import ./users/xaerru{inherit pkgs;};
            }
          ];
        };
      };
    };
}
