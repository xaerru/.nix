{ pkgs, inputs, ... }: 
{
  imports = [
      ./alacritty.nix
  ];
  home.packages = with pkgs; [ ];
}
