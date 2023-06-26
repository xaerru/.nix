{ pkgs, inputs, ... }:

{
  imports = [ ./bash.nix ./tmux.nix ./autojump.nix ];
  home.packages = with pkgs; [
    sfm
    spotdl
    gthumb
    docker-compose
    ngrok
    cmus
    colorpicker
    hyperfine
    mkvtoolnix
    btop
    iftop
    age
    aria
    testdisk
    unzip
    #bind
    #traceroute
    #mtr
    exa
    bat
    parted
    tmux-mem-cpu-load
    du-dust
    file
    ffmpeg
    fzf
    ltrace
    bintools-unwrapped
    acpi
    udiskie
    playerctl
    fd
    ripgrep
    tor-browser-bundle-bin
    weechat
    spotdl
    taskwarrior
    vit
    neomutt
  ];
}
