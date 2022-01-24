{ pkgs, inputs, ... }: 
{
  imports = [
      ./alacritty.nix
      ./qutebrowser.nix
      ./xsession.nix
      ./theme.nix
      ./dunst.nix
      ./zathura.nix
  ];
  home.packages = with pkgs; [ ];
}
