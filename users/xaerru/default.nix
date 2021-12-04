{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home.packages= with pkgs; [ dwm zoom-us ];
  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        patches = [
          ./config/dwm/xaerru-custom-config.diff
	  (super.fetchpatch {
            url = "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
            sha256 = "114xcy1qipq6cyyc051yy27aqqkfrhrv9gjn8fli6gmkr0x6pk52";
          })
        ];
      });
    })
  ];
}
