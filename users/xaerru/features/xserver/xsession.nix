{ pkgs, ... }: {
  xsession = {
    enable = true;
    scriptPath = ".xinitrc";
    initExtra = ''
      udiskie &
      xsetroot -cursor_name left_ptr
      ~/.fehbg &
      brave &
      anki &
      qbittorrent &
      tabbed -c zathura -e &
    '';
    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = ../../config/xmonad/xmonad.hs;
      };
    };
  };
}
