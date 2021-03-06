{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      v = "nvim";
      c = "clear";
      cat = "bat";
      getip = "curl ifconfig.me";
      cdc = "cd && clear";
      lg = "lazygit";
      ls = "exa -l --color=always --group-directories-first";
      la = "exa -al --color=always --group-directories-first";
      "l." = "exa -a | rg '^.'";
      ".." = "cd ..";
    };
    sessionVariables = { MANPAGER = "nvim +Man!"; EDITOR = "nvim"; };
    profileExtra = ''
      if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        startx
      fi
    '';
    bashrcExtra = ''
      ex ()
      {
        if [ -f "$1" ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *.deb)       ar x $1      ;;
            *.tar.xz)    tar xf $1    ;;
            *.tar.zst)   unzstd $1    ;;
            *)           echo "'$1' cannot be extracted via ex()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }
    '';
  };
}
