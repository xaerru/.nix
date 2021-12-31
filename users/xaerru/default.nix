{ pkgs, ... }:

{
  home = {
    username = "xaerru";
    homeDirectory = "/home/xaerru";
    stateVersion = "22.05";
  };

  programs.home-manager.enable = true;

  programs.bash.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "curses";
    defaultCacheTtl = 34560000;
    defaultCacheTtlSsh = 34560000;
    maxCacheTtl = 34560000;
    maxCacheTtlSsh = 34560000;
    sshKeys = [ "13E0B25F8DF3A7D0DAB55F4290D620BE5F61B7CF" ];
    extraConfig = ''
      allow-preset-passphrase
    '';
  };
  programs.java.enable = true;
  home.packages = with pkgs; [
    weechat
    ffmpeg
    python39Packages.ueberzug
    ytfzf
    maim
    xdotool
    playerctl
    taskwarrior
    nixfmt
    python3
    ghc
    dwm
    fzf
    zoom-us
    brave
    exa
    fd
    xclip
    cmake
    ninja
    dmenu
    neovim
    mpv
    firefox
    pinentry-curses
  ];
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        primary = {
          background = "0x282828";
          foreground = "0xd8d8d8";
        };
      };
      env = { TERM = "xterm-256color"; };
      font = { size = 8; };
      selection.save_to_clipboard = true;
      window = {
        decorations = "full";
        padding = {
          x = 5;
          y = 5;
        };
      };
    };
  };
  programs.qutebrowser = {
    enable = true;
    settings = {
      colors.webpage.preferred_color_scheme = "dark";
      colors.webpage.darkmode.enabled = true;
    };
    extraConfig = builtins.readFile (builtins.fetchurl {
      url =
        "https://raw.githubusercontent.com/theova/base16-qutebrowser/e47e7e03ccb8909a4751d3507cc3c3ad243f13c0/themes/minimal/base16-default-dark.config.py";
      sha256 = "169ybhn0cl9fqhfxgs3srdqxia6lhvvbmqlcd7bpjdnyj3v5jn7q";
    });
  };
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [ sensible pain-control fzf-tmux-url ];
    extraConfig = builtins.readFile ./config/tmux.conf;
  };
  programs.ssh = {
    enable = true;
    extraConfig = builtins.readFile ./config/ssh/config;
  };
  programs.gpg = {
    enable = true;
    settings.use-agent = false;
  };
  programs.git = {
    enable = true;
    userName = "Gauravsingh Sisodia";
    userEmail = "xaerru@disroot.org";
    signing = {
      signByDefault = true;
      key = "68831668597E023C!";
    };
    extraConfig = { init = { defaultBranch = "main"; }; };
    lfs = { enable = true; };
  };
  programs.lazygit = {
     enable = true;
     settings = {
       gui = {
         showRandomTip = false;
	 authorColors = {
           "Gauravsingh Sisodia" = "#7cafc2";
	 };
       };
       keybindings = {
         universal = {appendNewLine = "<tab>";};
       };
     };
  };
  xsession.enable = true;
  xsession.windowManager.xmonad.enable = true;
  xsession.windowManager.xmonad.enableContribAndExtras = true;
  xsession.windowManager.xmonad.config = ./config/xmonad/xmonad.hs;
}
