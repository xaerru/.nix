{ pkgs, features, inputs, ... }:

with inputs.nix-colors.lib { inherit pkgs; };

let
  colors = inputs.nix-colors.colorSchemes.default-dark.colors;
  binPath = "/home/xaerru/.nix/bin";
in rec {
  imports = [ ./services/tor.nix ./services/udiskie-custom.nix ]++pkgs.lib.forEach features (f: (./features + "/${f}"));
  home = {
    username = "xaerru";
    homeDirectory = "/home/xaerru";
    stateVersion = "22.05";
    sessionPath = [ "$HOME/.nix/bin" ];
    sessionVariables = { CUSTOM_BIN = "$HOME/.nix/bin"; };
  };

  programs.home-manager.enable = true;

  programs.bash.enable = true;
  #services.tor.enable = true;
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
    rust-analyzer
    rnix-lsp
    bear
    ctags
    linux-manual
    stylua
    acpi
    cling
    rustup
    nodejs
    patchelf
    cached-nix-shell
    lxc
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
    nasm
    parted
    sumneko-lua-language-server
    mpv
    firefox
    youtube-dl
    tmux-mem-cpu-load
  ];
  programs.tmux = {
    enable = true;
    clock24 = true;
    disableConfirmationPrompt = true;
    escapeTime = 150;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      pain-control
      fzf-tmux-url
      {
        plugin = battery;
        extraConfig = ''
          set -g status-right '[#(tmux-mem-cpu-load)][#{battery_percentage}][%d-%m:%w][%H:%M][#H]'
          set -g status-right-length '150'
        '';
      }
    ];
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
      git = { autoFetch = false; };
      gui = {
        showRandomTip = false;
        authorColors = { "Gauravsingh Sisodia" = "#7cafc2"; };
      };
      keybindings = { universal = { appendNewline = "<tab>"; }; };
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "default-dark";
      package = gtkThemeFromScheme {
        scheme = inputs.nix-colors.colorSchemes.default-dark;
      };
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };
  services.xsettingsd = {
    enable = true;
    settings = { "Net/ThemeName" = "${gtk.theme.name}"; };
  };
  services.dunst = { enable = true; };
  programs.zathura = {
    enable = true;
    options = {
        notification-error-bg       ="#${colors.base08}";
        notification-error-fg       ="#${colors.base05}";
        notification-warning-bg     ="#${colors.base0A}";
        notification-warning-fg     ="#${colors.base02}";
        notification-bg             ="#${colors.base00}";
        notification-fg             ="#${colors.base05}";
        completion-bg               ="#${colors.base00}";
        completion-fg               ="#${colors.base0D}";
        completion-group-bg         ="#${colors.base00}";
        completion-group-fg         ="#${colors.base0D}";
        completion-highlight-bg     ="#${colors.base02}";
        completion-highlight-fg     ="#${colors.base05}";
        index-bg                    ="#${colors.base00}";
        index-fg                    ="#${colors.base05}";
        index-active-bg             ="#${colors.base02}";
        index-active-fg             ="#${colors.base05}";
        inputbar-bg                 ="#${colors.base00}";
        inputbar-fg                 ="#${colors.base05}";
        statusbar-bg                ="#${colors.base00}";
        statusbar-fg                ="#${colors.base05}";
        highlight-color             ="#${colors.base0A}";
        highlight-active-color      ="#${colors.base0E}";
        default-bg                  ="#${colors.base00}";
        default-fg                  ="#${colors.base05}";
        render-loading-fg           ="#${colors.base00}";
        render-loading-bg           ="#${colors.base05}";
        recolor-lightcolor          ="#${colors.base00}";
        recolor-darkcolor           ="#${colors.base05}";
        render-loading = true;
        window-title-basename= true;
        selection-clipboard = "clipboard";
        recolor = true;
        adjust-open = "width";
        };
  };
}
