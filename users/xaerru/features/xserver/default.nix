{ pkgs, inputs, ... }: 
{
  imports = [
      ./alacritty.nix
      ./qutebrowser.nix
      ./xsession.nix
  ];
  home.packages = with pkgs; [ ];
}
