{ pkgs, inputs, ... }: {
  imports = [
    ./alacritty.nix
    #./picom.nix
    ./xsession.nix
    ./xmobar.nix
    ./theme.nix
    ./dunst.nix
    ./qutebrowser.nix
    ./zathura.nix
  ];
  home.packages = with pkgs; [
    onlyoffice-bin
    #legendary-gl
    #appimage-run
    prismlauncher
    sxiv
    #gnome.cheese
    #pcmanfm
    #googleearth-pro
    #flameshot
    xmobar
    #trayer
    evince
    hsetroot
    tabbed
    #qbittorrent
    firefox
    # python39Packages.ueberzug
    #anki-bin
    ytfzf
    maim
    xdotool
    zoom-us
    xclip
    xsel
    dmenu
    #authy
    mpv
    keepassxc
    heroic
    #mcomix3
    jdt-language-server
  ];
}
