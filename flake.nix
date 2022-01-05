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
    nix-colors.url = "github:Misterio77/nix-colors";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, kmonad, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {inherit system;};
      mkComputer = { username, hostname, extraModules ? [], extraOverlays ? [] }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = import ./users/${username}/overlays
              ++ extraOverlays;
          };
        in nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          modules = ([
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."${username}" =
                  import ./users/${username} { inherit pkgs inputs; };
              };
            }
          ] ++ extraModules);
        };

    in {
      nixosConfigurations = {
        nienna = mkComputer {
          username = "xaerru";
          hostname = "nienna";
          extraModules = [ kmonad.nixosModule ];
          extraOverlays = [ kmonad.overlay ];
        };
        vana = mkComputer {
          username = "rajveer";
          hostname = "vana";
        };
      };
      devShell.${system} = pkgs.mkShell {
          buildInputs = with pkgs; [ nixUnstable nixfmt ];
      };
    };
}
