{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home.packages= with pkgs; [ dwm ];
  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        patches = [
          ./config/dwm/xaerru-custom-config.diff
        ];
      });
    })
  ];
}
