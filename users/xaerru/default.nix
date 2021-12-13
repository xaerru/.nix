{ config, pkgs, ... }:

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
    extraConfig = ''
      allow-preset-passphrase
    '';
  };
  home.packages = with pkgs; [
    zoom-us
    brave
    qutebrowser
    dunst
    feh
    picom
    fish
    tmux
    exa
    fd
    dust
    xclip
    cmake
    ninja
    dmenu
    neovim
    hsetroot
    mpv
    firefox
    pinentry-curses
    gnupg
    (dwm.overrideAttrs (oldAttrs: rec {
      patches = [
        ./config/dwm/xaerru-custom-config.diff
        (fetchpatch {
          url =
            "https://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
          sha256 = "114xcy1qipq6cyyc051yy27aqqkfrhrv9gjn8fli6gmkr0x6pk52";
        })
      ];
    }))
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
      env = {
          TERM = "xterm-256color";
      };
      font = {
        size = 8;
      };
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
}
