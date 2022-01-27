{ pkgs, inputs, ... }: 

{
  imports = [
      ./bash.nix
      ./tmux.nix
      ./autojump.nix
      ./direnv.nix
  ];
  home.packages = with pkgs; [
    cmus
    htop-vim
    age
    aria
    testdisk
    unzip
    torsocks
    taskwarrior
    exa
    bat
    parted
    tmux-mem-cpu-load
    youtube-dl
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
    tor
    weechat
    spotdl
    neomutt
  ];
}
