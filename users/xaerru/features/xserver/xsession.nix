{ pkgs, ... }: {
  xsession = {
    enable = true;
    scriptPath = ".xinitrc";
    initExtra = ''
      udiskie &
      xsetroot -cursor_name left_ptr
      hsetroot -solid "#181818"
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