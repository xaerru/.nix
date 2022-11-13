{ pkgs, inputs, config, ... }:

let colors = config.colorscheme.colors;
in
{
  programs.xmobar = {
    enable = true;
    extraConfig = ''
    Config { font    = "Source Code Pro 10px"
           , additionalFonts = [ "Jetbrains Mono Nerd Font 0px"
                               , "Font Awesome 5 Free Solid 10px"
                               , "Font Awesome 5 Brands 10px"
                               ]
           , bgColor = "#${colors.base00}"
           , fgColor = "#${colors.base08}"
           , position = Static { xpos = 0 , ypos = 0, width = 1920, height = 24 }
           , lowerOnStart = True
           , hideOnStart = False
           , allDesktops = True
           , persistent = True
           , iconRoot = "/home/xaerru/.nix/bin/xpm"
           , commands = [ Run Date "%a %B %e %H:%M" "date" 50
                        , Run Network "wlo1" ["-t", "<fn=2>\xf019</fn> <rx>kb <fn=2>\xf093</fn> <tx>kb"] 20
                        , Run Cpu ["-t", "<fn=2>\xf108</fn> <total>%","-H","50","--high","#${colors.base08}"] 20
                        , Run Memory ["-t","<fn=2>\xf233</fn> <used>M (<usedratio>%)"] 20
                        , Run DiskU [("/", "<fn=2>\xf0c7</fn> <free> free")] [] 60
                        , Run Com "uname" ["-r"] "" 3600
                        , Run UnsafeStdinReader
                        , Run BatteryP ["BAT1"]
                              [ "-t"
                              , "<acstatus>"
                              , "--"
                              , "--highs"
                              , "Bat: <left>%"
                              , "--mediums"
                              , "Bat: <left>%"
                              , "--lows"
                              , "Bat: <left>%"
                              , "-O"
                              , "<fc=#${colors.base0B}><fn=2>\xf1e6</fn></fc>"
                              , "-o"
                              , ""
                              , "-a"
                              , "notify-send -u critical 'Battery running out!!'"
                              , "-A"
                              , "5"
                              ] 30                        
                        , Run Com "/home/xaerru/.nix/bin/song.sh" [] "music" 10
                        , Run Com "/home/xaerru/.nix/bin/sound.sh" [] "sound" 10
                        , Run Com "/home/xaerru/.nix/bin/trayer-padding-icon.sh" [] "trayerpad" 10
                        , Run Com "python" ["-c", "from datetime import date; print((date(2023,1,1)-date.today()).days)"] "jeeadv" 3600
                        ]
           , sepChar = "%"
           , alignSep = "}{"
           , template = " <icon=profile.xpm/> <fc=#${colors.base04}>|</fc> %UnsafeStdinReader% }{ <fc=#${colors.base0B}>%music%</fc> <fc=#${colors.base04}>|</fc> <fc=#${colors.base08}>%jeeadv%</fc> <fc=#${colors.base04}>|</fc> <fc=#${colors.base0C}>%uname%</fc> <fc=#${colors.base04}>|</fc> <fc=#${colors.base0B}>%disku%</fc> <fc=#${colors.base04}>|</fc> <fc=#${colors.base0E}>Vol: %sound%</fc> <fc=#${colors.base04}>|</fc> <fc=#${colors.base0D}>%memory%</fc> <fc=#${colors.base04}>|</fc> <fc=#${colors.base0E}>%cpu%</fc> <fc=#${colors.base04}>|</fc> <fc=#${colors.base0D}>%wlo1%</fc> <fc=#${colors.base04}>|</fc> <fc=#${colors.base0B}>%battery%</fc> <fc=#${colors.base04}>|</fc> <fc=#${colors.base07}>%date%</fc> %trayerpad%"
    '';
  };
}
