{ pkgs, inputs, ... }: {
  imports = [
    ./alacritty.nix
    ./xsession.nix
    ./theme.nix
    ./dunst.nix
    ./zathura.nix
  ];
  home.packages = with pkgs; [
    #libreoffice
    hsetroot
    tabbed
    #qbittorrent
    python39Packages.ueberzug
    anki-bin
    ytfzf
    maim
    xdotool
    zoom-us
    brave
    xclip
    xsel
    dmenu
    authy
    #webcamoid
    mpv
    keepassxc
    #mcomix3
  ];
}
