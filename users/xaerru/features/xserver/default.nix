{ pkgs, inputs, ... }: 
{
  imports = [
      ./alacritty.nix
      ./qutebrowser.nix
      ./xsession.nix
      ./theme.nix
  ];
  home.packages = with pkgs; [ ];
}
