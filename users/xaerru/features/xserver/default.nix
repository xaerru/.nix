{ pkgs, inputs, ... }: 
{
  imports = [
      ./alacritty.nix
      ./qutebrowser.nix
      ./xsession.nix
      ./theme.nix
      ./dunst.nix
  ];
  home.packages = with pkgs; [ ];
}
