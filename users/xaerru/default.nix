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
    cling
    rustup
    nodejs
    patchelf
    cached-nix-shell
    lxc
    man-pages
    gdb
    lua
    nixfmt
    python3
    ghc
    cmake
    ninja
    neovim
    nasm
    sumneko-lua-language-server
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
}
