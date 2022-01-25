{ pkgs, inputs, ... }: 
{
  imports = [
      ./bash.nix
      ./tmux.nix
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
    parted
    tmux-mem-cpu-load
    youtube-dl
    du-dust
    file
    ffmpeg
    fzf
    ltrace
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
