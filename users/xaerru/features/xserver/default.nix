{ pkgs, inputs, ... }: {
  imports = [
    ./alacritty.nix
    ./xsession.nix
    ./theme.nix
    ./dunst.nix
    ./qutebrowser.nix
    ./zathura.nix
  ];
  home.packages = with pkgs; [
    libreoffice
    hsetroot
    qbittorrent
    python39Packages.ueberzug
    anki
    ytfzf
    maim
    xdotool
    zoom-us
    brave
    xclip
    xsel
    dmenu
    authy
    webcamoid
    mpv
    keepassxc
    mcomix3
  ];
}
