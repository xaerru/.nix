(self: super: {
  tabbed = super.tabbed.overrideAttrs (oldAttrs: rec {
    patches = [
      ../config/tabbed/xaerru-custom-config.diff
    ];
  });
})
