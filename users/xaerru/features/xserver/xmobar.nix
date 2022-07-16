{ pkgs, inputs, config, ... }:

{
  programs.xmobar = {
    enable = true;
    extraConfig = ''
    Config { font    = "xft:Source Code Pro:pixelsize=10:antialias=true:hinting=true"
           , additionalFonts = [ "xft:Jetbrains Mono Nerd Font:pixelsize=0:antialias=true:hinting=true"
                               , "xft:Font Awesome 5 Free Solid:pixelsize=10"
                               , "xft:Font Awesome 5 Brands:pixelsize=10"
                               ]
           , bgColor = "#2E3440"
           , fgColor = "#BF616A"
           , position = Static { xpos = 0 , ypos = 0, width = 1920, height = 24 }
           , lowerOnStart = True
           , hideOnStart = False
           , allDesktops = True
           , persistent = True
           , commands = [ Run Date "%a %B %e %H:%M" "date" 50
                        , Run Network "wlo1" ["-t", "<fn=2>\xf019</fn> <rx>kb <fn=2>\xf093</fn> <tx>kb"] 20
                        , Run Cpu ["-t", "<fn=2>\xf108</fn> <total>%","-H","50","--high","#BF616A"] 20
                        , Run Memory ["-t","<fn=2>\xf233</fn> <used>M (<usedratio>%)"] 20
                        , Run DiskU [("/", "<fn=2>\xf0c7</fn> <free> free")] [] 60
                        , Run Com "uname" ["-r"] "" 3600
                        , Run UnsafeStdinReader
                        , Run BatteryP ["BAT0"]
                                 ["-t", "<acstatus>"
                                 , "-S", "Off", "-d", "0", "-m", "3"
                                 , "-L", "10", "-H", "90", "-p", "3"
                                 , "-W", "0"
                                 , "-f", "\xf244\xf243\xf243\xf243\xf242\xf242\xf242\xf241\xf241\xf240"
                                 , "--"
                                 , "-P"
                                 , "-a", "notify-send -u critical 'Battery running out!!!!!!'"
                                 , "-A", "5"
                                 , "-i", "<fn=2>\xf1e6</fn>"
                                 , "-O", "<fn=2><leftbar>  \xf1e6</fn> <timeleft>"
                                 , "-o", "<fn=2><leftbar></fn1> <timeleft>"
                                 , "-H", "10", "-L", "7"
                                 ] 50
                        , Run Com "/home/xaerru/.nix/bin/song.sh" [] "music" 10
                        , Run Com "/home/xaerru/.nix/bin/sound.sh" [] "sound" 10
                        , Run Com "/home/xaerru/.nix/bin/trayer-padding-icon.sh" [] "trayerpad" 10
                        ]
           , sepChar = "%"
           , alignSep = "}{"
           , template = " <fc=#A3BE8C>xaerru</fc> <fc=#666666>|</fc> %UnsafeStdinReader% }{ <fc=#A3BE8C>%music%</fc> <fc=#666666>|</fc> <fc=#8FBCBB>%uname%</fc> <fc=#666666>|</fc> <fc=#A3BE8C>%disku%</fc> <fc=#666666>|</fc> <fc=#B48EAD>Vol: %sound%</fc> <fc=#666666>|</fc> <fc=#88C0D0>%memory%</fc> <fc=#666666>|</fc> <fc=#B48EAD>%cpu%</fc> <fc=#666666>|</fc> <fc=#88C0D0>%wlo1%</fc> <fc=#666666>|</fc> <fc=#A3BE8C>%battery%</fc> <fc=#666666>|</fc> <fc=#D8DEE9>%date%</fc> %trayerpad%"}
    '';
  };
}
