{ pkgs, inputs, ... }: 
{
  imports = [
      ./bash.nix
      ./tmux.nix
  ];
  home.packages = with pkgs; [ ];
}
