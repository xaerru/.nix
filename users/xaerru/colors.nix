{ pkgs, config, inputs, hostname, ... }:

with inputs.nix-colors.lib { inherit pkgs; };

{
  imports = [ inputs.nix-colors.homeManagerModule ];

  colorscheme = inputs.nix-colors.colorSchemes.default-dark;
}
