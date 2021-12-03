{
  description = "My NixOS configuration";

  inputs = {
     nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
     home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
     };
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
       inherit system;
       config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;
  in {
     homeManagerConfigurations = {
       xaerru = home-manager.lib.homeManagerConfiguration {
         inherit system pkgs;
         username = "xaerru";
         homeDirectory = "/home/xaerru";
	 configuration = {
           imports = [
             ./users/xaerru
	   ];
	 };
       };
     };
     nixosConfigurations = {
       nixos = lib.nixosSystem {
         inherit system;
         modules = [
           ./hosts/nienna/configuration.nix
	 ];
       };

       };
     };
}
