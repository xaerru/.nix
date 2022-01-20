{ pkgs, inputs, ... }:

with inputs.nix-colors.lib { inherit pkgs; };

let 
colors = inputs.nix-colors.colorSchemes.default-dark.colors;
binPath = "/home/xaerru/.nix/bin";
in rec {
  imports = [./services/tor.nix ./services/udiskie-custom.nix];
  home = {
    username = "xaerru";
    homeDirectory = "/home/xaerru";
    stateVersion = "22.05";
    sessionPath = ["$HOME/.nix/bin"];
    sessionVariables = {
       CUSTOM_BIN = "$HOME/.nix/bin";
    };
  };

  programs.home-manager.enable = true;

  programs.bash.enable = true;
  services.tor.enable = true;
  services.udiskie-custom = {
     enable = true;
     settings = {
        program_options = {
          notify = false;
	  notify_command = "${binPath}/udiskie.sh {event} {mount_path}";
	};
     };
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gtk2";
    defaultCacheTtl = 34560000;
    defaultCacheTtlSsh = 34560000;
    maxCacheTtl = 34560000;
    maxCacheTtlSsh = 34560000;
    sshKeys = [ "13E0B25F8DF3A7D0DAB55F4290D620BE5F61B7CF" ];
    extraConfig = ''
      allow-preset-passphrase
    '';
  };
  home.packages = with pkgs; [
    clang-tools
    bear
    ctags
    patchelf
    cached-nix-shell
    xsel
    man-pages
    cmus
    spotdl
    neomutt
    gdb
    file
    du-dust
    authy
    lua
    htop-vim
    age
    ltrace
    bintools-unwrapped
    virt-manager
    keepassxc
    aria
    testdisk
    udiskie
    unzip
    hsetroot
    qbittorrent
    torsocks
    tor
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
    fzf
    zoom-us
    brave
    exa
    fd
    ripgrep
    xclip
    cmake
    ninja
    dmenu
    neovim
    mpv
    firefox
    youtube-dl
  ];
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        primary = {
          background = "#${colors.base00}";
          foreground = "#${colors.base05}";
        };
        cursor = {
          text = "#${colors.base00}";
          cursor = "#${colors.base05}";
        };
        normal = {
          black = "#${colors.base00}";
          red = "#${colors.base08}";
          green = "#${colors.base0B}";
          yellow = "#${colors.base0A}";
          blue = "#${colors.base0D}";
          magenta = "#${colors.base0E}";
          cyan = "#${colors.base0C}";
          white = "#${colors.base05}";
        };
        bright = {
          black = "#${colors.base03}";
          red = "#${colors.base08}";
          green = "#${colors.base0B}";
          yellow = "#${colors.base0A}";
          blue = "#${colors.base0D}";
          magenta = "#${colors.base0E}";
          cyan = "#${colors.base0C}";
          white = "#${colors.base07}";
        };
        indexed_colors = [
          {
            index = 16;
            color = "#${colors.base09}";
          }
          {
            index = 17;
            color = "#${colors.base0F}";
          }
          {
            index = 18;
            color = "#${colors.base01}";
          }
          {
            index = 19;
            color = "#${colors.base02}";
          }
          {
            index = 20;
            color = "#${colors.base04}";
          }
          {
            index = 21;
            color = "#${colors.base06}";
          }
        ];
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
    loadAutoconfig = true;
    settings = {
      tabs = {
        show = "multiple";
      };
      colors = {
        webpage = {
	  darkmode = {
	    enabled = true;
	    algorithm = "lightness-hsl";
	    contrast = -.022;
	    threshold = {
	      text = 150;
	      background = 100;
	    };
	    policy.images = "always";
	    grayscale.images = 0.35;
	  };
          preferred_color_scheme = "dark";
          bg = "#${colors.base00}";
        };
        completion = {
          fg = "#${colors.base05}";
          match.fg = "#${colors.base09}";
          even.bg = "#${colors.base00}";
          odd.bg = "#${colors.base00}";
          scrollbar = {
            bg = "#${colors.base00}";
            fg = "#${colors.base05}";
          };
          category = {
            bg = "#${colors.base00}";
            fg = "#${colors.base0D}";
            border = {
              bottom = "#${colors.base00}";
              top = "#${colors.base00}";
            };
          };
          item.selected = {
            bg = "#${colors.base02}";
            fg = "#${colors.base05}";
            match.fg = "#${colors.base05}";
            border = {
              bottom = "#${colors.base02}";
              top = "#${colors.base02}";
            };
          };
        };
        contextmenu = {
          disabled = {
            bg = "#${colors.base01}";
            fg = "#${colors.base04}";
          };
          menu = {
            bg = "#${colors.base00}";
            fg = "#${colors.base05}";
          };
          selected = {
            bg = "#${colors.base02}";
            fg = "#${colors.base05}";
          };
        };
        downloads = {
          bar.bg = "#${colors.base00}";
          error.fg = "#${colors.base08}";
          start = {
            bg = "#${colors.base0D}";
            fg = "#${colors.base00}";
          };
          stop = {
            bg = "#${colors.base0C}";
            fg = "#${colors.base00}";
          };
        };
        hints = {
          bg = "#${colors.base0A}";
          fg = "#${colors.base00}";
          match.fg = "#${colors.base05}";
        };
        keyhint = {
          bg = "#${colors.base00}";
          fg = "#${colors.base05}";
          suffix.fg = "#${colors.base05}";
        };
        messages = {
          error.bg = "#${colors.base08}";
          error.border = "#${colors.base08}";
          error.fg = "#${colors.base00}";
          info.bg = "#${colors.base00}";
          info.border = "#${colors.base00}";
          info.fg = "#${colors.base05}";
          warning.bg = "#${colors.base0E}";
          warning.border = "#${colors.base0E}";
          warning.fg = "#${colors.base00}";
        };
        prompts = {
          bg = "#${colors.base00}";
          fg = "#${colors.base05}";
          border = "#${colors.base00}";
          selected.bg = "#${colors.base02}";
        };
        statusbar = {
          caret.bg = "#${colors.base00}";
          caret.fg = "#${colors.base0D}";
          caret.selection.bg = "#${colors.base00}";
          caret.selection.fg = "#${colors.base0D}";
          command.bg = "#${colors.base01}";
          command.fg = "#${colors.base04}";
          command.private.bg = "#${colors.base01}";
          command.private.fg = "#${colors.base0E}";
          insert.bg = "#${colors.base00}";
          insert.fg = "#${colors.base0C}";
          normal.bg = "#${colors.base00}";
          normal.fg = "#${colors.base05}";
          passthrough.bg = "#${colors.base00}";
          passthrough.fg = "#${colors.base0A}";
          private.bg = "#${colors.base00}";
          private.fg = "#${colors.base0E}";
          progress.bg = "#${colors.base0D}";
          url.error.fg = "#${colors.base08}";
          url.fg = "#${colors.base05}";
          url.hover.fg = "#${colors.base09}";
          url.success.http.fg = "#${colors.base0B}";
          url.success.https.fg = "#${colors.base0B}";
          url.warn.fg = "#${colors.base0E}";
        };
        tabs = {
          bar.bg = "#${colors.base00}";
          even.bg = "#${colors.base00}";
          even.fg = "#${colors.base05}";
          indicator.error = "#${colors.base08}";
          indicator.start = "#${colors.base0D}";
          indicator.stop = "#${colors.base0C}";
          odd.bg = "#${colors.base00}";
          odd.fg = "#${colors.base05}";
          pinned.even.bg = "#${colors.base0B}";
          pinned.even.fg = "#${colors.base00}";
          pinned.odd.bg = "#${colors.base0B}";
          pinned.odd.fg = "#${colors.base00}";
          pinned.selected.even.bg = "#${colors.base02}";
          pinned.selected.even.fg = "#${colors.base05}";
          pinned.selected.odd.bg = "#${colors.base02}";
          pinned.selected.odd.fg = "#${colors.base05}";
          selected.even.bg = "#${colors.base02}";
          selected.even.fg = "#${colors.base05}";
          selected.odd.bg = "#${colors.base02}";
          selected.odd.fg = "#${colors.base05}";
        };
      };
    };
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
       git = {
          autoFetch = false;
       };
       gui = {
         showRandomTip = false;
	 authorColors = {
           "Gauravsingh Sisodia" = "#7cafc2";
	 };
       };
       keybindings = {
         universal = {appendNewline = "<tab>";};
       };
     };
  };
  xsession = {
     enable = true;
     initExtra = ''
       udiskie &
       xsetroot -cursor_name left_ptr
       hsetroot -solid "#181818"
     '';
     windowManager = {
       xmonad = {
          enable = true;
          enableContribAndExtras = true;
          config = ./config/xmonad/xmonad.hs;
       };
     };
  };
  gtk = {
     enable = true;
     theme = {
      name = "default-dark";
      package = gtkThemeFromScheme { scheme = inputs.nix-colors.colorSchemes.default-dark; };
    };
  };
  qt = {
     enable = true;
     platformTheme = "gtk";
  };
  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "${gtk.theme.name}";
    };
  };
  services.dunst = {
     enable = true;
  };
}
