{ pkgs, inputs, ... }:

{
  imports = [ ./bash.nix ./tmux.nix ./autojump.nix ];
  home.packages = with pkgs; [
    sfm
    watson
    #docker-compose
    cmus
    mkvtoolnix
    #htop-vim
    btop
    iftop
    age
    aria
    testdisk
    unzip
    #bind
    #traceroute
    #mtr
    torsocks
    #taskwarrior
    exa
    bat
    parted
    tmux-mem-cpu-load
    youtube-dl
    du-dust
    file
    ffmpeg
    fzf
    #ltrace
    #bintools-unwrapped
    acpi
    udiskie
    playerctl
    fd
    ripgrep
    tor
    weechat
    spotdl
    taskwarrior
    vit
    neomutt
  ];
}
