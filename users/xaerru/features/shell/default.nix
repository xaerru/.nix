{ pkgs, inputs, ... }: 
{
  imports = [
      ./bash.nix
  ];
  home.packages = with pkgs; [ ];
}
