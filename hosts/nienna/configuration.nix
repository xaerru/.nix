{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        devices = [ "nodev" ];
        enable = true;
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 42;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "nienna";
    wireless = {
      enable = true;
      interfaces = [ "wlo1" ];
      networks = {
        JoJo = {
          pskRaw =
            "25b9c5903c7a501df7c23e6884b272a9a292a895e72d01a1eaf43f860d5d2b09";
        };
      };
    };
    interfaces = {
      eno1.useDHCP = true;
      wlo1.useDHCP = true;
    };
  };

  time.timeZone = "Asia/Kolkata";
  services.kmonad = {
    enable = true;
    configfiles = [ ../../users/xaerru/config/kmonad/ducky.kbd ];
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
    };
    xkbOptions = "compose:ralt";
    autoRepeatDelay = 300;
    autoRepeatInterval = 15;
  };

  users.users.xaerru = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "input" "lxd" "vboxusers" "libvirtd" ];
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    #noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  environment.systemPackages = with pkgs; [ vim wget gcc git gnumake lynx ];
  services.getty.autologinUser = "xaerru";

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

  programs.dconf.enable = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.lxd.enable = true;

  system.stateVersion = "21.11";
}

