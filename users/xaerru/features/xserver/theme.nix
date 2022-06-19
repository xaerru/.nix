{ pkgs, inputs, ... }:

with inputs.nix-colors.lib-contrib { inherit pkgs; };

rec {
  gtk = {
    enable = true;
    theme = {
      name = "default-dark";
      package = gtkThemeFromScheme {
        scheme = inputs.nix-colors.colorSchemes.default-dark;
      };
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };
  services.xsettingsd = {
    enable = true;
    settings = { "Net/ThemeName" = "${gtk.theme.name}"; };
  };
}
