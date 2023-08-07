{ pkgs, ... }: {
  xsession = {
    enable = true;
    scriptPath = ".xinitrc";
    initExtra = ''
      if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
              eval $(dbus-launch --exit-with-session --sh-syntax)
      fi
      systemctl --user import-environment DISPLAY XAUTHORITY

      if command -v dbus-update-activation-environment >/dev/null 2>&1; then
              dbus-update-activation-environment DISPLAY XAUTHORITY
      fi      
      udiskie &
      xsetroot -cursor_name left_ptr
      ~/.fehbg &
      #hsetroot -solid "#181818"
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
