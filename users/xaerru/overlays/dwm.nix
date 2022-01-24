(self: super: {
    dwm = super.dwm.overrideAttrs (oldAttrs: rec {
          patches = [
        ../config/dwm/xaerru-custom-config.diff
        (super.fetchpatch {
          url =
            "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
          sha256 = "CrKItgReKz3G0mEPYiqCHW3xHl6A3oZ0YiQ4oI9KXSw=";
        })
      ];
    });
  })
