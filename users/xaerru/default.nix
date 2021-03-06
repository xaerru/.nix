{ pkgs, features, inputs, config, ... }:

with inputs.nix-colors.lib { inherit pkgs; };

let
  colors = config.colorscheme.colors;
  binPath = "/home/xaerru/.nix/bin";
in rec {
  imports = [ ./colors.nix ./services/tor.nix ./services/udiskie-custom.nix ]
    ++ pkgs.lib.forEach features (f: (./features + "/${f}"));
  home = {
    username = "xaerru";
    homeDirectory = "/home/xaerru";
    stateVersion = "22.05";
    sessionPath = [ "$HOME/.nix/bin" ];
    sessionVariables = { CUSTOM_BIN = "$HOME/.nix/bin"; };
  };

  programs.home-manager.enable = true;

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
    sshKeys = [ "13E0B25F8DF3A7D0DAB55F4290D620BE5F61B7CF" ];
    extraConfig = ''
      allow-preset-passphrase
    '';
  };
  home.packages = with pkgs; [
    clang-tools
    #emscripten
    #wasmer
    #valgrind
    #libuv
    rust-analyzer
    rnix-lsp
    bear
    #ctags
    linux-manual
    wolfram-engine
    wolfram-notebook
    #stylua
    cling
    nodejs
    #patchelf
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
    #nasm
    #hexyl
    #dhex
    #hyx
    crystal
    #sumneko-lua-language-server
    (rust-bin.stable.latest.default.override { targets = [ "wasm32-wasi" ]; })
  ];
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
    package = pkgs.gitFull;
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
        authorColors = { "Gauravsingh Sisodia" = "#${colors.base04}"; };
      };
      keybinding = { universal = { appendNewline = "<tab>"; }; };
    };
  };
}
