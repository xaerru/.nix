{ pkgs, inputs, ... }: 
{
  imports = [
      ./alacritty.nix
      ./qutebrowser.nix
  ];
  home.packages = with pkgs; [ ];
}
