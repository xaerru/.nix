{ pkgs, ... }:

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
      ls = "eza -l --color=always --group-directories-first";
      la = "eza -al --color=always --group-directories-first";
      "l." = "eza -a | rg '^.'";
      ".." = "cd ..";
    };
    sessionVariables = { MANPAGER = "nvim +Man!"; EDITOR = "nvim"; };
    profileExtra = ''
        if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
        . startx
        logout
        fi
    '';
    initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
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
      export PS1="\n\[$(tput bold)\]\[$(tput setaf 2)\][\u@\h:\w]\\$ \[$(tput sgr0)\]"
    '';
  };
}
