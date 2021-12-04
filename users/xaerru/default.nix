{ config, pkgs, ... }:

{
  home.username = "xaerru";
  home.homeDirectory = "/home/xaerru";
  programs.home-manager.enable = true;
  home.packages= with pkgs; [ dwm zoom-us ];
}
