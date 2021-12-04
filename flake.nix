{
  description = "My NixOS configuration";

  inputs = {
     nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
     home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
     };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
       inherit system;
       config = { allowUnfree = true; };
       overlays = [
         (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        patches = [
          ./users/xaerru/config/dwm/xaerru-custom-config.diff
          (super.fetchpatch {
            url = "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
            sha256 = "114xcy1qipq6cyyc051yy27aqqkfrhrv9gjn8fli6gmkr0x6pk52";
          })
        ];
      });})
       ];
    };

    lib = nixpkgs.lib;
  in {
     nixosConfigurations = {
       nienna = lib.nixosSystem {
         inherit system;
	 specialArgs = { inherit system inputs pkgs; };
         modules = [
           ./hosts/nienna/configuration.nix
	   home-manager.nixosModules.home-manager
          {
	    home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.xaerru = import ./users/xaerru;
          }
	 ];
       };
       };
     };
}
