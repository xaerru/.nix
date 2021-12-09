{ config, pkgs, ... }:

{
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    zoom-us
    pinentry-curses
    gnupg
    (dwm.overrideAttrs (oldAttrs: rec {
      patches = [
        ./config/dwm/xaerru-custom-config.diff
        (fetchpatch {
          url =
            "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
          sha256 = "114xcy1qipq6cyyc051yy27aqqkfrhrv9gjn8fli6gmkr0x6pk52";
        })
      ];
    }))
  ];
}
