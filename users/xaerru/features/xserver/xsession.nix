{ pkgs, ... }: {
  xsession = {
    enable = true;
    scriptPath = ".xinitrc";
    initExtra = ''
      udiskie &
      xsetroot -cursor_name left_ptr
      ~/.fehbg &
      brave &
      tabbed -c zathura -e &
      anki &
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
