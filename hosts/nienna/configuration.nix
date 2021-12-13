{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      devices = [ "nodev" ];
      enable = true;
      efiSupport = true;
      useOSProber = true;
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nienna";
  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlo1" ];
  networking.wireless.networks = {
    BSNLHOME = {
      pskRaw =
        "600249ce41cefcc15efbd6b55ec3621911e13e75f24244f2fdc0496394d4c969";
    };
  };

  time.timeZone = "Asia/Kolkata";
  services.kmonad = {
    enable = true;
    configfiles = [ ../../users/xaerru/config/kmonad/ducky.kbd ];
  };

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlo1.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  programs.ssh.startAgent = false;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.naturalScrolling = true;
  services.xserver.xkbOptions = "compose:ralt";

  users.users.xaerru = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    gcc
    git
    gnumake
    lynx
    alacritty
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
    gcc
    dmenu
    neovim
    hsetroot
    mpv
    firefox
  ];
  environment.etc."X11/xorg.conf.d/20-intel.conf" = {
    text = ''
      Section "Device"
        Identifier "Intel Graphics"
        Driver "intel"
        Option "TearFree" "true"
        Option "AccelMethod" "sna"
        Option "SwapbuffersWait" "true"
      EndSection
    '';
  };
  nixpkgs.config.allowBroken = true;
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "xaerru" ];
  system.stateVersion = "21.11";
}

