{ pkgs, config, inputs, hostname, ... }:

{
  imports = [ inputs.nix-colors.homeManagerModule ];

  colorscheme = inputs.nix-colors.colorSchemes.default-dark;
}
