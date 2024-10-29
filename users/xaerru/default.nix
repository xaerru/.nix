{ pkgs, features, inputs, config, ... }:

let
  colors = config.colorscheme.palette;
  binPath = "/home/xaerru/.nix/bin";
in rec {
  imports = [ ./colors.nix ./services/tor.nix ./services/udiskie-custom.nix ]
    ++ pkgs.lib.forEach features (f: (./features + "/${f}"));
  home = {
    username = "xaerru";
    homeDirectory = "/home/xaerru";
    stateVersion = "22.05";
    sessionPath = [ "$HOME/.local/bin" "$HOME/.nix/bin" ];
    sessionVariables = { CUSTOM_BIN = "$HOME/.nix/bin"; };
  };

  programs.home-manager.enable = true;
  xdg.systemDirs.data = ["/var/lib/flatpak/exports/share" "/home/xaerru/.local/share/flatpak/exports/share"];
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
  services.gammastep = {
    enable = true;
    latitude = 18.64;
    longitude = 73.77;
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gtk2";
    defaultCacheTtl = 34560000;
    defaultCacheTtlSsh = 34560000;
    maxCacheTtl = 34560000;
    maxCacheTtlSsh = 34560000;
    sshKeys = [ "971C6775AA01488499900C2CD148E93114E64EF7" ];
    extraConfig = ''
      allow-preset-passphrase
    '';
  };
  home.packages = with pkgs; [
    clang-tools
    #emscripten
    #wasmer
    valgrind
    #libuv
    rust-analyzer
    #rnix-lsp
    bear
    ctags
    linux-manual
    stylua
    cling
    nodejs
    patchelf
    cached-nix-shell
    man-pages
    gdb
    lua
    nixfmt
    python3
    ghc
    cmake
    ninja
    feh
    neovim
    nasm
    hexyl
    #dhex
    #hyx
    crystal
    sumneko-lua-language-server
    filezilla
    distrobox
    blueman
    xorg.xhost
    cabal-install
    haskell-language-server
    cachix
    haskellPackages.ghcid
    python311Packages.jedi-language-server
    ormolu
    verilog
    nmap
    haskellPackages.hakyll
    wireshark
    verilator
    zulu17 # OpenJDK
    java-language-server
    #gradle_7
    cachix
    openssh
    (rust-bin.stable.latest.default.override { targets = [ "wasm32-wasi" ]; })
    pwntools
    openvpn
    inetutils
    python311Packages.binwalk-full
    blender
    xorg.xdpyinfo
    obs-studio
    mysql-workbench
  ];
  #programs.ssh = {
    #enable = true;
    #extraConfig = builtins.readFile ./config/ssh/config;
  #};
  programs.gpg = {
    enable = true;
    settings.use-agent = false;
  };
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Gauravsingh Sisodia";
    userEmail = "xaerru@gmail.com";
    signing = {
      signByDefault = true;
      key = "360012AC79B436D0";
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
        authorColors = { "Gauravsingh Sisodia" = "#${colors.base04}"; };
      };
      keybinding = { universal = { appendNewline = "<tab>"; }; };
    };
  };
}
